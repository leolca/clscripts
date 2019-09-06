#!/bin/bash

while read line
do
  for word in $line; do
    echo -n $word | sed 's/./&\n/g' | sort | uniq -c | tr -d '\n  '
    echo
  done
done < "${1:-/dev/stdin}"

