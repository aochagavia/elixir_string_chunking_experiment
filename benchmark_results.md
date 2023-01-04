The output below results from running `mix run benchmarks/chunk.ex` on my machine

```
##### With input 00500 bytes #####
Name                    ips        average  deviation         median         99th %
chunks rust          2.80 K      357.52 μs     ±3.23%      352.86 μs      409.68 μs
chunks hybrid        2.15 K      465.81 μs     ±1.82%      463.03 μs      497.53 μs
chunks elixir       0.134 K     7490.63 μs     ±3.92%     7457.04 μs     8301.39 μs

Comparison:
chunks rust          2.80 K
chunks hybrid        2.15 K - 1.30x slower +108.29 μs
chunks elixir       0.134 K - 20.95x slower +7133.11 μs

##### With input 01000 bytes #####
Name                    ips        average  deviation         median         99th %
chunks rust          1.38 K      724.36 μs     ±5.21%      721.75 μs      820.49 μs
chunks hybrid        1.03 K      971.39 μs     ±3.63%      965.11 μs     1116.00 μs
chunks elixir      0.0629 K    15899.14 μs     ±2.74%    15839.71 μs    17841.53 μs

Comparison:
chunks rust          1.38 K
chunks hybrid        1.03 K - 1.34x slower +247.03 μs
chunks elixir      0.0629 K - 21.95x slower +15174.78 μs

##### With input 02000 bytes #####
Name                    ips        average  deviation         median         99th %
chunks rust          702.76        1.42 ms     ±1.93%        1.42 ms        1.52 ms
chunks hybrid        515.64        1.94 ms     ±2.39%        1.93 ms        2.16 ms
chunks elixir         28.10       35.59 ms     ±1.02%       35.53 ms       37.20 ms

Comparison:
chunks rust          702.76
chunks hybrid        515.64 - 1.36x slower +0.52 ms
chunks elixir         28.10 - 25.01x slower +34.17 ms

##### With input 04000 bytes #####
Name                    ips        average  deviation         median         99th %
chunks rust          342.37        2.92 ms     ±1.32%        2.91 ms        3.11 ms
chunks hybrid        249.31        4.01 ms     ±3.75%        3.98 ms        4.54 ms
chunks elixir         11.69       85.51 ms     ±1.34%       85.28 ms       92.54 ms

Comparison:
chunks rust          342.37
chunks hybrid        249.31 - 1.37x slower +1.09 ms
chunks elixir         11.69 - 29.27x slower +82.59 ms

##### With input 08000 bytes #####
Name                    ips        average  deviation         median         99th %
chunks rust          170.84        5.85 ms     ±0.90%        5.84 ms        6.13 ms
chunks hybrid        125.10        7.99 ms     ±2.14%        7.97 ms        8.96 ms
chunks elixir          4.44      225.39 ms     ±0.36%      225.46 ms      227.36 ms

Comparison:
chunks rust          170.84
chunks hybrid        125.10 - 1.37x slower +2.14 ms
chunks elixir          4.44 - 38.51x slower +219.53 ms

##### With input 16000 bytes #####
Name                    ips        average  deviation         median         99th %
chunks rust           85.04       11.76 ms     ±0.96%       11.74 ms       12.47 ms
chunks hybrid         63.42       15.77 ms     ±3.49%       15.66 ms       19.44 ms
chunks elixir          1.51      664.05 ms     ±0.32%      664.40 ms      667.79 ms

Comparison:
chunks rust           85.04
chunks hybrid         63.42 - 1.34x slower +4.01 ms
chunks elixir          1.51 - 56.47x slower +652.29 ms
```