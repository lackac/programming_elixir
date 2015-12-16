defmodule MyList do
  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail)

  def square([]), do: []
  def square([head | tail]), do: [ head * head | square(tail) ]

  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]

  def sum(list), do: do_sum(list, 0)
  defp do_sum([], total), do: total
  defp do_sum([head | tail], total), do: do_sum(tail, head + total)

  def sum2([]), do: 0
  def sum2([head | tail]), do: head + sum2(tail)

  def reduce([], value, _), do: value
  def reduce([head | tail], value, func), do: reduce(tail, func.(head, value), func)

  def mapsum(list, func), do: sum(map(list, func))

  def max([]), do: nil
  def max([head | tail]), do: do_max(tail, head)
  defp do_max([], max), do: max
  defp do_max([head | tail], max) when head > max, do: do_max(tail, head)
  defp do_max([_head | tail], max), do: do_max(tail, max)

  def caesar([], _n), do: []
  def caesar([head | tail], n), do: [ 97 + rem(head + n - 97, 26) | caesar(tail, n) ]

  def span(from, to), do: do_span(from, to, [])
  defp do_span(n, n, list), do: [ n | list ]
  defp do_span(from, to, list), do: do_span(from, to - 1, [ to | list ])
end
