defmodule My do
  defmacro if(condition, clauses) do
    do_clause   = Keyword.get(clauses, :do, nil)
    else_clause = Keyword.get(clauses, :else, nil)

    quote do
      case unquote(condition) do
        val when val in [false, nil] -> unquote(else_clause)
        _                            -> unquote(do_clause)
      end
    end
  end

  defmacro unless(condition, clauses) do
    do_clause   = Keyword.get(clauses, :do, nil)
    else_clause = Keyword.get(clauses, :else, nil)

    quote do
      case unquote(condition) do
        val when val in [false, nil] -> unquote(do_clause)
        _                            -> unquote(else_clause)
      end
    end
  end
end

defmodule Test do
  require My

  My.if 1 == 2 do
    IO.puts "1 == 2"
  else
    IO.puts "1 != 2"
  end

  My.unless rem(elem(:erlang.time, 2), 5) == 0 do
    IO.puts "second NOT divisible by 5"
  else
    IO.puts "second divisible by 5"
  end
end
