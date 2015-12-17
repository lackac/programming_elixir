defmodule Attendee do
  defstruct name: "", paid: false, over_18: false

  def may_attend_after_party?(attendee = %Attendee{}) do
    attendee.paid && attendee.over_18
  end

  def print_vip_badge(%Attendee{name: name}) when name != "" do
    IO.puts "Hey #{name}, pick up your badge at reception!"
  end
  def print_vip_badge(%Attendee{}) do
    raise "Missing name for badge"
  end
end
