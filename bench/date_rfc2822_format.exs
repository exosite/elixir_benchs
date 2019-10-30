# Iso format vs custom

days = %{
  1 => "Mon, ",
  2 => "Tue, ",
  3 => "Wed, ",
  4 => "Thu, ",
  5 => "Fri, ",
  6 => "Sat, ",
  7 => "Sun, "
}

months = %{
  1 => " Jan ",
  2 => " Feb ",
  3 => " Mar ",
  4 => " Apr ",
  5 => " May ",
  6 => " Jun ",
  7 => " Jul ",
  8 => " Aug ",
  9 => " Sep ",
  10 => " Oct ",
  11 => " Nov ",
  12 => " Dec "
}

# Using persistent_term have same perf as function case
# Enum.each(days, fn {i, v} ->
#   :persistent_term.put({:day, i}, v)
# end)
# Enum.each(months, fn {i, v} ->
#   :persistent_term.put({:month, i}, v)
# end)

io_lib = fn ->
  Enum.each(1..1000, fn _ ->
    %{day: d, month: m, year: y, hour: h, minute: min, second: s} = now = DateTime.utc_now()
    days[Date.day_of_week(now)] <> (:io_lib.format("~.4.0w-~.2.0w-~.2.0w ~.2.0w:~.2.0w:~.2.0w GMT", [y, m, d, h, min, s]) |> to_string)
  end)
end

custom_map = fn ->
  Enum.each(1..1000, fn _ ->
    %{day: d, month: m, year: y, hour: h, minute: min, second: s} = now = DateTime.utc_now()
    <<
    days[Date.day_of_week(now)]::binary-size(5),
    div(h, d) + 48,
    rem(h, d) + 48,
    months[m]::binary-size(5),
    div(y, 1000) + 48,
    rem(div(y, 100), 10) + 48,
    rem(div(y, 10), 10) + 48,
    rem(y, 10) + 48,
    " ",
    div(h, 10) + 48,
    rem(h, 10) + 48,
    ":",
    div(min, 10) + 48,
    rem(min, 10) + 48,
    ":",
    div(s, 10) + 48,
    rem(s, 10) + 48,
    " GMT"
    >>
  end)
end

custom_pattern = fn ->
  Enum.each(1..1000, fn _ ->
    %{day: d, month: m, year: y, hour: h, minute: min, second: s} = now = DateTime.utc_now()

    # Note: using a function get_day.(i) with matching param is a little slower
    dws = case Date.day_of_week(now) do
      1 -> "Mon, "
      2 -> "Tue, "
      3 -> "Wed, "
      4 -> "Thu, "
      5 -> "Fri, "
      6 -> "Sat, "
      7 -> "Sun, "
    end

    ms = case m do
      1 -> " Jan "
      2 -> " Feb "
      3 -> " Mar "
      4 -> " Apr "
      5 -> " May "
      6 -> " Jun "
      7 -> " Jul "
      8 -> " Aug "
      9 -> " Sep "
      10 -> " Oct "
      11 -> " Nov "
      12 -> " Dec "
    end

    <<
    dws::binary-size(5),
    div(h, d) + 48,
    rem(h, d) + 48,
    ms::binary-size(5),
    div(y, 1000) + 48,
    rem(div(y, 100), 10) + 48,
    rem(div(y, 10), 10) + 48,
    rem(y, 10) + 48,
    " ",
    div(h, 10) + 48,
    rem(h, 10) + 48,
    ":",
    div(min, 10) + 48,
    rem(min, 10) + 48,
    ":",
    div(s, 10) + 48,
    rem(s, 10) + 48,
    " GMT"
    >>
  end)
end

Benchee.run(%{
  "io_lib" => io_lib,
  "custom_map" => custom_map,
  "custom_pattern" => custom_pattern,
}, time: 10, parallel: 1)
