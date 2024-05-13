import std/os

import std/monotimes

const
  sz1 = 1u64 shl 18
  sz2 = 1u64 shl 10
  sz = sz1*sz2

var b = newSeq[int8](sz)
var start = getMonoTime().ticks
sleep(1000)
var stop = getMonoTime().ticks

let ticksPerSecond = stop-start

start = getMonoTime().ticks
for i in 0..(sz-1):
  b[i] = 1
stop = getMonoTime().ticks
echo sz.float*ticksPerSecond.float/(stop-start).float/1000000000.0

var t = 1u64

start = getMonoTime().ticks
for i in 0..(sz1-1):
  for k in 0..(sz2-1):
    t.inc b[i+k*sz1]
stop = getMonoTime().ticks

if t == 0: echo "Zero!"
else: echo $sz & " " & "done."
echo sz.float*ticksPerSecond.float/(stop-start).float/1000000000.0
