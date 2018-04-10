#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h, --help                 Display this help message"
    echo "   -i, --input-file           Specify input file name"
    echo "   -s, --start                Specity the start position"
    echo "   -p, --stop                 Specify the end position"
    echo "   -t, --token                Specify token (char, word, line)"
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}

# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # This is an arg value type option. Will catch -o value or --output-file value
        -o|--output-file)
        shift # past the key and to the value
        OUTPUTFILE=$1
        ;;
        # This is an arg value type option. Will catch -i value or --input-file value
        -i|--input-file)
        shift # past the key and to the value
        INPUTFILE=$1
        ;;
	# catch -s or --start
	-s|--start)
	shift # past the key and to the value
	START=$1
	;;
	# catch -p or --stop
	-p|--stop)
	shift # past the key and to the value
        STOP=$1
        ;;
	# catch -t or --token
        -t|--token)
        shift # past the key and to the value
        TOKEN=$1
        ;;
        # display help
        -h | --help)
        display_help  # Call your function
        exit 0
        ;;
        *)
        # Do whatever you want with extra options
        #echo "Unknown option '$key'"
        INPUTFILE=$1
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

if [[ $STOP -lt $START ]]; then
   exit 1
fi

STOP=$((STOP + 1))
START=$(($STOP - $START))
# cat $INPUTFILE | head -n $STOP | tail -n $START

case $TOKEN in
	"char") cat $INPUTFILE | tr -s " " | fold -w1 ;;
	"word") cat $INPUTFILE | tr -s " " | tr " " "\n" ;;
	"line") cat $INPUTFILE ;;
	*) echo "ERRO";;
esac | head -n $STOP | tail -n $START

