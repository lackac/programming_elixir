defmodule Stack.Supervisor do
  use Supervisor

  def start_link do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, nil)
    start_workers(sup)
    result
  end

  def start_workers(sup) do
    {:ok, stash} = Supervisor.start_child sup, worker(Stack.Stash, [[]])
    Supervisor.start_child sup, supervisor(Stack.SubSupervisor, [stash])
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
