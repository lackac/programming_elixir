defmodule Delay do
  def messenger(recipient, action) do
    send recipient, "hello"
    case action do
      :exit  -> exit(0)
      :raise -> raise "FAIL!"
      _      -> true
    end
  end

  def flush do
    :timer.sleep(500)
    do_flush
  end
  defp do_flush do
    receive do
      message ->
        IO.inspect(message)
        do_flush
      after 100 ->
        IO.puts "done."
    end
  end

  def link_and_flush(action \\ nil) do
    spawn_link Delay, :messenger, [self, action]
    flush
  end

  def monitor_and_flush(action \\ nil) do
    spawn_monitor Delay, :messenger, [self, action]
    flush
  end
end
