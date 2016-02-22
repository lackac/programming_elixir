defmodule Stack.Stash do
  use GenServer

  ###
  # External API

  def start_link(initial_value) do
    {:ok, _pid} = GenServer.start_link __MODULE__, initial_value
  end

  def set_value(pid, value) do
    GenServer.cast pid, {:set_value, value}
  end

  def get_value(pid) do
    GenServer.call pid, :get_value
  end

  ###
  # GenServer callbacks

  def handle_cast({:set_value, value}, _current_value) do
    {:noreply, value}
  end

  def handle_call(:get_value, _from, current_value) do
    {:reply, current_value, current_value}
  end
end
