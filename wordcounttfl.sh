#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h, --help                 Display this help message"
    echo "   -c, --counts               Show only counts"
    echo "   -w  --words 		Words only"
    echo "   -o, --output-file          Specify output file name"
    echo "   -i, --input-file           Specify input file name"
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}


# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # This is a flag type option. Will catch either -c or --counts
        -c|--counts)
        COUNTSONLY=1
        ;;
        # This is a flag type option. Will catch either -w or --words
        -w|--words)
        WORDSONLY=1
        ;;
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

if [ -z "$COUNTSONLY" ] && [ -z "$WORDSONLY" ] ; then
   echo -e "f\ttype" > "${OUTPUTFILE:-/dev/stdout}"
fi

cat < "${INPUTFILE:-/dev/stdin}" | 
    ./tokenize.sh | 
    awk '{print tolower($0)}' | 
    tr " " "\n" | 
    sort | 
    uniq -c | 
    sort -k1,1nr -k2 | 
    ( ([ "$COUNTSONLY" ] && [ ! "$WORDSONLY" ]) && awk '{print $1}' || cat ) | 
    ( ([ ! "$COUNTSONLY" ] && [ "$WORDSONLY" ]) && awk '{print $2}' || cat ) |
    ( ([ ! "$COUNTSONLY" ] && [ ! "$WORDSONLY" ]) && awk -OFS='\t' '{print $1,$2}' || cat ) >> "${OUTPUTFILE:-/dev/stdout}" 

