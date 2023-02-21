defmodule DesignPatterns.Behavioral.Command do
  defmodule FileCommand do
    @callback exec(binary, keyword) :: :ok
    @callback undo(binary, keyword) :: :ok
  end

  defmodule Copy do
    @behaviour FileCommand

    @impl true
    def exec(source, to: dest), do: IO.puts("cp #{source} #{dest}")

    @impl true
    def undo(_source, to: dest), do: IO.puts("rm #{dest}")
  end

  defmodule Create do
    @behaviour FileCommand

    @impl true
    def exec(path, data: data), do: IO.puts(~s|echo "#{data}" > #{path}|)

    @impl true
    def undo(path, _opts), do: IO.puts("mv #{path} /path/to/trash")
  end

  defmodule Delete do
    @behaviour FileCommand

    @impl true
    def exec(path, _), do: IO.puts("mv #{path} /path/to/trash")

    @impl true
    def undo(path, _), do: IO.puts("mv /path/to/trash/#{Path.basename(path)} #{path}")
  end

  defmodule Runner do
    use GenServer

    def start_link(_) do
      GenServer.start_link(__MODULE__, %{done: [], undone: []}, name: __MODULE__)
    end

    def exec(commands), do: GenServer.call(__MODULE__, {:exec, commands})

    def undo(), do: GenServer.call(__MODULE__, :undo)

    def redo(), do: GenServer.call(__MODULE__, :redo)

    @impl true
    def init(init_arg), do: {:ok, init_arg}

    @impl true
    def handle_call({:exec, commands}, _from, state) do
      commands |> List.wrap() |> Enum.each(&run/1)
      {:reply, :ok, %{state | done: Enum.reverse(commands) ++ state.done}}
    end

    def handle_call(:undo, _from, state = %{done: [command | t]}) do
      run(command, :undo)
      state = %{state | done: t, undone: [command | state.undone]}

      {:reply, :ok, state}
    end

    def handle_call(:redo, _from, state = %{undone: [command | t]}) do
      run(command)
      state = %{state | undone: t, done: [command | state.done]}

      {:reply, :ok, state}
    end

    defp run(command, op \\ :exec)
    defp run({mod, arg}, op), do: apply(mod, op, [arg, []])
    defp run({mod, arg, opts}, op), do: apply(mod, op, [arg, opts])
  end
end
