#!/bin/bash

# sliding window new word density
# usage example
# ./swnwdensity.sh alice.txt 100
# FILENAME='alice.txt'; WLEN=500; WTOTAL=$(wc -w "$FILENAME" | awk '{print $1}'); MAXLEN=$((WTOTAL - WLEN)); XMAX=$(echo 2*$MAXLEN/$WLEN-1 | bc); ./swnwdensity.sh $FILENAME $WLEN | gnuplot -e "set terminal png; set output 'swnewworddensity.png'; set xlabel 'text window'; set ylabel 'new word density'; set xrange[0:$XMAX]; set title 'sliding window new word density in file $FILENAME using window of length $WLEN'; set key right top; plot '/dev/stdin' with lines title 'alice'"; display swnewworddensity.png 

THEFILENAME=$1
WINDOWLENGTH=$2
FILELENGTH=$(wc -w "$THEFILENAME" | awk '{print $1}')
INCREMENT=$(echo $WINDOWLENGTH/2 | bc)

cat $THEFILENAME | tr ' ' '\n' > /tmp/tmpfile
for i in `seq $WINDOWLENGTH $INCREMENT $FILELENGTH`;
do
    cat /tmp/tmpfile | head -n $i | tail -n $WINDOWLENGTH | ./simons.py --newratio
done
rm /tmp/tmpfile
