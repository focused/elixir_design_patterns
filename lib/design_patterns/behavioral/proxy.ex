defmodule DesignPatterns.Behavioral.Proxy do
  defmodule BankAccount do
    use GenServer

    @initial_state %{balance: 0, transactions: []}

    @spec start_link(map) :: GenServer.on_start()
    def start_link(state \\ @initial_state), do: GenServer.start_link(__MODULE__, state)

    @spec deposit(pid, any) :: any
    def deposit(account, money), do: GenServer.call(account, {:deposit, money})

    @spec withdraw(pid, any) :: any
    def withdraw(account, money), do: GenServer.call(account, {:withdraw, money})

    @spec balance(pid) :: any
    def balance(account), do: GenServer.call(account, :balance)

    @impl true
    def init(init_arg), do: {:ok, init_arg}

    @impl true
    def handle_call({:deposit, money}, _from, state) when money > 0 do
      new_state = %{
        balance: state.balance + money,
        transactions: [{:deposit, money} | state.transactions]
      }

      {:reply, {:ok, new_state.balance}, new_state}
    end

    def handle_call({:withdraw, money}, _from, state) when money < state.balance do
      new_state = %{
        balance: state.balance - money,
        transactions: [{:withdraw, money} | state.transactions]
      }

      {:reply, {:ok, new_state.balance}, new_state}
    end

    def handle_call(:balance, _from, state), do: {:reply, {:ok, state.balance}, state}
  end

  defmodule PrivacyProxy do
    @spec intercept(module) :: :ok
    def intercept(account) do
      receive do
        {:"$gen_call", from, :balance} -> halt(from)
        {:"$gen_call", from, message} -> forward(account, from, message)
      end

      intercept(account)
    end

    @spec halt({pid, any}) :: :ok
    defp halt(from), do: GenServer.reply(from, {:ok, :hidden})

    @spec forward(module, {pid, any}, any) :: :ok
    defp forward(account, from, message) do
      result = GenServer.call(account, message)
      GenServer.reply(from, result)
    end
  end
end
