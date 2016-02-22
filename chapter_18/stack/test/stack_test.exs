defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  setup do
    :sys.replace_state Stack.Server, fn ({_, pid}) -> {~w(banana apple), pid} end
    :ok
  end

  test "pushing onto the stack" do
    Stack.Server.push "cherry"
    {stack, _pid} = :sys.get_state Stack.Server
    assert stack == ~w(cherry banana apple)
  end

  test "popping from the stack" do
    assert Stack.Server.pop == "banana"
    assert Stack.Server.pop == "apple"
  end
end
