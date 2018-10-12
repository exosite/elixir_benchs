
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
:ets.new(:tablename, [:public, :named_table, read_concurrency: true])

ets_get = fn ->
  Enum.map(1..100, fn key ->
    case :ets.lookup(:tablename, key) do
      [] -> nil
      [result] -> result
      _ -> raise "expected only a single element with key " <> inspect(key)
    end
  end)
end

ets_set = fn ->
  Enum.map(1..100, fn key ->
    :ets.insert(:tablename, {key, key})
  end)
end

ets_incr = fn ->
  Enum.map(1..100, fn key ->
    :ets.update_counter(:tablename, key, key, {key, 0})
  end)
end

gen_get = fn ->
  Enum.map(1..100, fn key ->
    GenServer.call(GenEts, {:get, key})
  end)
end

gen_set = fn ->
  Enum.map(1..100, fn key ->
    GenServer.cast(GenEts, {:set, key, key})
  end)
end

gen_incr = fn ->
  Enum.map(1..100, fn key ->
    GenServer.cast(GenEts, {:incr, key, key})
  end)
end

# Start benchmark
Benchee.run(%{
  "gen_set" => gen_set,
  "gen_get" => gen_get,
  "gen_incr" => gen_incr,
  "ets_set" => ets_set,
  "ets_get" => ets_get,
  "ets_incr" => ets_incr
}, time: 10, formatter_options: %{console: %{extended_statistics: true}})
