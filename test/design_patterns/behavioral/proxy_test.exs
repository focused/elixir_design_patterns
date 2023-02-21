defmodule DesignPatterns.Behavioral.ProxyTest do
  use ExUnit.Case
  alias DesignPatterns.Behavioral.Proxy.{BankAccount, PrivacyProxy}

  setup do
    {:ok, account} = BankAccount.start_link()
    %{account: account}
  end

  test "without interceptor", %{account: account} do
    assert BankAccount.deposit(account, 100) == {:ok, 100}
    assert BankAccount.withdraw(account, 10) == {:ok, 90}
    assert BankAccount.balance(account) == {:ok, 90}
    assert BankAccount.deposit(account, 10) == {:ok, 100}
  end

  test "with interceptor", %{account: account} do
    proxy = spawn(PrivacyProxy, :intercept, [account])

    assert BankAccount.deposit(proxy, 100) == {:ok, 100}
    assert BankAccount.withdraw(proxy, 10) == {:ok, 90}
    assert BankAccount.balance(proxy) == {:ok, :hidden}
    assert BankAccount.deposit(proxy, 10) == {:ok, 100}
  end
end
