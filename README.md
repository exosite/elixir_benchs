# IsoTimeFormatting
Benchmarking the iso8601 time formatting.

1519875343417238 => "2018-03-01T03:35:43.417238Z"

## Prerequisite
- Elixir 1.4.5
- Erlang/OTP 19

## Run it!
1. `mix deps.get`
2. `mix run bench/iso_time_formatting_bench.ex`

## Current winner
```
Name                                       ips        average  deviation         median         99th %
Progressiv Erlang string compose       2710.38        0.37 ms    ±12.72%        0.36 ms        0.58 ms
Elixir DateTime.to_iso8601              366.76        2.73 ms     ±8.82%        2.67 ms        4.03 ms
Erlang string compose                   347.51        2.88 ms    ±12.78%        2.71 ms        3.83 ms
Elixir string compose                   318.64        3.14 ms     ±9.79%        3.06 ms        4.36 ms
Erlang io_lib:format                    166.07        6.02 ms     ±7.44%        5.95 ms        8.05 ms
Timex formater                           26.50       37.74 ms     ±3.74%       37.69 ms       43.06 ms

Comparison:
Progressiv Erlang string compose       2710.38
Elixir DateTime.to_iso8601              366.76 - 7.39x slower
Erlang string compose                   347.51 - 7.80x slower
Elixir string compose                   318.64 - 8.51x slower
Erlang io_lib:format                    166.07 - 16.32x slower
Timex formater                           26.50 - 102.30x slower

Extended statistics:

Name                                     minimum        maximum    sample size                     mode
Progressiv Erlang string compose         0.32 ms        1.58 ms        27.00 K                  0.33 ms
Elixir DateTime.to_iso8601               2.51 ms        4.94 ms         3.67 K                  2.63 ms
Erlang string compose                    2.35 ms        4.83 ms         3.47 K                  2.59 ms
Elixir string compose                    2.79 ms        5.97 ms         3.19 K         2.93 ms, 2.89 ms
Erlang io_lib:format                     5.43 ms        9.55 ms         1.66 K5.93 ms, 5.83 ms, 5.90 ms
Timex formater                          34.73 ms       43.33 ms            26536.47 ms, 38.24 ms, 36.44

```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/iso_time_formatting](https://hexdocs.pm/iso_time_formatting).
