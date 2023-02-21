defmodule DesignPatterns.Structural.Facade do
  defmodule MySystem.ComponentA do
    def a, do: "component a"
  end

  defmodule MySystem.ComponentB do
    def b, do: "component b"

    def d(param, count), do: param * count
  end

  defmodule MySystem do
    defdelegate a, to: MySystem.ComponentA
    defdelegate b, to: MySystem.ComponentB

    def c(param), do: MySystem.ComponentB.d(param, 2)
  end
end
