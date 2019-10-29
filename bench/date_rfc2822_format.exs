# Iso format vs custom

days = %{
  1 => "Mon",
  2 => "Tue",
  3 => "Wed",
  4 => "Thu",
  5 => "Fri",
  6 => "Sat",
  7 => "Sun"
}

months = %{
  1 => "Jan",
  2 => "Feb",
  3 => "Mar",
  4 => "Apr",
  5 => "May",
  6 => "Jun",
  7 => "Jul",
  8 => "Aug",
  9 => "Sep",
  10 => "Oct",
  11 => "Nov",
  12 => "Dec"
}

day_key_offset = 89435
month_key_offset = 74558

Enum.each(days, fn {i, v} ->
  :persistent_term.put(day_key_offset + i, v)
end)
Enum.each(months, fn {i, v} ->
  :persistent_term.put(month_key_offset + i, v)
end)

io_lib = fn ->
  Enum.each(1..1000, fn _ ->
    %{day: d, month: m, year: y, hour: h, minute: min, second: s} = now = DateTime.utc_now()
    day = :persistent_term.get(day_key_offset + Date.day_of_week(now))
    day <> (:io_lib.format("~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0w.000Z", [y, m, d, h, min, s]) |> to_string)
  end)
end

custom = fn ->
  Enum.each(1..1000, fn _ ->
    %{day: d, month: m, year: y, hour: h, minute: min, second: s} = now = DateTime.utc_now()
    dw = Date.day_of_week(now)
    <<
    :persistent_term.get(day_key_offset + dw)::binary-size(3),
    ", ",
    div(h, d) + 48,
    rem(h, d) + 48,
    " ",
    :persistent_term.get(month_key_offset + m)::binary-size(3),
    " ",
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
  "custom" => custom,
  "io_lib" => io_lib,
}, time: 10, parallel: 1)
