defmodule Stack.Server do
  use GenServer

  ###
  # External API

  def start_link(stash_pid) do
    GenServer.start_link __MODULE__, stash_pid, name: __MODULE__
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(value) do
    GenServer.cast __MODULE__, {:push, value}
  end

  ###
  # GenServer callbacks

  def init(stash_pid) do
    initial_stack = Stack.Stash.get_value stash_pid
    {:ok, {initial_stack, stash_pid}}
  end

  def handle_call(:pop, _from, {[head | tail], stash_pid}) do
    {:reply, head, {tail, stash_pid}}
  end

  def handle_cast({:push, nil}, _stack), do: System.halt(:invalid_value)
  def handle_cast({:push, value}, {stack, stash_pid}) do
    {:noreply, {[value | stack], stash_pid}}
  end

  def terminate(_reason, {stack, stash_pid}) do
    Stack.Stash.set_value stash_pid, stack
  end
end
