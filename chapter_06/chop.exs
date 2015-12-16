defmodule Chop do

  def guess(target, min..max) do
    n = div(min + max, 2)
    IO.puts "Is it #{n}?"
    guess(n, target, min..max)
  end

  defp guess(n, n, _) do
    IO.puts n
    n
  end
  defp guess(n, target, min.._) when target < n, do: guess(target, min..n-1)
  defp guess(n, target, _..max) when target > n, do: guess(target, n+1..max)

end
