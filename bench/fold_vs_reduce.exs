# Map.put vs Kernel.put_in

defmodule Recursion do
  def calc(l, n \\ 0)
  def calc([], n), do: n
  def calc([h | t], n), do: calc(t, n + h)

  def acc(a, b), do: a + b
end

array = Enum.map(1..1000, &(&1))

recursive = fn ->
  Enum.each(1..1000, fn _ ->
    Recursion.calc(array)
  end)
end

list_foldl = fn ->
  Enum.each(1..1000, fn _ ->
    List.foldl(array, 0, &+/2)
  end)
end

list_foldl_pre_func = fn ->
  Enum.each(1..1000, fn _ ->
    List.foldl(array, 0, &Recursion.acc/2)
  end)
end

enum_reduce = fn ->
  Enum.each(1..1000, fn _ ->
    Enum.reduce(array, 0, &+/2)
  end)
end

Benchee.run(%{
  "Enum.reduce" => enum_reduce,
  "List.foldl" => list_foldl,
  "List.foldl with referenced function" => list_foldl_pre_func,
  "Recursive" => recursive
}, time: 10, parallel: 1)
