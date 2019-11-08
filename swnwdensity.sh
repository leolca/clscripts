#!/bin/bash

# sliding window new word density
# usage example
# ./swnwdensity.sh alice.txt 100
# FILENAME='alice.txt'; WLEN=500; WTOTAL=$(wc -w "$FILENAME" | awk '{print $1}'); MAXLEN=$((WTOTAL - WLEN)); XMAX=$(echo 2*$MAXLEN/$WLEN-1 | bc); ./swnwdensity.sh $FILENAME $WLEN | gnuplot -e "set terminal png; set output 'swnewworddensity.png'; set xlabel 'text window'; set ylabel 'new word density'; set xrange[0:$XMAX]; set title 'sliding window new word density in file $FILENAME using window of length $WLEN'; set key right top; plot '/dev/stdin' with lines title 'alice'"; display swnewworddensity.png 

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h, --help                 Display this help message"
    echo "   -i, --input-file           Specify input file name"
    echo "   -l, --window-length        Window length (number of words)"
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}

WINDOWLENGTH=100 # default value
# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # This is an arg value type option. Will catch -i value or --input-file value
        -i|--input-file)
        shift # past the key and to the value
        INPUTFILE="$1"
        ;;
	# This is an arg value type option. Will catch -l value or --window-length value
        -l|--window-length)
        shift
        WINDOWLENGTH="$1"
        ;;
        # display help
        -h | --help)
        display_help  # Call your function
        exit 0
        ;;
        *)
        # Do whatever you want with extra options
        echo "Unknown option '$key'"
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

FILELENGTH=$(wc -w "$INPUTFILE" | awk '{print $1}')
INCREMENT=$(echo $WINDOWLENGTH/2 | bc)

cat $INPUTFILE | tr ' ' '\n' > /tmp/tmpfile
for i in `seq $WINDOWLENGTH $INCREMENT $FILELENGTH`;
do
    cat /tmp/tmpfile | head -n $i | tail -n $WINDOWLENGTH | ./simons.py --newratio
done
rm /tmp/tmpfile
