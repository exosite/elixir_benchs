# Various type to binary

string_to_atom = fn ->
  Enum.map(1..1000, fn value ->
    String.to_atom(to_string(value))
  end)
end

atom_map = Enum.reduce(1..1000, %{}, fn value, acc ->
  str = to_string(value)
  Map.put(acc, str, String.to_atom(str))
end)
str_map = Enum.reduce(1..1000, %{}, fn value, acc ->
  str = to_string(value)
  Map.put(acc, String.to_atom(str), str)
end)
int_map = Enum.reduce(1..1000, %{}, fn value, acc ->
  str = to_string(value)
  Map.put(acc, value, String.to_atom(str))
end)

atom_to_string = fn ->
  Enum.map(1..1000, fn value ->
    Atom.to_string(int_map[value])
  end)
end

map_str_to_atom = fn ->
  Enum.map(1..1000, fn value ->
    atom_map[to_string(value)]
  end)
end

map_atom_to_str = fn ->
  Enum.map(1..1000, fn value ->
    atom_map[int_map[value]]
  end)
end

# Start benchmark
Benchee.run(%{
  "string_to_atom" => string_to_atom,
  "atom_to_string" => atom_to_string,
  "map_str_to_atom" => map_str_to_atom,
  "map_atom_to_str format" => map_atom_to_str
}, time: 10, formatter_options: %{console: %{extended_statistics: true}})
