#!/bin/bash

echo DDR parameter header file: $1
echo DDR parameter binary file: $2

IFS="
"

rm -f $2

hex=`cat ${1} | sed -n -e 's/.*0x\([a-fA-F0-9]*\),.*/0: \1/p'`

echo $hex

for value in $hex; do
# swap the hex value, keeping the initial 3 chars the same
  echo ${value:0:3}${value:9:2}${value:7:2}${value:5:2}${value:3:2} | xxd -r -p >> ${2}
done
unset IFS

