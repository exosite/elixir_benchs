# Map.put vs Kernel.put_in

map = fn ->
  Enum.reduce(1..1000, %{}, fn key, acc ->
    Map.has_key?(acc, key)
    acc
  end)
end

k = fn ->
  Enum.reduce(1..1000, %{}, fn key, acc ->
    Enum.member?(acc, key)
    acc
  end)
end

map2 = fn ->
  Enum.reduce(1..1000, %{}, fn key, acc ->
    Map.put(acc, key, (acc[key] || 0) + key)
  end)
end

map_update = fn ->
  Enum.reduce(1..1000, %{}, fn key, acc ->
    Map.update(acc, key, key, & &1 + key)
  end)
end

kernel = fn ->
  Enum.reduce(1..1000, %{}, fn key, acc ->
    put_in(acc, [key], (acc[key] || 0) + key)
  end)
end

kernel_3 = fn ->
  my_map = %{
    foo: %{
      bar: %{
        baz: "my value"
      }
    }
  }

  Enum.reduce(1..1000, %{}, fn key, acc ->
    put_in(my_map, [:foo, :bar, :baz], key)
  end)
end

defmodule Recursion do
  def put(map, [], _v), do: map
  def put(map, [h], v), do: Map.put(map, h, v)
  def put(map, [h|t], v), do: Map.put(map, h, Recursion.put(Map.get(map, h), t, v))
end

put_3 = fn ->
  my_map = %{
    foo2: %{
      bar: %{
        baz: "my value"
      }
    }
  }

  Enum.reduce(1..1000, %{}, fn key, acc ->
    Recursion.put(my_map, [:foo2, :bar, :baz], key)
  end)
end

Benchee.run(%{
  "put_3" => put_3,
  "kernel_3" => kernel_3
  # "Map.get/put" => map,
  # "k" => k,
  # "[]Map.put" => map2,
  # "Map.update" => map_update,
  # "Kernel.put_in" => kernel
}, time: 10, parallel: 1)
