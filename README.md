# IsoTimeFormatting
Benchmarking the iso8601 time formatting.

## Prerequisite
- Elixir 1.4.5
- Erlang/OTP 19

## Run it!
1. `mix deps.get`
2. `mix run bench/iso_time_formatting_bench.ex`

## Current winner
```
Name                                 ips        average  deviation         median         99th %
Erlang string compose              63.20       15.82 ms    ±16.33%       14.75 ms       24.72 ms
Elixir string compose              34.70       28.82 ms     ±9.45%       27.63 ms       39.21 ms
Elixir DateTime.to_iso8601         24.27       41.21 ms    ±19.18%       37.58 ms       72.29 ms
Erlang io_lib:format               13.90       71.94 ms    ±22.88%       69.28 ms      180.89 ms
Timex formater                      2.03      492.77 ms    ±10.24%      478.47 ms      665.61 ms

Comparison:
Erlang string compose              63.20
Elixir string compose              34.70 - 1.82x slower
Elixir DateTime.to_iso8601         24.27 - 2.60x slower
Erlang io_lib:format               13.90 - 4.55x slower
Timex formater                      2.03 - 31.14x slower
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/iso_time_formatting](https://hexdocs.pm/iso_time_formatting).
