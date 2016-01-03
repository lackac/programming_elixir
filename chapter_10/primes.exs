defmodule Primes do
  def upto(n) when is_integer(n) and n >= 2 do
    2..n |> Enum.to_list |> sieve
  end

  defp sieve([]), do: []
  defp sieve([ head | tail ]) do
    [ head | sieve(for a <- tail, rem(a, head) > 0, do: a) ]
  end
end
