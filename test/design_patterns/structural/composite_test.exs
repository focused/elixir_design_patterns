defmodule DesignPatterns.Structural.CompositeTest do
  use ExUnit.Case
  import DesignPatterns.Structural.Composite.Helper
  alias DesignPatterns.Structural.Composite.{Menu, Tree}

  @main_menu menu("Main", "/", [
               item(nil, nil),
               item("Discounts", "https://www.discounts"),
               submenu("Catalog", "/catalog", [
                 item("Products", "/products"),
                 item("Vendors", "/vendors")
               ]),
               submenu("Help", "/help", [
                 item("About", "/about")
               ])
             ])

  describe "Helper" do
    test "menu" do
      assert {:root, %Menu{name: "Main", url: "/"},
              [
                {:leaf, %Menu.Item{name: nil, url: nil}},
                {:leaf, %Menu.Item{name: "Discounts", url: "https://www.discounts"}},
                {:branch, %Menu{name: "Catalog", url: "/catalog"},
                 [
                   leaf: %Menu.Item{name: "Products", url: "/products"},
                   leaf: %Menu.Item{name: "Vendors", url: "/vendors"}
                 ]},
                {:branch, %Menu{name: "Help", url: "/help"},
                 [
                   leaf: %Menu.Item{name: "About", url: "/about"}
                 ]}
              ]} = @main_menu
    end
  end

  describe "Tree" do
    test "walk/3 with defaults" do
      assert {:root, %Menu{name: "Main", url: "/", open?: true},
              [
                {:leaf, %Menu.Item{name: nil, url: nil}},
                {:leaf, %Menu.Item{name: "Discounts", url: "https://www.discounts"}},
                {:branch, %Menu{name: "Catalog", url: "/catalog", open?: true},
                 [
                   leaf: %Menu.Item{name: "Products", url: "/products"},
                   leaf: %Menu.Item{name: "Vendors", url: "/vendors"}
                 ]},
                {:branch, %Menu{name: "Help", url: "/help", open?: true},
                 [
                   leaf: %Menu.Item{name: "About", url: "/about"}
                 ]}
              ]} = Tree.walk(@main_menu)
    end

    test "walk/3 with custom mapper and default filter" do
      assert {%Menu{name: "Main", url: "/"},
              [
                %Menu.Item{name: nil, url: nil},
                %Menu.Item{name: "Discounts", url: "https://www.discounts"},
                {%Menu{name: "Catalog", url: "/catalog"},
                 [
                   %Menu.Item{name: "Products", url: "/products"},
                   %Menu.Item{name: "Vendors", url: "/vendors"}
                 ]},
                {%Menu{name: "Help", url: "/help"},
                 [
                   %Menu.Item{name: "About", url: "/about"}
                 ]}
              ]} =
               Tree.walk(@main_menu, fn
                 {:leaf, item} -> item
                 {_type, menu, items} -> {menu, items}
               end)
    end

    test "walk/3 with custom mapper and filter" do
      present? = fn
        {:leaf, %Menu.Item{name: nil}} -> false
        _node -> true
      end

      assert @main_menu |> Tree.walk(&draw/1, present?) ==
               String.trim("""
               * Main
                 - Discounts
               * Catalog
                 - Products
                 - Vendors
               * Help
                 - About
               """)
    end

    @tag :skip
    test "walk_with_index/3 with custom mapper and filter" do
      present? = fn
        {:leaf, %Menu.Item{name: nil}} -> false
        _node -> true
      end

      assert @main_menu |> Tree.walk(&draw/1, present?) ==
               String.trim("""
               * Main
                 - Discounts
               * Catalog
                 - Products
                 - Vendors
               * Help
                 - About
               """)
    end
  end

  defp draw({:leaf, item}), do: "  - " <> item.name
  defp draw({_type, menu, items}), do: "* " <> menu.name <> "\n" <> Enum.join(items, "\n")
end
