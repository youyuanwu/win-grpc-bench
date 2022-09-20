## wingrpc
```
PS C:\Users\user1\Code\cpp\win-grpc-bench> .\scripts\bench.ps1
Start win_grpc Using [Debug] build. hostport: [localhost:12356]
warming up
start bench

Summary:
  Count:        6579
  Total:        20.00 s
  Slowest:      19.75 s
  Fastest:      64.63 ms
  Average:      3.03 s
  Requests/sec: 328.91

Response time histogram:
  64.628    [1]    |
  2033.601  [4847] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  4002.574  [0]    |
  5971.547  [0]    |
  7940.520  [0]    |
  9909.493  [0]    |
  11878.466 [0]    |
  13847.439 [0]    |
  15816.412 [0]    |
  17785.385 [0]    |
  19754.358 [740]  |∎∎∎∎∎∎

Latency distribution:
  10 % in 102.49 ms
  25 % in 109.11 ms
  50 % in 113.20 ms
  75 % in 122.37 ms
  90 % in 19.10 s
  95 % in 19.13 s
  99 % in 19.19 s

Status code distribution:
  [Canceled]      133 responses
  [OK]            5588 responses
  [Unavailable]   858 responses
```
## grpc mint
```
.\scripts\bench.ps1 -Flavour grpc_mt
Start grpc_mt Using [Debug] build. hostport: [localhost:50051]
warming up
start bench

Summary:
  Count:        122128
  Total:        20.00 s
  Slowest:      2.67 s
  Fastest:      0 ns
  Average:      162.54 ms
  Requests/sec: 6105.95

Response time histogram:
  0.000    [28]     |
  266.947  [120138] |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  533.895  [0]      |
  800.842  [0]      |
  1067.789 [0]      |
  1334.736 [0]      |
  1601.684 [0]      |
  1868.631 [869]    |
  2135.578 [37]     |
  2402.526 [41]     |
  2669.473 [53]     |

Latency distribution:
  10 % in 124.28 ms
  25 % in 131.59 ms
  50 % in 155.44 ms
  75 % in 163.62 ms
  90 % in 171.71 ms
  95 % in 175.27 ms
  99 % in 190.07 ms

Status code distribution:
  [OK]            121166 responses
  [Unavailable]   962 responses
```