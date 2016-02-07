defmodule Stack.Server do
  use GenServer

  ###
  # External API

  def start_link do
    GenServer.start_link __MODULE__, [], name: __MODULE__
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(value) do
    GenServer.cast __MODULE__, {:push, value}
  end

  ###
  # GenServer callbacks

  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_cast({:push, nil}, _stack) do
    System.halt(:invalid_value)
  end
  def handle_cast({:push, value}, stack) do
    {:noreply, [value | stack]}
  end

  def terminate(reason, state) do
    IO.puts "Terminating server, because #{inspect reason}. State was #{inspect state}."
  end
end
