# Map.put vs Kernel.put_in

defmodule Recursion do
  def calc(l, n \\ 0)
  def calc([], n), do: n
  def calc([_h | t], n), do: calc(t, n + 1)

  def calc_str(l, n \\ 0)
  def calc_str("", n), do: n
  def calc_str(<<_::bytes-size(1), t::binary>>, n), do: calc_str(t, n + 1)
end

array = Enum.map(1..1000, &(&1))
string = Enum.join(1..1000)

recursive = fn ->
  Enum.each(1..1000, fn _ ->
    Recursion.calc(array)
  end)
end

length = fn ->
  Enum.each(1..1000, fn _ ->
    length(array)
  end)
end

str_recursive = fn ->
  Enum.each(1..1000, fn _ ->
    Recursion.calc_str(string)
  end)
end

charlist_length = fn ->
  Enum.each(1..1000, fn _ ->
    length String.to_charlist(string)
  end)
end

codepoints_length = fn ->
  Enum.each(1..1000, fn _ ->
    length String.codepoints(string)
  end)
end

string_length = fn ->
  Enum.each(1..1000, fn _ ->
    String.length(string)
  end)
end

str_byte_size = fn ->
  Enum.each(1..1000, fn _ ->
    byte_size(string)
  end)
end

reduce = fn ->
  Enum.each(1..1000, fn _ ->
    Enum.reduce(array, 0, fn _, a -> a + 1 end)
  end)
end

Benchee.run(%{
  "Kernel.length" => length,
  "Recursive list" => recursive,
  "Enum.reduce" => reduce,
  "Recursive string" => str_recursive,
  "String.to_charlist length" => charlist_length,
  "String.codepoints length" => codepoints_length,
  "byte_size (only ascii)" => str_byte_size,
  "String.length" => string_length
}, time: 10, parallel: 1)
