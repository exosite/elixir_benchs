
defmodule Recursion do
  def calc(map, [], _), do: map
  def calc(map, [h | t], func), do: calc(Dict.update(map, h, :unknown, func), t, func)
end

map = Enum.reduce(1..1000, %{}, fn (i, acc) ->
  i = Integer.to_string(i);
  Map.put(acc, i, i)
end)

reduce = fn ->
  Enum.reduce(map, %{}, fn ({k, v}, acc) ->
    Map.put(acc, k, v <> v)
  end)
end

mapnew = fn ->
  Map.new(map, fn {k, v} -> {k, v <> v} end)
end

reduceput = fn ->
  Enum.reduce(map, map, fn ({k, v}, acc) ->
    %{acc | k => v <> v}
  end)
end

forl = fn ->
  for {k, v} <- map, into: %{}, do: {k, v <> v}
end

custom = fn ->
  Recursion.calc(map, Dict.keys(map), fn v -> v <> v end)
end

Benchee.run(%{
  "mapnew" => mapnew,
  "reduceput" => reduceput,
  "for" => forl,
  "reduce" => reduce,
  "custom" => custom
}, time: 10, parallel: 1)
