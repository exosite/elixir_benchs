# Buffer: ETS Bags or normal or concurrent

:ets.new(:tablename, [:public, :named_table])
:ets.new(:concurrent, [:public, :named_table, write_concurrency: true, read_concurrency: true])
:ets.new(:bag, [:bag, :public, :named_table, write_concurrency: true, read_concurrency: true])

ets_con_take = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:concurrent, {key, key})
  end)
  Enum.map(1..1000, fn key ->
    case :ets.take(:concurrent, key) do
      [] -> nil
      [result] -> result
      _ -> raise "expected only a single element with key " <> inspect(key)
    end
  end)
end

ets_take = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:tablename, {key, key})
  end)
  Enum.map(1..1000, fn key ->
    case :ets.take(:tablename, key) do
      [] -> nil
      [result] -> result
      _ -> raise "expected only a single element with key " <> inspect(key)
    end
  end)
end

bag_take = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:bag, {key, key, 1})
    :ets.insert(:bag, {key, key, 2})
    :ets.insert(:bag, {key, key, 3})
    :ets.insert(:bag, {key, key, 4})
  end)
  Enum.map(1..1000, fn key ->
    case :ets.take(:bag, key) do
      [] -> nil
      result when is_list(result) ->
        Enum.map(result, &({&1, 0}))
      _ -> raise "expected only a single element with key "
    end
  end)
end

Benchee.run(%{
  "Bag.take" => bag_take,
  "Ets.take" => ets_take,
  "Ets.take + concurrent=true" => ets_con_take
}, time: 10, parallel: 4, formatter_options: %{console: %{extended_statistics: false}})
