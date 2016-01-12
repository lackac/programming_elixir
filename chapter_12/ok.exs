defmodule OK do
  def ok!({:ok, result}), do: result
  def ok!({:error, reason}), do: raise RuntimeError, inspect(reason)
end
