defmodule DesignPatterns.Creational.Builder do
  defmodule Computer do
    defstruct memory: 0, cpu: nil, drives: []
  end

  defmodule ComputerBuilder do
    def build, do: %Computer{}

    def intel(%Computer{} = computer), do: %{computer | cpu: :intel}

    def set_memory(%Computer{} = computer, size), do: %{computer | memory: size}

    def add_disk(%Computer{drives: drives} = computer, drive) do
      %{computer | drives: [drive | drives]}
    end
  end
end
