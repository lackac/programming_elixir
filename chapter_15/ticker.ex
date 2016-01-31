defmodule Ticker do
  @interval 2000
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 0])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), {:register, client_pid}
  end

  def generator(clients, counter) do
    receive do
      {:register, pid} ->
        IO.puts "registering #{inspect pid}"
        generator([pid | clients], 0)
      after @interval ->
        IO.puts "tick"
        next_client = Enum.at clients, rem(counter, length(clients))
        send next_client, {:tick}
        generator(clients, counter + 1)
    end
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick } ->
        IO.puts "tock in client #{inspect self}"
        receiver
    end
  end
end

defmodule RingClient do
  @interval 2000
  @name     :ring_ticker

  def start do
    pid = spawn(__MODULE__, :receiver, [])
    register(pid)
  end

  def register(client_pid) do
    case :global.whereis_name(@name) do
      :undefined ->
        send client_pid, {:registered, client_pid}
        send client_pid, {:tick}
      last_client_pid ->
        send last_client_pid, {:register, client_pid}
        :global.unregister_name(@name)
    end
    :global.register_name(@name, client_pid)
  end

  def receiver do
    receive do
      {:registered, next_client} ->
        registered_receiver(next_client)
    end
  end

  def registered_receiver(next_client) do
    receive do
      {:register, new_client} ->
        IO.puts "registering #{inspect new_client} in #{inspect self}"
        send new_client, {:registered, next_client}
        registered_receiver(new_client)
      {:tick} ->
        IO.puts "tock in client #{inspect self}"
        ticked_receiver(next_client)
    end
  end

  def ticked_receiver(next_client) do
    receive do
      {:register, new_client} ->
        IO.puts "registering #{inspect new_client} in #{inspect self}"
        send new_client, {:registered, next_client}
        ticked_receiver(new_client)
    after @interval ->
      IO.puts "tick from client #{inspect self}"
      send next_client, {:tick}
      registered_receiver(next_client)
    end
  end
end
