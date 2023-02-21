defmodule DesignPatterns.Functional.Pipeline do
  @moduledoc false

  @doc """
  ## Examples

      iex> f = pipeline([&Function.identity/1, &Function.identity/1])
      iex> f.("ID")
      "ID"

      iex> f = pipeline([&abs/1, &(&1 - 1)])
      iex> f.(-2)
      1

  """
  def pipeline(funs) when is_list(funs) do
    fn input ->
      List.foldl(funs, input, & &1.(&2))
    end
  end

  @doc """
  ## Examples

      iex> f = (&Function.identity/1) |> pipe(&Function.identity/1) |> pipe(&Function.identity/1)
      iex> f.("ID")
      "ID"

      iex> f = (&abs/1) |> pipe(& &1 - 1) |> pipe(& &1 * 2)
      iex> f.(-2)
      2

  """
  def pipeline(fun1, fun2) when is_function(fun1, 1) and is_function(fun2, 1) do
    fn input ->
      input |> then(fun1) |> then(fun2)
    end
  end

  defdelegate pipe(fun1, fun2), to: __MODULE__, as: :pipeline
end
