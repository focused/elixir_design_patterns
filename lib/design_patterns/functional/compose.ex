defmodule DesignPatterns.Functional.Compose do
  @moduledoc false

  @doc """
  ## Examples

      iex> f = compose([&Function.identity/1, &Function.identity/1])
      iex> f.("ID")
      "ID"

      iex> f = compose([&abs/1, &(&1 - 1)])
      iex> f.(-2)
      3

  """
  @spec compose([fun]) :: (any -> any)
  def compose(funs) when is_list(funs) do
    fn arg ->
      List.foldr(funs, arg, & &1.(&2))
    end
  end

  @doc """
  ## Examples

      iex> f = (&Function.identity/1) |> compose(&Function.identity/1) |> compose(&Function.identity/1)
      iex> f.("ID")
      "ID"

      iex> f = (&abs/1) |> compose(& &1 - 1) |> compose(& &1 * 2)
      iex> f.(-2)
      5

  """
  @spec compose((any -> any), (any -> any)) :: (any -> any)
  def compose(fun1, fun2) when is_function(fun1, 1) and is_function(fun2, 1) do
    fn arg ->
      arg |> then(fun2) |> then(fun1)
    end
  end
end
