#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h, --help                 Display this help message"
    echo "   -o, --output-file          Specify output file name"
    echo "   -i, --input-file           Specify input file name"
    echo "   -b, --byte			Use byte count to get a word position"
    echo "   -w, --word			Word to search for"
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}

BYTECOUNT=FALSE
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
	# This is an arg value type option. Will catch -b or --byte 
	-b|--byte)
	shift # past argument
	BYTECOUNT=TRUE
	;;
	# This is an arg value type option. Will catch -b value or --word value
	-w|--word)
	shift
	WORD="$1"
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

if [[ "$BYTECOUNT" == "FALSE" && -z "$INPUTFILE" ]]; then
   echo "You must provide an input file to get word based position."
   exit 1
fi

if [ -z "$OUTPUTFILE" ]; then
  OUTPUTFILE='/dev/stdout'
fi

if [ "$INPUTFILE" ]; then
   cat "$INPUTFILE"
else
   cat
fi | grep -b -o "\b$WORD\b" | while read line
	do
	   x=$(echo $line | tr -dc '0-9') # byte position
	   if [[ "$BYTECOUNT" == "TRUE" ]]; then
	      printf '%d\n' "$x" >> $OUTPUTFILE
	   else
	      w=$(head -c $x $INPUTFILE | wc -w) # word position
	      printf '%d\n' "$w" >> $OUTPUTFILE
           fi
	done 
