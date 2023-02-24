defmodule DesignPatterns.Structural.Composite do
  defmodule Tree do
    @branch_types [:root, :branch]

    @type t :: leaf | {branch_type, any, [t]}
    @type root :: {:root, any, [t]}
    @type branch :: {:branch, any, [t]}
    @type leaf :: {:leaf, any}
    @typep branch_type :: :root | :branch

    @spec branch_types :: [branch_type]
    def branch_types, do: @branch_types

    @spec new(branch_type, any, t) :: t
    def new(type, value, nodes) when type in @branch_types, do: {type, value, nodes}

    @spec leaf(any) :: leaf
    def leaf(value), do: {:leaf, value}

    @spec root?(t) :: boolean
    def root?({:root, _value, nodes}) when is_list(nodes), do: true
    def root?(_node), do: false

    @spec branch?(t) :: boolean
    def branch?({:branch, _value, nodes}) when is_list(nodes), do: true
    def branch?(_leaf), do: false

    @spec leaf?(t) :: boolean
    def leaf?({:leaf, _value}), do: true
    def leaf?(_branch), do: false

    @spec walk(t, (t -> any), (t -> boolean)) :: any
    def walk({type, value, nodes}, mapper \\ &Function.identity/1, filter \\ fn _ -> true end)
        when type in @branch_types and is_function(mapper, 1) and is_function(filter, 1) do
      nodes
      |> Enum.reduce([], fn node, acc ->
        case {filter.(node), node} do
          {true, {:leaf, _value}} -> [mapper.(node) | acc]
          {true, node} -> [walk(node, mapper, filter) | acc]
          _ -> acc
        end
      end)
      |> Enum.reverse()
      |> then(&mapper.({type, value, &1}))
    end

    @spec walk_with_index(t, (t, integer -> any), (t, integer -> boolean)) :: any
    def walk_with_index(
          {type, value, nodes},
          mapper \\ fn n, _ -> n end,
          filter \\ fn _, _ -> true end,
          index \\ 0
        )
        when type in @branch_types and is_function(mapper, 2) and is_function(filter, 2) do
      nodes
      |> Enum.with_index()
      |> Enum.filter(fn {node, i} -> filter.(node, i) end)
      |> Enum.with_index(fn {node, _i}, index -> {node, index} end)
      |> Enum.map(fn
        {{:leaf, _value} = node, i} -> mapper.(node, i)
        {node, i} -> walk_with_index(node, mapper, filter, i)
      end)
      |> then(&mapper.({type, value, &1}, index))
    end
  end

  defmodule Menu do
    defstruct [:name, :url, open?: false]

    def new(name, url, open? \\ false) do
      %__MODULE__{name: name, url: url, open?: open?}
    end
  end

  defmodule Menu.Item do
    defstruct [:name, :url]

    def new(name, url), do: %__MODULE__{name: name, url: url}
  end

  defmodule Helper do
    @branch_types Tree.branch_types()

    def menu(name, url, items, opts \\ []) do
      opts = Enum.into(opts, %{type: :root, open?: true}, &validate_opts/1)
      Tree.new(opts.type, Menu.new(name, url, opts.open?), items)
    end

    def submenu(name, url, items, opts \\ []) do
      menu(name, url, items, Keyword.put(opts, :type, :branch))
    end

    def item(name, url \\ nil), do: name |> Menu.Item.new(url) |> Tree.leaf()

    defp validate_opts({:open?, open?} = kv) when is_boolean(open?), do: kv
    defp validate_opts({:type, type} = kv) when type in @branch_types, do: kv
  end
end
