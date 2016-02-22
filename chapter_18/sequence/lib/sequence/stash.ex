defmodule Sequence.Stash do
  use GenServer
  require Logger

  @vsn "0"

  ###
  # External API

  def start_link(current_number) do
    {:ok, _pid} = GenServer.start_link __MODULE__, current_number
  end

  def save_value(pid, value) do
    GenServer.cast pid, {:save_value, value}
  end

  def get_value(pid) do
    GenServer.call pid, :get_value
  end

  ###
  # GenServer callbacks

  def handle_cast({:save_value, value}, _current_value) do
    {:noreply, value}
  end

  def handle_call(:get_value, _from, current_value) do
    {:reply, current_value, current_value}
  end

  def code_change(nil, old_state = current_value, _extra) do
    new_state = {current_value, 1}
    Logger.info "Changing Stash data version to 0"
    Logger.info inspect(old_state)
    Logger.info inspect(new_state)
    {:ok, new_state}
  end
  def code_change(_vsn, current_state, _extra), do: {:ok, current_state}
end
