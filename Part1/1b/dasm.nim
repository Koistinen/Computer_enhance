import os
let
  args = commandLineParams()

echo "; disassembling " & args[0]
echo "bits 16"
var f: File

if not f.open args[0]:
  echo "failed to open file"
  quit QuitFailure

var a = newSeq[uint8] f.getFileSize

if f.getFileSize != f.readBytes(a, 0, f.getFileSize):
  echo "failed to read bytes"
  quit QuitFailure

let wregs = ["ax", "cx", "dx", "bx", "sp", "bp", "si", "di"]
let bregs = ["al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"] 

var i = 0

while i<a.len:
  case a[i]:
    of 0b10001000..0b10001011:
      let d = 1 and (a[i] shr 1)
      let w = 1 and a[i]
      inc i
      let md = (a[i] div 64) and 3
      let reg = (a[i] div 8) and 7
      let rm = a[i] and 7
      inc i
      let regs =
        if w == 0: bregs[reg]
        else: wregs[reg]
      let rms =
        if md == 0b11:
          if w == 0: bregs[rm]
          else: wregs[rm]
        else: "undefined"
      if d == 1:
        echo "mov " & regs & ", " & rms
      else:
        echo "mov " & rms & ", " & regs
    else:
      echo "unknown instruction"
      quit(QuitFailure)
  
