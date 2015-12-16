fizz_buzz_result = fn
  0, 0, _ -> "FizzBuzz"
  0, _, _ -> "Fizz"
  _, 0, _ -> "Buzz"
  _, _, n -> n
end

fizz_buzz = fn
  n -> fizz_buzz_result.(rem(n, 3), rem(n, 5), n)
end

Enum.each 10..16, fn (n) -> IO.puts(fizz_buzz.(n)) end
