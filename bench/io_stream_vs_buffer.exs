# IO stream vs buffer

:ets.new(:concurrent, [:public, :named_table, write_concurrency: true, read_concurrency: true])
{:ok, pid} = File.open("/tmp/bubu", [:write, :append])
Process.register(pid, :file)
{:ok, pid2} = File.open("/tmp/bubu2", [:write, :append, {:delayed_write, 8000, 100}])
Process.register(pid2, :file2)

buffer = fn ->
  i = :rand.uniform()
  log = Float.to_string(:erlang.monotonic_time(:microsecond) + i)
  log = << log :: binary, log :: binary, log :: binary, log :: binary, log :: binary, log :: binary, log :: binary >>

  Enum.map(1..10000, fn key ->
    :ets.insert(:concurrent, {<< log :: binary, Integer.to_string(key) :: binary >>})
  end)
  :ets.tab2list(:concurrent)
  |> Enum.reduce({"",0}, fn
    {log}, {buffer, size} when size < 10000 ->
      {<< buffer :: binary, log :: binary >>, size + byte_size(log)}
    {log}, {buffer, _} ->
      IO.puts(:file, << buffer :: binary, ?\n, log :: binary >>)
      {"",0}
  end)
  :ets.delete_all_objects(:concurrent)
end

stream = fn ->
  i = :rand.uniform()
  log = Float.to_string(:erlang.monotonic_time(:microsecond) + i)
  log = << log :: binary, log :: binary, log :: binary, log :: binary, log :: binary, log :: binary, log :: binary >>

  Enum.map(1..10000, fn key ->
    IO.puts(:file2, << log :: binary, Integer.to_string(key) :: binary >>)
  end)
end

Benchee.run(%{
  "Stream" => stream,
  "Buffer" => buffer
}, time: 10, parallel: 4, formatter_options: %{console: %{extended_statistics: true}})
