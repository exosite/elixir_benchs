# IsoTimeFormatting
Benchmarking the iso8601 time formatting.

1519875343417238 => "2018-03-01T03:35:43.417238Z"

## Prerequisite
- Elixir 1.4.5
- Erlang/OTP 19

## Run it!
1. `mix deps.get`
2. `mix run ./bench/iso_time_formatting_bench.exs`

## Current winner
```
Name                                       ips        average  deviation         median         99th %
Elixir nif                              6.50 K       0.154 ms    ±21.63%       0.136 ms        0.27 ms
Progressiv nif string                   3.03 K        0.33 ms    ±11.52%        0.32 ms        0.51 ms
Progressiv Erlang string compose        3.02 K        0.33 ms     ±9.08%        0.32 ms        0.45 ms
Elixir nif string                       2.37 K        0.42 ms    ±13.50%        0.41 ms        0.63 ms
Erlang string compose                   0.57 K        1.76 ms     ±8.50%        1.74 ms        2.54 ms
Elixir string compose                   0.45 K        2.25 ms     ±9.94%        2.21 ms        3.26 ms
Elixir DateTime.to_iso8601              0.36 K        2.77 ms     ±7.42%        2.72 ms        3.78 ms
Erlang io_lib:format                   0.140 K        7.17 ms     ±9.71%        7.18 ms        9.95 ms

Comparison:
Elixir nif                              6.50 K
Progressiv nif string                   3.03 K - 2.14x slower
Progressiv Erlang string compose        3.02 K - 2.15x slower
Elixir nif string                       2.37 K - 2.74x slower
Erlang string compose                   0.57 K - 11.46x slower
Elixir string compose                   0.45 K - 14.60x slower
Elixir DateTime.to_iso8601              0.36 K - 18.01x slower
Erlang io_lib:format                   0.140 K - 46.57x slower

Extended statistics:

Name                                     minimum        maximum    sample size                     mode
Elixir nif                              0.134 ms        0.90 ms        64.47 K                 0.136 ms
Progressiv nif string                    0.30 ms        1.42 ms        30.19 K                  0.31 ms
Progressiv Erlang string compose         0.31 ms        1.42 ms        30.08 K                  0.31 ms
Elixir nif string                        0.35 ms        1.80 ms        23.64 K                  0.40 ms
Erlang string compose                    1.59 ms        3.86 ms         5.67 K                  1.68 ms
Elixir string compose                    1.96 ms        4.99 ms         4.45 K                  2.15 ms
Elixir DateTime.to_iso8601               2.56 ms        5.07 ms         3.61 K         2.71 ms, 2.66 ms
Erlang io_lib:format                     5.60 ms       10.93 ms         1.40 K7.30 ms, 7.17 ms, 7.26 ms
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/iso_time_formatting](https://hexdocs.pm/iso_time_formatting).
