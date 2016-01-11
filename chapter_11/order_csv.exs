defmodule OrderCSV do
  def process_file(path) do
    parse_file(path)
      |> Order.with_totals(Order.tax_rates)
  end

  def parse_file(path) do
    {:ok, result} = File.open path, [:read], fn file ->
      IO.stream(file, :line)
        |> Stream.drop(1)
        |> Enum.map(&to_keyword_list/1)
    end
    result
  end

  defp to_keyword_list(line) do
    import String
    with [id, << ":", state::binary >>, net] <- line |> strip |> split(","),
         {id, ""}         <- Integer.parse(id),
         state            = to_atom(state),
         {net, ""}        <- Float.parse(net),
      do: [id: id, ship_to: state, net_amount: net]
  end
end
