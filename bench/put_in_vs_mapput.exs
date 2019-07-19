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

Benchee.run(%{
  "Map.get/put" => map,
  "k" => k,
  # "[]Map.put" => map2,
  # "Map.update" => map_update,
  # "Kernel.put_in" => kernel
}, time: 10, parallel: 1)
