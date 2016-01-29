defmodule FibAgent do
  def start_link do
    Agent.start_link fn -> %{ 0 => 0, 1 => 1 } end
  end

  def fib(pid, n) when n >= 0 do
    Agent.get_and_update pid, &do_fib(&1, n)
  end

  defp do_fib(cache, n) do
    case cache[n] do
      nil ->
        { n1, cache } = do_fib(cache, n - 1)
        result        = n1 + cache[n - 2]
        { result, Map.put(cache, n, result) }

      cached_value ->
        { cached_value, cache }
    end
  end
end
