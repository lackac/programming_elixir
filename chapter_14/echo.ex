defmodule Echo do
  def echo do
    receive do
      {sender, message} ->
        send sender, {:ok, message}
    end
  end
end

echoer1 = spawn Echo, :echo, []
echoer2 = spawn Echo, :echo, []

send echoer1, {self, "alice"}
send echoer2, {self, "bob"}

receive do
  {:ok, message} ->
    IO.puts message
end

receive do
  {:ok, message} ->
    IO.puts message
end
