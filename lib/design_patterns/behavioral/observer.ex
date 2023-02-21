defmodule DesignPatterns.Behavioral.Observer do
  defmodule HR do
    use GenServer

    def start_link(event_handler) do
      GenServer.start_link(__MODULE__, %{event_handler: event_handler, employee: nil},
        name: __MODULE__
      )
    end

    def update(changes), do: GenServer.call(__MODULE__, {:update, changes})

    @impl true
    def init(init_arg), do: {:ok, init_arg}

    @impl true
    def handle_call({:update, changes}, _from, state) do
      updated = Map.merge(state.employee, changes)
      GenServer.call(state.event_handler, {:changed, updated})

      {:reply, :ok, %{state | employee: updated}}
    end
  end

  defmodule Employee do
    defstruct name: nil, title: nil, salary: 0
  end

  defmodule Payroll do
    use GenServer

    def start_link(parent), do: GenServer.start_link(__MODULE__, parent, name: __MODULE__)

    @impl true
    def init(init_arg), do: {:ok, init_arg}

    @impl true
    def handle_call({:changed, employee} = event, _from, parent) do
      IO.puts("His salary is now #{employee.salary}!")
      IO.puts("Cut a new check for #{employee.name}!")
      send(parent, event)

      {:reply, {:changed, employee}, parent}
    end
  end
end
