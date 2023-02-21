defmodule DesignPatterns.Structural.FacadeTest do
  use ExUnit.Case
  alias DesignPatterns.Structural.Facade.MySystem

  test "delegates functions to components" do
    assert MySystem.a() == "component a"
    assert MySystem.b() == "component b"
    assert MySystem.c(2) == 4
  end
end
