defmodule DesignPatterns.Creational.Singleton do
  use GenServer

  @name :singleton
  @initial_value nil

  def start_link(value) do
    GenServer.start_link(__MODULE__, value || @initial_value, name: @name)
  end

  def value, do: GenServer.call(@name, :read)

  def update(value), do: GenServer.call(@name, {:write, value})

  @impl true
  def init(init_arg), do: {:ok, init_arg}

  @impl true
  def handle_call(:read, _from, value), do: {:reply, value, value}
  def handle_call({:write, value}, _from, _old_value), do: {:reply, :ok, value}
end
