
current_time = :os.system_time(:microsecond)
input_datas = Enum.map(1..1000, fn _ -> current_time + Enum.random(1..100_000_000_000) end)
|> Enum.sort()

timex_format = fn ->
  Enum.each(input_datas, fn time ->
    Timex.from_unix(time, :microseconds) |> Timex.format!("{ISO:Extended}")
  end)
end

elixir_datetime = fn ->
  Enum.each(input_datas, fn time ->
    (DateTime.from_unix!(time, :microseconds) |> NaiveDateTime.to_iso8601()) <> "Z"
  end)
end

elixir_c = fn ->
  Enum.each(input_datas, fn time ->
    FastIso.formatiso(time)
  end)
end

elixir_c_string = fn ->
  Enum.each(input_datas, fn time ->
    List.to_string(FastIso.formatiso(time))
  end)
end

erlang_io_format = fn ->
  Enum.each(input_datas, fn time ->
    %DateTime{day: day, hour: hr, microsecond: {us, _}, minute: min, month: month, second: sec, year: year} = DateTime.from_unix!(time, :microseconds)
    "~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0B.~6.10.0B+00:00"
      |> :io_lib.format([year, month, day, hr, min, sec, us])
      |> List.to_string()
  end)
end

elixir_string_compose = fn ->
  Enum.each(input_datas, fn time ->
    <<a :: binary-size(4), b :: binary-size(6), c :: binary-size(6)>> = time |> Integer.to_string
    us = String.to_integer(c)
    {{year, month, day}, {hr, min, sec}} = :calendar.now_to_datetime(
      {String.to_integer(a), String.to_integer(b), us}
    )
    "#{year}-#{month |> Integer.to_string |> String.rjust(2, ?0)}-#{day |> Integer.to_string |> String.rjust(2, ?0)}T#{hr |> Integer.to_string |> String.rjust(2, ?0)}:#{min |> Integer.to_string |> String.rjust(2, ?0)}:#{sec |> Integer.to_string |> String.rjust(2, ?0)}.#{c}+00:00"
  end)
end

erlang_binary_compose = fn ->
  Enum.each(input_datas, fn time ->
    <<a :: binary-size(4), b :: binary-size(6), c :: binary-size(6)>> = time |> Integer.to_string
    us = String.to_integer(c)
    {{year, month, day}, {hr, min, sec}} = :calendar.now_to_datetime(
      {String.to_integer(a), String.to_integer(b), us}
    )
    year_b = year |> :erlang.integer_to_binary
    month_b = :erlang.integer_to_list(month) |> :string.right(2, ?0) |> :erlang.list_to_binary
    day_b = :erlang.integer_to_list(day) |> :string.right(2, ?0) |> :erlang.list_to_binary
    hr_b = :erlang.integer_to_list(hr) |> :string.right(2, ?0) |> :erlang.list_to_binary
    min_b = :erlang.integer_to_list(min) |> :string.right(2, ?0) |> :erlang.list_to_binary
    sec_b = :erlang.integer_to_list(sec) |> :string.right(2, ?0) |> :erlang.list_to_binary
    <<year_b :: binary-size(4), "-", month_b :: binary-size(2), "-", day_b :: binary-size(2), "T", hr_b :: binary-size(2), ":", min_b :: binary-size(2), ":", sec_b :: binary-size(2), ".", c :: binary-size(6), "+00:00">>
  end)
end

progressiv_elixir_c_string = fn ->
  Enum.reduce(input_datas, {0, ''}, fn (time, {last, day_string}) ->
    case div(time, 86_400_000_000) do
      ^last ->
        h_ms = rem(time, 86_400_000_000)
        m_ms = rem(h_ms, 3600_000_000)
        s_ms = rem(m_ms, 60_000_000)
        sec = div(s_ms, 1_000_000)
        min = div(m_ms, 60_000_000)
        hr = div(h_ms, 3600_000_000)

        <<_ :: binary-size(1), c :: binary-size(6)>> = :erlang.integer_to_binary(1_000_000 + rem(s_ms, 1_000_000))
        <<day_string :: binary-size(11),
        div(hr, 10) + 48,
        rem(hr, 10) + 48,
        ":",
        div(min, 10) + 48,
        rem(min, 10) + 48,
        ":",
        div(sec, 10) + 48,
        rem(sec, 10) + 48,
        ".",
        c :: binary-size(6),
        "+00:00">>
        {last, day_string}
      other ->
        [a, b, c, d, e, f, g, h, i, j, k | rest] = FastIso.formatiso(time)
        {other, <<a, b, c, d, e, f, g, h, i, j, k>>}
    end
  end)
end

progressiv_erlang_binary_compose = fn ->
  Enum.reduce(input_datas, {0, ''}, fn (time, {last, day_string}) ->
    case div(time, 86_400_000_000) do
      ^last ->
        h_ms = rem(time, 86_400_000_000)
        m_ms = rem(h_ms, 3600_000_000)
        s_ms = rem(m_ms, 60_000_000)
        sec = div(s_ms, 1_000_000)
        min = div(m_ms, 60_000_000)
        hr = div(h_ms, 3600_000_000)
      other ->
        secs = div(time, 1_000_000)
        {{year, month, day}, {hr, min, sec}} = :calendar.now_to_datetime(
          {div(secs, 1_000_000), rem(secs, 1_000_000), 0})
        year_b = year |> :erlang.integer_to_binary
        day_string = <<
        year_b :: binary-size(4),
        "-",
        div(month, 10) + 48,
        rem(month, 10) + 48,
        "-",
        div(day, 10) + 48,
        rem(day, 10) + 48,
        "T">>
        last = other
    end
    <<_ :: binary-size(1), c :: binary-size(6)>> = :erlang.integer_to_binary(1_000_000 + rem(time, 1_000_000))
    <<day_string :: binary-size(11),
    div(hr, 10) + 48,
    rem(hr, 10) + 48,
    ":",
    div(min, 10) + 48,
    rem(min, 10) + 48,
    ":",
    div(sec, 10) + 48,
    rem(sec, 10) + 48,
    ".",
    c :: binary-size(6),
    "+00:00">>
    {last, day_string}
  end)
end

# Start benchmark
Benchee.run(%{
  # "Timex formater" => timex_format,
  "Elixir DateTime.to_iso8601" => elixir_datetime,
  "Erlang io_lib:format" => erlang_io_format,
  "Elixir string compose" => elixir_string_compose,
  "Erlang string compose" => erlang_binary_compose,
  "Progressiv Erlang string compose" => progressiv_erlang_binary_compose,
  "Progressiv nif string" => progressiv_elixir_c_string,
  "Elixir nif" => elixir_c,
  "Elixir nif string" => elixir_c_string
}, time: 10, formatter_options: %{console: %{extended_statistics: true}}
)
