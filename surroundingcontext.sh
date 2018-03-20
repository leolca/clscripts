#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h, --help                 Display this help message"
    echo "   -o, --output-file          Specify output file name"
    echo "   -i, --input-file           Specify input file name"
    echo "   -w, --word			Specity the desired word to grep"
    echo "   -n, --number-of-words      The number of words in surrounding context to retrieve"
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
        OUTPUTFILE="$1"
        ;;
        # This is an arg value type option. Will catch -i value or --input-file value
        -i|--input-file)
        shift # past the key and to the value
        INPUTFILE="$1"
        ;;
	# This is an arg value type option. Will catch -w or --word value
	-w|--word)
	shift # past the key and to the value
	WORD="$1"
	;;
	# This is an arg value type option. Will catch -n or --number-of-words value
	-n|--number-of-words)
	shift # past the key and to the value
	NWORDS="$1"
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

if [ -z "$OUTPUTFILE" ]; then
  if [ "$INPUTFILE" ]; then 
     cat "$INPUTFILE"
  else 
     cat
  fi | awk '{gsub(/[^[:alpha:][:blank:]]/,""); print tolower($0)}' | tr -d '\r' | tr -s ' \n' | grep -oE "((\w+\s*){0,$NWORDS})\s*\b$WORD\b\s*((\w+\s*){0,$NWORDS})"
else
  if [ "$INPUTFILE" ]; then
     cat "$INPUTFILE"
  else
     cat
  fi | awk '{gsub(/[^[:alpha:][:blank:]]/,""); print tolower($0)}' | tr -d '\r' | tr -s ' \n' | grep -oE "((\w+\s*){0,$NWORDS})\s*\b$WORD\b\s*((\w+\s*){0,$NWORDS})" >> $OUTPUTFILE
fi
