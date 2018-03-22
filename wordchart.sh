#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h, --help                 Display this help message"
    echo "   -o, --output-file          Specify output file name"
    echo "   -i, --input-file           Specify input file name"
    echo "   -w, --word			Word to search for"
    echo "   -c, --ignore-case          Ignore case"
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}

BYTECOUNT=FALSE
IGNORECASE=FALSE
# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # This is an arg value type option. Will catch -o value or --output-file value
        -o|--output-file)
        shift # past the key and to the value
        OUTPUTFILE="$1"
        ;;
        # This is an arg value type option. Will catch -i value or --input-file value
        -i|--input-file)
        shift # past the key and to the value
        INPUTFILE="$1"
        ;;
	# This is an arg value type option. Will catch -b value or --word value
	-w|--word)
	shift
	WORD="$1"
	;;
        # catch -c or --ignore-case
        -c|--ignore-case)
        shift # past argument
        IGNORECASE=TRUE
        ;;
	# display help
	-h | --help)
        display_help  # Call your function
        exit 0
        ;;
        *)
        # Do whatever you want with extra options
        #echo "Unknown option '$key'"
	INPUTFILE="$1"
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

if [ ! -z "$OUTPUTFILE" ]; then
  if [ -f "$OUTPUTFILE" ]; then
     read -p "File exist! Are you sure [y,n]? " -n 1 -r
     echo
     if [[ $REPLY =~ ^[Yy]$ ]];
     then
       rm $OUTPUTFILE
     else
       exit
     fi
  fi
fi 

if [ -z "$INPUTFILE" ]; then
  echo "You must provide an input text file."
  exit 1
fi

WTOTAL=$(wc -w "$INPUTFILE" | awk '{print $1}')

if [ -z "$OUTPUTFILE" ]; then
   if [[ "$IGNORECASE" == "TRUE" ]]; then
      WORD=$(echo "$WORD" | awk '{print tolower($0)}')
      ./wordposition.sh -i $INPUTFILE -w $WORD -c | gnuplot -p -e "set terminal wxt size 800,200; set size ratio 0.125; set yrange[10:20]; set xrange[0:$WTOTAL]; unset ytics; set title 'wordchart: $INPUTFILE'; plot '-' u 1:(10):(0):(20) with vectors nohead title '$WORD'"
   else
      ./wordposition.sh -i $INPUTFILE -w $WORD | gnuplot -p -e "set terminal wxt size 800,200; set size ratio 0.125; set yrange[10:20]; set xrange[0:$WTOTAL]; unset ytics; set title 'wordchart: $INPUTFILE'; plot '-' u 1:(10):(0):(20) with vectors nohead title '$WORD'"
   fi
else
   if [[ "$IGNORECASE" == "TRUE" ]]; then
      WORD=$(echo "$WORD" | awk '{print tolower($0)}')
      ./wordposition.sh -i $INPUTFILE -w $WORD -c | gnuplot -p -e "outputfilename='$OUTPUTFILE'; textlength=$WTOTAL; inputfilename='$INPUTFILE'; txtword='$WORD';" wordchart.gp
   else
      ./wordposition.sh -i $INPUTFILE -w $WORD | gnuplot -p -e "outputfilename='$OUTPUTFILE'; textlength=$WTOTAL; inputfilename='$INPUTFILE'; txtword='$WORD';" wordchart.gp
   fi
fi

