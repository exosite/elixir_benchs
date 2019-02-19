# Buffer: ETS or Genserver

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
:ets.new(:bag, [:bag, :public, :named_table])
:ets.new(:bag_con, [:bag, :public, :named_table, write_concurrency: true, read_concurrency: true])

ets = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:tablename, {key, key})
    case :ets.lookup(:tablename, key) do
      [] -> nil
      [result] -> result
      _ -> raise "expected only a single element with key " <> inspect(key)
    end
  end)
end

ets_con = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:concurrent, {key, key})
    case :ets.lookup(:concurrent, key) do
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

ets_incr_con = fn ->
  Enum.map(1..1000, fn key ->
    :ets.update_counter(:concurrent, key, key, {key, 0})
  end)
end

bag = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:bag, {:bag, key})
  end)
  case :ets.lookup(:bag, :bag) do
    [] -> nil
    result when is_list(result) ->
      Enum.map(result, &({&1, 0}))
    [result] -> result
    _ -> raise "expected only a single element with key "
  end
end

bag_con = fn ->
  Enum.map(1..1000, fn key ->
    :ets.insert(:bag_con, {:bag_con, key})
  end)
  case :ets.lookup(:bag_con, :bag_con) do
    [] -> nil
    result when is_list(result) ->
      Enum.map(result, &({&1, 0}))
    [result] -> result
    _ -> raise "expected only a single element with key "
  end
end

gen = fn ->
  Enum.map(1..1000, fn key ->
    GenServer.call(GenEts, {:get, key})
    GenServer.cast(GenEts, {:set, key, key})
  end)
end

gen_incr = fn ->
  Enum.map(1..1000, fn key ->
    GenServer.cast(GenEts, {:incr, key, key})
  end)
end

# Start benchmark
Benchee.run(%{
  "GetSet - GenServer" => gen,
  "GetSet - ETS" => ets,
  "GetSet - ETS concurrent" => ets_con,
  "GetSet - Bag" => bag,
  "GetSet - Bag concurrent" => bag_con,
  "Inc - GenServer" => gen_incr,
  "Inc - ETS" => ets_incr,
  "Inc - ETS concurrent" => ets_incr_con
}, time: 10, parallel: 4, formatter_options: %{console: %{extended_statistics: false}})
