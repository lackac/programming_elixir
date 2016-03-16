defmodule Times do
  defmacro times_n(n) do
    quote do
      def unquote(:"times_#{n}")(i) do
        unquote(n) * i
      end
    end
  end
end

defmodule Test do
  require Times
  Times.times_n(3)
  Times.times_n(5)
  Times.times_n(10)
end
