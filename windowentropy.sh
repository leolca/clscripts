#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h, --help                 Display this help message"
    echo "   -i, --input-file           Specify input file name"
    echo "   -n, --num-windows          Specify the number of windows desired"
    echo "   -s, --scale-windows        Specify whether windows length are linearly (linear) or logarithmically (log) scaled"
    echo "   -c, --cum-window           Specify whether to use sliding windows or cumulative windows"
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
	-n|--num-windows) 
	shift 
	NUMWINDOWS=$1 
	;;
	-s|--scale-windows) 
	shift 
	WINDOWSCALE=$1 
	;;
	-c|--cum-window) 
	shift 
	WINDOWSCHEME=$1 
	;;
	-t|--token) 
	shift 
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
        echo "Error using option $1!" 
	print_usage
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done


# ./windowindex.py -i data/alice.txt --token lines --nwin 10 --wscale log --wtype sliding
# ./getwindow.sh --input-file /tmp/teste.txt --start 5 --stop 10 --token word

regex="([0-9]+)[[:blank:]]+([0-9]+)"
./windowindex.py -i $INPUTFILE --token $TOKEN --nwin $NUMWINDOWS --wscale $WINDOWSCALE --wtype $WINDOWSCHEME |
while IFS= read -r line; do
  if [[ $line =~ $regex ]]
  then
    value1=${BASH_REMATCH[1]}
    value2=${BASH_REMATCH[2]}
  fi
  echo -en "$value1\t$value2\t"
  ./getwindow.sh -i $INPUTFILE -s $value1 -p $value2 -t $TOKEN | ./wordcounttfl.sh -c | ./entropy.py
done

