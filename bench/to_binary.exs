

to_str = fn ->
  Enum.map(1..1000, fn num ->
    to_string(num)
  end)
end

integer = fn ->
  Enum.map(1..1000, fn num ->
    Integer.to_string(num)
  end)
end

integer2 = fn ->
  Enum.map(1..1000, fn
    numb when is_atom(numb) -> Integer.to_string(numb)
    numb when is_binary(numb) -> Integer.to_string(numb)
    numb when is_list(numb) -> Integer.to_string(numb)
    numb when is_map(numb) -> Integer.to_string(numb)
    numb when is_float(numb) -> Integer.to_string(numb)
    numb when is_integer(numb) -> Integer.to_string(numb)
  end)
end

inspect = fn ->
  Enum.map(1..1000, fn num ->
    inspect(num)
  end)
end

str = fn ->
  Enum.map(1..1000, fn num ->
    "#{num}"
  end)
end

list = fn ->
  Enum.map(1..1000, fn num ->
    << num :: integer >>
  end)
end

list2 = fn ->
  Enum.map(1..1000, fn
    numb when is_atom(numb) -> << numb :: binary >>
    numb when is_binary(numb) -> << numb :: binary >>
    numb when is_list(numb) -> << numb :: binary >>
    numb when is_map(numb) -> << numb :: binary >>
    numb when is_float(numb) -> << numb :: float >>
    numb when is_integer(numb) -> << numb :: integer >>
  end)
end

xnil = "null"
xtrue = "true"
xfalse = "false"
get_string_value = fn (value) ->
  cond do
    is_binary(value) -> value
    value === nil -> xnil
    value === true -> xtrue
    value === false -> xfalse
    is_integer(value) -> Integer.to_string(value)
    is_float(value) -> Float.to_string(value)
    is_atom(value) -> Atom.to_string(value)
    is_map(value) or
    is_list(value) -> :jiffy.encode(value, [:use_nil])
    :else -> inspect(value)
  end
end

inspect2 = fn ->
  Enum.map(1..1000, fn value ->
    cond do
      is_binary(value) -> value
      value === nil -> xnil
      value === true -> xtrue
      value === false -> xfalse
      is_integer(value) -> Integer.to_string(value)
      is_float(value) -> Float.to_string(value)
      is_atom(value) -> Atom.to_string(value)
      is_map(value) or
      is_list(value) -> :jiffy.encode(value, [:use_nil])
      :else -> inspect(value)
    end
  end)
end

# Start benchmark
Benchee.run(%{
  "to_str" => to_str,
  "integer" => integer,
  "integer2" => integer2,
  "str" => str,
  "list" => list,
  "list2" => list2,
  "inspect" => inspect,
  "inspect2" => inspect2
}, time: 10, formatter_options: %{console: %{extended_statistics: true}})
