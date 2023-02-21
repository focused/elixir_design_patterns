defmodule DesignPatterns.Creational.ShapeFactoryTest do
  use ExUnit.Case
  alias DesignPatterns.Creational.Factory.{Circle, Rectangle, ShapeFactory}

  test "instantiates structs" do
    factory = ShapeFactory

    assert %Circle{diameter: 2} = factory.create(:circle, diameter: 2)
    assert %Circle{diameter: 2} = factory.create(:circle, radius: 1)

    assert %Rectangle{width: 1, height: 1} = factory.create(:square, size: 1)
    assert %Rectangle{width: 1, height: 2} = factory.create(:rectangle, width: 1, height: 2)
  end
end
