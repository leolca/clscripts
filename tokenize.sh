#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h                 Display this help message"
    echo "   -s			Specify the token separator in output (new line is the default)"
    echo "   -n		        Do not break on hyphens"
    echo "   -a		  	Do not break on apostrophes"
    echo "   -o			Specify output file name"
    echo "   -i			Specify input file name"
    echo
    exit 1
}


SEP="\n"
INPUTFILE="/dev/stdin"
OUTPUTFILE="/dev/stdout"
NOHYPHEN=0
NOAPOS=0
# As long as there is at least one more argument, keep looping
while getopts "hnas:o:i:" OPTION
do
    case $OPTION in
        s)
        SEP="$OPTARG"
        ;;
	n)
	NOHYPHEN=1
	;;
	a)
	NOAPOS=1
	;;
        o)
        OUTPUTFILE="$OPTARG"
        ;;
        i)
        INPUTFILE="$OPTARG"
        ;;
	h)
        display_help  # Call your function
        exit 0
        ;;
    esac
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

echo $NOHYPHEN
echo $NOAPOS
if [[ "$NOHYPHEN" == 1 ]] && [[ "$NOAPOS" == 1 ]]; then
  cmd="awk '{gsub(/[^[:alpha:][:blank:]\'\''-]/,\" \"); print tolower(\$0)}'"
elif [[ "$NOHYPHEN" == 1 ]]; then
  cmd="awk '{gsub(/[^[:alpha:][:blank:]-]/,\" \"); print tolower(\$0)}'"
elif [[ "$NOAPOS" == 1 ]]; then
  cmd="awk '{gsub(/[^[:alpha:][:blank:]\'\'']/,\" \"); print tolower(\$0)}'"
else
  cmd="awk '{gsub(/[^[:alpha:][:blank:]]/,\" \"); print tolower(\$0)}'"
fi

(eval $cmd | tr -d '\r' | tr ' ' '\n' | tr -s ' \n' | tr '\n' "$SEP") < "$INPUTFILE" > "$OUTPUTFILE"
