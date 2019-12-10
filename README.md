# Various Elixir benchmark to find out what is the most efficient patterns

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/<bench>](https://hexdocs.pm/<bench>).

## Prerequisite
- Elixir 1.4.5
- Erlang/OTP 19


## Do it!
1. Copy an existing file from the bench folder
2. Replace the function to bench and at the bottom which one to execute
3. If needed udpate dependencies `mix deps.get`
4. Run test `mix run bench/my_bench.ex`

## Benchmarks

### Iso Time Formatting
Benchmarking the iso8601 time formatting.

1519875343417238 => "2018-03-01T03:35:43.417238Z"

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
```

### RFC2822 date formatting

```
Name              ips        average  deviation         median         99th %
custom         414.66        2.41 ms    ±12.58%        2.33 ms        3.33 ms
io_lib          50.65       19.74 ms    ±11.55%       19.85 ms       28.15 ms

Comparison:
custom         414.66
io_lib          50.65 - 8.19x slower
```

### Concat List

```
Name                      ips        average  deviation         median         99th %
native ++            435.29 K        2.30 μs  ±1481.14%           2 μs           9 μs
recursive [h|t]      233.35 K        4.29 μs   ±952.63%           3 μs          15 μs

Comparison:
native ++            435.29 K
recursive [h|t]      233.35 K - 1.87x slower
```

### To binary

```
Name                        ips        average  deviation         median         99th %
Integer.toString        18.56 K       53.89 μs    ±25.06%          50 μs          92 μs
list                    18.05 K       55.40 μs    ±52.55%          50 μs         114 μs
list with case          15.76 K       63.45 μs    ±36.16%          59 μs         128 μs
Integer with case       15.18 K       65.88 μs    ±33.96%          58 μs         134 μs
inspect with case       13.55 K       73.79 μs    ±25.12%          71 μs         144 μs
to_string                8.96 K      111.56 μs    ±20.73%         105 μs         212 μs
string format            3.72 K      268.66 μs    ±32.54%         255 μs      637.56 μs
inspect                  2.24 K      447.19 μs    ±23.67%         411 μs      852.55 μs

Comparison:
Integer.toString        18.56 K
list                    18.05 K - 1.03x slower
list with case          15.76 K - 1.18x slower
Integer with case       15.18 K - 1.22x slower
inspect with case       13.55 K - 1.37x slower
to_string                8.96 K - 2.07x slower
string format            3.72 K - 4.99x slower
inspect                  2.24 K - 8.30x slower
```

### Json encoding

```
Name                                       ips        average  deviation         median         99th %
List with encoded values                256.38        3.90 ms     ±9.44%        3.76 ms        5.34 ms
String with encoded values              240.94        4.15 ms    ±15.83%        3.92 ms        6.99 ms
Full jiffy encoding: key=atoms          182.65        5.48 ms    ±16.33%        5.11 ms        9.05 ms
Full jiffy encoding: key=strings        126.12        7.93 ms    ±13.28%        7.53 ms       12.15 ms
Inspect                                  17.22       58.06 ms    ±11.68%       55.94 ms       80.26 ms

Comparison:
List with encoded values                256.38
String with encoded values              240.94 - 1.06x slower
Full jiffy encoding: key=atoms          182.65 - 1.40x slower
Full jiffy encoding: key=strings        126.12 - 2.03x slower
Inspect                                  17.22 - 14.89x slower
```

### IO stream vs buffer

```
Name             ips        average  deviation         median         99th %
Buffer         18.37       54.45 ms    ±46.07%       52.10 ms      127.00 ms
Stream          5.51      181.49 ms    ±13.39%      174.98 ms      269.83 ms

Comparison:
Buffer         18.37
Stream          5.51 - 3.33x slower
```

### Buffer: ETS Bags or normal or concurrent

```
Name                                 ips        average  deviation         median         99th %
Ets.take + concurrent=true        687.38        1.46 ms    ±41.14%        1.19 ms        3.56 ms
Bag.take                          229.27        4.36 ms    ±40.71%        3.98 ms       10.18 ms
Ets.take                          145.28        6.88 ms    ±85.82%        3.88 ms       26.85 ms

Comparison:
Ets.take + concurrent=true        687.38
Bag.take                          229.27 - 3.00x slower
Ets.take                          145.28 - 4.73x slower
```

### Buffer: Genserver vs ETS

```
Name                              ips        average  deviation         median         99th %
Inc - ETS concurrent          1797.04        0.56 ms    ±57.59%        0.41 ms        1.72 ms
GetSet - ETS concurrent        844.71        1.18 ms    ±53.26%        0.98 ms        3.12 ms
Inc - ETS                      419.70        2.38 ms   ±117.60%        1.14 ms       11.39 ms
Inc - GenServer                419.08        2.39 ms   ±100.76%        1.52 ms       13.06 ms
GetSet - ETS                   361.53        2.77 ms    ±98.91%        1.70 ms       14.37 ms
GetSet - GenServer              99.51       10.05 ms    ±15.66%        9.79 ms       15.20 ms
GetSet - Bag                    41.24       24.25 ms    ±11.82%       23.60 ms       37.71 ms
GetSet - Bag concurrent         33.95       29.46 ms    ±35.29%       25.96 ms       83.39 ms

Comparison:
Inc - ETS concurrent          1797.04
GetSet - ETS concurrent        859.30 - 2.09x slower
Inc - ETS                      429.89 - 4.18x slower
Inc - GenServer                419.08 - 4.29x slower
GetSet - ETS                   361.53 - 4.97x slower
GetSet - GenServer              99.51 - 18.06x slower
GetSet - Bag                    41.24 - 43.57x slower
GetSet - Bag concurrent         33.95 - 52.93x slower
```

### Kernel.put_in vs Map.put

```
Name                    ips        average  deviation         median         99th %
Map.get/put          5.35 K      186.85 μs    ±33.53%         161 μs         443 μs
Map.update           5.04 K      198.38 μs    ±31.63%         178 μs         501 μs
[]Map.put            4.03 K      247.93 μs    ±33.97%         228 μs         579 μs
Kernel.put_in        2.20 K      453.96 μs    ±27.55%         417 μs         985 μs

Comparison:
Map.get/put          5.35 K
Map.update           5.04 K - 1.06x slower
[]Map.put            4.03 K - 1.33x slower
Kernel.put_in        2.20 K - 2.43x slower
```

**Nested 3 lvl**

```
Name               ips        average  deviation         median         99th %
put_3           9.13 K      109.52 μs    ±15.83%         106 μs         186 μs
kernel_3        3.42 K      292.71 μs    ±18.28%         278 μs         560 μs

Comparison:
put_3           9.13 K
kernel_3        3.42 K - 2.67x slower
```

### List & String length
```
Name                                ips        average  deviation         median         99th %
byte_size (only ascii)         27027.45      0.0370 ms    ±24.21%      0.0350 ms      0.0610 ms
Kernel.length                    556.81        1.80 ms    ±29.18%        2.13 ms        2.64 ms
Recursive list                   229.23        4.36 ms     ±6.66%        4.26 ms        5.57 ms
String.to_charlist length         67.61       14.79 ms     ±5.00%       14.73 ms       16.98 ms
Enum.reduce                       56.48       17.71 ms    ±11.94%       18.37 ms       25.40 ms
Recursive string                  40.91       24.45 ms     ±2.28%       24.36 ms       26.63 ms
String.length                      6.10      163.99 ms     ±2.63%      163.35 ms      180.55 ms
String.codepoints length           3.13      319.48 ms     ±2.22%      316.74 ms      352.37 ms

Comparison:
byte_size (only ascii)         27027.45
Kernel.length                    556.81 - 48.54x slower
Recursive list                   229.23 - 117.91x slower
String.to_charlist length         67.61 - 399.77x slower
Enum.reduce                       56.48 - 478.51x slower
Recursive string                  40.91 - 660.72x slower
String.length                      6.10 - 4432.10x slower
String.codepoints length           3.13 - 8634.85x slower
```

### List.fold vs Enum.reduce vs Recursive

```
Name                                          ips        average  deviation         median         99th %
Recursive                                  185.70        5.39 ms    ±12.50%        5.26 ms        7.79 ms
List.foldl with referenced function         63.97       15.63 ms     ±7.86%       15.44 ms       21.88 ms
Enum.reduce                                 54.20       18.45 ms     ±6.95%       18.24 ms       24.26 ms
List.foldl                                  52.16       19.17 ms     ±5.44%       19.04 ms       22.06 ms

Comparison:
Recursive                                  185.70
List.foldl with referenced function         63.97 - 2.90x slower
Enum.reduce                                 54.20 - 3.43x slower
List.foldl                                  52.16 - 3.56x slower
```

### Regex

```
Name                                         ips        average  deviation         median         99th %
Regex.run short & const                   486.07        2.06 ms    ±12.99%        1.95 ms        3.04 ms
Regex.named_captures short                371.15        2.69 ms    ±12.00%        2.60 ms        3.78 ms
Regex.named_captures short & const        365.34        2.74 ms    ±10.42%        2.63 ms        3.63 ms
Regex.named_captures                      153.08        6.53 ms    ±14.84%        6.23 ms        9.88 ms

Comparison:
Regex.run short & const                   486.07
Regex.named_captures short                371.15 - 1.31x slower
Regex.named_captures short & const        365.34 - 1.33x slower
Regex.named_captures                      153.08 - 3.18x slower
```

### Jiffy vs Poison

```
Comparison:
jiffy encoding         476.55
poison encoding        391.92 - 1.22x slower
jiffy decoding         355.60 - 1.34x slower
poison decoding        181.53 - 2.63x slower
```
