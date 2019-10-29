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

numbers = %{
  0 => "00",
  1 => "01",
  2 => "02",
  3 => "03",
  4 => "04",
  5 => "05",
  6 => "06",
  7 => "07",
  8 => "08",
  9 => "09",
  10 => "10",
  11 => "11",
  12 => "12",
  13 => "13",
  14 => "14",
  15 => "15",
  16 => "16",
  17 => "17",
  18 => "18",
  19 => "19",
  20 => "20",
  21 => "21",
  22 => "22",
  23 => "23",
  24 => "24",
  25 => "25",
  26 => "26",
  27 => "27",
  28 => "28",
  29 => "29",
  30 => "30",
  31 => "31",
  32 => "32",
  33 => "33",
  34 => "34",
  35 => "35",
  36 => "36",
  37 => "37",
  38 => "38",
  39 => "39",
  40 => "40",
  41 => "41",
  42 => "42",
  43 => "43",
  44 => "44",
  45 => "45",
  46 => "46",
  47 => "47",
  48 => "48",
  49 => "49",
  50 => "50",
  51 => "51",
  52 => "52",
  53 => "53",
  54 => "54",
  55 => "55",
  56 => "56",
  57 => "57",
  58 => "58",
  59 => "59",
  60 => "60",
  61 => "61",
  62 => "62",
  83 => "83",
  63 => "63",
  68 => "68",
  78 => "78",
  64 => "64",
  75 => "75",
  81 => "81",
  71 => "71",
  65 => "65",
  98 => "98",
  79 => "79",
  99 => "99",
  67 => "67",
  66 => "66",
  85 => "85",
  76 => "76",
  69 => "69",
  84 => "84",
  82 => "82",
  94 => "94",
  91 => "91",
  87 => "87",
  74 => "74",
  70 => "70",
  72 => "72",
  86 => "86",
  95 => "95",
  97 => "97",
  89 => "89",
  96 => "96",
  73 => "73",
  90 => "90",
  80 => "80",
  88 => "88",
  77 => "77",
  92 => "92",
  93 => "93"
}

io_lib = fn ->
  Enum.each(1..1000, fn _ ->
    %{day: d, month: m, year: y, hour: h, minute: min, second: s} = now = DateTime.utc_now()
    day = days[Date.day_of_week(now)]
    day <> (:io_lib.format("~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0w.000Z", [y, m, d, h, min, s]) |> to_string)
  end)
end

custom = fn ->
  Enum.each(1..1000, fn _ ->
    %{day: d, month: m, year: y, hour: h, minute: min, second: s} = now = DateTime.utc_now()
    dw = Date.day_of_week(now)
    << days[dw]::binary, ", ", numbers[d]::binary, " ", months[m]::binary, " ", Integer.to_string(y)::binary, " ", numbers[h]::binary, ":", numbers[min]::binary, ":", numbers[s]::binary, " GMT" >>
  end)
end

Benchee.run(%{
  "io_lib" => io_lib,
  "custom" => custom
}, time: 10, parallel: 1)