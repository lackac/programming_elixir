defmodule Tracer do
  def dump_defn(name, args) do
    "#{name}(#{dump_args(args)})"
  end

  def dump_args(args) do
    args |> Enum.map(&inspect/1) |> Enum.join(", ")
  end

  defmacro def(definition, do: body) do
    {name, args} = case definition do
      {:when, _, [{name, _, args} | _clauses]} -> {name, args}
      {name, _, args} -> {name, args}
    end

    quote do
      Kernel.def(unquote(definition)) do
        IO.puts IO.ANSI.format([
          :bright, :blue, "==> call:   ", :reset,
          Tracer.dump_defn(unquote(name), unquote(args))
        ])
        result = unquote(body)
        IO.puts IO.ANSI.format([
          :bright, :magenta, "<== result: ", :reset,
          inspect(result)
        ])
        result
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2]
      import unquote(__MODULE__), only: [def: 2]
    end
  end
end

defmodule Test do
  use Tracer

  def puts_sum_three(a, b, c), do: IO.inspect(a + b + c)
  def add_list(list), do: Enum.reduce(list, 0, &(&1+&2))

  def odd?(n) when is_number(n), do: rem(n, 2) == 1
end

Test.puts_sum_three(13, 42, 7)
Test.add_list([1, 2, 3, 4])
Test.odd?(3)
