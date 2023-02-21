defmodule DesignPatterns.Creational.Factory do
  defmodule Circle do
    defstruct diameter: nil
  end

  defmodule Rectangle do
    defstruct [:width, :height]
  end

  defmodule ShapeFactory do
    def create(:circle, diameter: d), do: %Circle{diameter: d}
    def create(:circle, radius: r), do: %Circle{diameter: r * 2}
    def create(:rectangle, width: w, height: h), do: %Rectangle{width: w, height: h}
    def create(:square, size: s), do: %Rectangle{width: s, height: s}
  end
end
