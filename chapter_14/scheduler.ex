defmodule FibSolver do
  def fib(scheduler) do
    send scheduler, {:ready, self}
    receive do
      {:process, n, client} ->
        send client, {:answer, n, fib_calc(n), self}
        fib(scheduler)
      {:shutdown} ->
        exit(:normal)
    end
  end

  def fib_calc(0), do: 0
  def fib_calc(1), do: 1
  def fib_calc(n), do: fib_calc(n - 2) + fib_calc(n - 1)
end

defmodule CatCounter do
  def count(scheduler) do
    send scheduler, {:ready, self}
    receive do
      {:process, path, client} ->
        send client, {:answer, Path.basename(path), count_cats(path), self}
        count(scheduler)
      {:shutdown} ->
        exit(:normal)
    end
  end

  def count_cats(path) do
    Regex.scan(~r/cat/, File.read!(path)) |> length
  end

  def count_all(path \\ ".") do
    files = File.ls!(path)
      |> Enum.map(fn file -> Path.join(path, file) end)
      |> Enum.filter(&File.regular?/1)
    Scheduler.run(length(files), __MODULE__, :count, files)
      |> Enum.sort_by(fn {_, count} -> -count end)
  end
end

defmodule Scheduler do
  def run(num_processes, module, func, to_calculate) do
    (1..num_processes)
      |> Enum.map(fn(_) -> spawn(module, func, [self]) end)
      |> schedule_processes(to_calculate, [])
  end

  def schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [next | tail] = queue
        send pid, {:process, next, self}
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue, [{number, result} | results])
    end
  end

  def benchmark(to_process, processes) do
    Enum.each processes, fn num_processes ->
      {time, result} = :timer.tc(
        Scheduler, :run, [num_processes, FibSolver, :fib, to_process])

      if num_processes == 1 do
        IO.inspect result
        IO.puts "\n #	time (s)"
      end
      :io.format "~2B	~.2f~n", [num_processes, time/1000000.0]
    end
  end
end
