defmodule MyEnum do
  def all?([], _fun), do: true
  def all?([head | tail], fun), do: fun.(head) && all?(tail, fun)

  def each([], _fun), do: :ok
  def each([head | tail], fun) do
    fun.(head)
    each(tail, fun)
  end

  def filter(list, fun) do
    do_filter(list, fun, [])
      |> reverse
  end
  defp do_filter([], _fun, filtered), do: filtered
  defp do_filter([head | tail], fun, filtered) do
    if fun.(head) do
      do_filter(tail, fun, [head | filtered])
    else
      do_filter(tail, fun, filtered)
    end
  end

  def reverse(list), do: do_reverse(list, [])
  defp do_reverse([], reversed), do: reversed
  defp do_reverse([head | tail], reversed) do
    do_reverse(tail, [head | reversed])
  end

  def split(list, count) when is_integer(count) and count >= 0 do
    do_split(list, count, [])
  end
  defp do_split([], _count, first_part) do
    {reverse(first_part), []}
  end
  defp do_split(rest, 0, first_part) do
    {reverse(first_part), rest}
  end
  defp do_split([head | tail], count, first_part) when count > 0 do
    do_split(tail, count - 1, [head | first_part])
  end

  def take(list, count), do: split(list, count) |> elem(0)

  def flatten(list), do: do_flatten(list, []) |> reverse
  defp do_flatten([], flattened), do: flattened
  defp do_flatten([head | tail], flattened)
  when is_list(head) do
    do_flatten(tail, []) ++ do_flatten(head, flattened)
  end
  defp do_flatten([head | tail], flattened) do
    do_flatten(tail, [head | flattened])
  end
end
