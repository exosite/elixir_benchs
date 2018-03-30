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
Comparison:
Progressiv Erlang string compose        721.49
Erlang string compose                   528.57 - 1.36x slower
Elixir string compose                   466.66 - 1.55x slower
Elixir DateTime.to_iso8601              352.81 - 2.04x slower
Erlang io_lib:format                    163.85 - 4.40x slower
Timex formater                           26.73 - 26.99x slower

Extended statistics:

Name                                     minimum        maximum    sample size                     mode
Progressiv Erlang string compose         1.27 ms        2.98 ms         7.21 K         1.36 ms, 1.36 ms
Erlang string compose                    1.52 ms        4.40 ms         5.28 K                  1.68 ms
Elixir string compose                    1.92 ms        4.16 ms         4.66 K                  2.04 ms
Elixir DateTime.to_iso8601               2.51 ms        5.02 ms         3.53 K                  2.71 ms
Erlang io_lib:format                     5.51 ms        8.61 ms         1.64 K         6.35 ms, 6.45 ms
Timex formater                          34.38 ms       46.36 ms         26837.62 ms, 37.65 ms, 37.46
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/iso_time_formatting](https://hexdocs.pm/iso_time_formatting).
