defmodule DesignPatterns.Creational.SingletonTest do
  use ExUnit.Case
  alias DesignPatterns.Creational.Singleton

  test "keeps value" do
    :sys.replace_state(:singleton, fn _ -> nil end)
    assert Singleton.value() == nil

    assert Singleton.update("new value") == :ok
    assert Singleton.value() == "new value"
  end
end
