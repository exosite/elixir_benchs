
defmodule GenEts do
  use GenServer
  def init(_), do: {:ok, %{}}
  def handle_cast({:set, k, v}, acc) do
    {:noreply, Map.put(acc, k, v)}
  end
  def handle_cast({:incr, k, v}, acc) do
    {:noreply, Map.update(acc, k, 0, &(&1 + v))}
  end
  def handle_call({:get, k}, _, acc) do
    {:reply, Map.get(acc, k), acc}
  end
end

GenServer.start_link(GenEts, [], name: GenEts)
:ets.new(:tablename, [:public, :named_table])
:ets.new(:concurrent, [:public, :named_table, write_concurrency: true, read_concurrency: true])
:ets.new(:bag, [:bag, :public, :named_table, read_concurrency: true])

ets_get = fn ->
  Enum.map(1..1000, fn key ->
    case :ets.lookup(:tablename, key) do
      [] -> nil
      [result] -> result
      _ -> raise "expected only a single element with key " <> inspect(key)
    end
  end)
end

ets_set = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:tablename, {key, key})
  end)
end

ets_con_get = fn ->
  Enum.map(1..1000, fn key ->
    case :ets.lookup(:concurrent, key) do
      [] -> nil
      [result] -> result
      _ -> raise "expected only a single element with key " <> inspect(key)
    end
  end)
end

ets_con_set = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:concurrent, {key, key})
  end)
end

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

ets_incr = fn ->
  Enum.map(1..1000, fn key ->
    :ets.update_counter(:tablename, key, key, {key, 0})
  end)
end

bag_get = fn ->
  case :ets.lookup(:bag, :bag) do
    [] -> nil
    result when is_list(result) ->
      Enum.map(result, &({&1, 0}))
    [result] -> result
    _ -> raise "expected only a single element with key "
  end
end

bag_set = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:bag, {:bag, key})
  end)
end

bag_take = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:bag, {:bag, key})
  end)
  case :ets.take(:bag, :bag) do
    [] -> nil
    result when is_list(result) ->
      Enum.map(result, &({&1, 0}))
    _ -> raise "expected only a single element with key "
  end
end

gen_get = fn ->
  Enum.map(1..1000, fn key ->
    GenServer.call(GenEts, {:get, key})
  end)
end

gen_set = fn ->
  Enum.map(1..1000, fn key ->
    GenServer.cast(GenEts, {:set, key, key})
  end)
end

gen_incr = fn ->
  Enum.map(1..1000, fn key ->
    GenServer.cast(GenEts, {:incr, key, key})
  end)
end

# Start benchmark
# Benchee.run(%{
#   # "gen_set" => gen_set,
#   # "gen_incr" => gen_incr,
#   "bag_set" => bag_set
#   # "ets_set" => ets_set,
#   # "ets_incr" => ets_incr
#   # "ets_con_set" => ets_con_set
# }, time: 10, parallel: 4, formatter_options: %{console: %{extended_statistics: true}})
#
# Benchee.run(%{
#   "gen_get" => gen_get,
#   "bag_get" => bag_get,
#   "ets_get" => ets_get,
#   "ets_con_get" => ets_con_get
# }, time: 10, parallel: 4, formatter_options: %{console: %{extended_statistics: true}})

Benchee.run(%{
  "bag_take" => bag_take,
  "ets_con_take" => ets_con_take
}, time: 10, parallel: 4, formatter_options: %{console: %{extended_statistics: true}})
