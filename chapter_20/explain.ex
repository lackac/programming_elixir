# this is incomplete. it works for some inputs, but doesn't care about proper
# English and fails for more complex expressions
defmodule Explain do
  defmacro explain(do: expr) do
    {:ok, [sentence]} = Macro.postwalk expr, [], &explain_op/2

    IO.puts(sentence)

    expr
  end

  @word_for_op [+: "add", -: "subtract", *: "multiply", /: "divide"]

  defp explain_op(x, stack) when is_number(x), do: {:ok, [x | stack]}
  defp explain_op({op, _, _}, [sentence, x | stack])
  when op in [:+, :-, :*, :/] and is_binary(sentence) and is_number(x) do
    {:ok, [sentence <> ", then #{@word_for_op[op]} #{x}" | stack]}
  end
  defp explain_op({op, _, _}, [x, y | stack])
  when op in [:+, :-, :*, :/] and is_number(x) and is_number(y) do
    {:ok, ["#{@word_for_op[op]} #{x} and #{y}" | stack]}
  end
end

defmodule Test do
  require Explain
  import Explain

  explain do: 1 + 2 * 3
end
