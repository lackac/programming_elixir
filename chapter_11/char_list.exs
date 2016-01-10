defmodule CharList do
  def printable?(chars) do
    Enum.all? chars, &(&1 in ?\s..?~)
  end

  def anagram?(word1, word2), do: Enum.sort(word1) == Enum.sort(word2)

  def calculate(expr), do: do_calculate(expr, 0, 0, 0)
  defp do_calculate([], x, op, y), do: do_calculate(x, op, y)
  defp do_calculate([ head | tail ], x, 0, 0)
  when head in ?0..?9 do
    do_calculate(tail, 10*x + head - ?0, 0, 0)
  end
  defp do_calculate([ head | tail ], x, 0, 0)
  when head in [?+, ?-, ?*, ?/] do
    do_calculate(tail, x, head, 0)
  end
  defp do_calculate([ head | tail ], x, op, y)
  when head in ?0..?9 do
    do_calculate(tail, x, op, 10*y + head - ?0)
  end
  defp do_calculate([ ?\s | tail ], x, op, y), do: do_calculate(tail, x, op, y)
  defp do_calculate(x, ?+, y), do: x+y
  defp do_calculate(x, ?-, y), do: x-y
  defp do_calculate(x, ?*, y), do: x*y
  defp do_calculate(x, ?/, y), do: x/y
end
