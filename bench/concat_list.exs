
defmodule ListC do
  def concat([head | tail], acc) do
    concat(tail, [head | acc])
  end
  def concat([], acc), do: acc
end


custom = fn ->
  Enum.reduce(1..10, [1], fn num, acc ->
    ListC.concat(acc, acc)
  end)
end

native = fn ->
  Enum.reduce(1..10, [1], fn num, acc ->
    acc ++ acc
  end)
end

# Start benchmark
Benchee.run(%{
  "custom" => custom,
  "native" => native
}, time: 10, formatter_options: %{console: %{extended_statistics: true}})
