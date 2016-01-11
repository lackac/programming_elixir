defmodule MyString do
  def center(strings) do
    max_length = Enum.max_by(strings, &String.length/1) |> String.length
    Enum.each strings, fn string ->
      IO.puts <<
        String.duplicate(" ", div(max_length - String.length(string), 2))::binary,
        string::binary
      >>
    end
  end

  def capitalize_sentences(string) do
    Regex.scan(~r/[^.]+(?:\.\s*|$)/, string)
      |> List.flatten
      |> Enum.map_join(&String.capitalize/1)
  end
end
