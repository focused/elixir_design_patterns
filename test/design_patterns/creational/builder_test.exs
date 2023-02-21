defmodule DesignPatterns.Creational.BuilderTest do
  use ExUnit.Case
  import DesignPatterns.Creational.Builder.ComputerBuilder
  alias DesignPatterns.Creational.Builder.Computer

  test "builds struct" do
    assert build() |> intel |> set_memory(12) |> add_disk(256) == %Computer{
             cpu: :intel,
             memory: 12,
             drives: [256]
           }
  end
end
