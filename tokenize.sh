#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h                 Display this help message"
    echo "   -s			Specify the token separator in output (blank space is the default)"
    echo "   -n		        Do not break on hyphens"
    echo "   -a		  	Do not break on apostrophes"
    echo "   -l			One sentence per line"
    echo "   -o			Specify output file name"
    echo "   -i			Specify input file name"
    echo
    exit 1
}


SEP=" "
INPUTFILE="/dev/stdin"
OUTPUTFILE="/dev/stdout"
NOHYPHEN=0
NOAPOS=0
ONESPL=0
# As long as there is at least one more argument, keep looping
while getopts "hnals:o:i:" OPTION
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
	l)
	ONESPL=1
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

if [[ "$ONESPL" == 1 ]]; then
  cmd1="awk '{gsub(/[!\.?]\s*/,\"\n\"); print \$0}'"
else
  cmd1="cat"
fi

if [[ "$NOHYPHEN" == 1 ]] && [[ "$NOAPOS" == 1 ]]; then
  cmd2="awk '{gsub(/-{2,}/,\"\"); print \$0}' | tr -s '\n ' | awk '{gsub(/[^[:alpha:]\'\''-]/,\""$SEP"\"); print \$0}'"
elif [[ "$NOHYPHEN" == 1 ]]; then
  cmd2="awk '{gsub(/-{2,}/,\"\"); print \$0}' | tr -s '\n ' | awk '{gsub(/[^[:alpha:]-]/,\""$SEP"\"); print \$0}'"
elif [[ "$NOAPOS" == 1 ]]; then
  cmd2="awk '{gsub(/-{2,}/,\"\"); print \$0}' | tr -s '\n ' | awk '{gsub(/[^[:alpha:]\'\'']/,\""$SEP"\"); print \$0}'"
else
  cmd2="awk '{gsub(/-{2,}/,\"\"); print \$0}' | tr -s '\n ' | awk '{gsub(/[^[:alpha:]]/,\""$SEP"\"); print \$0}'"
fi

(tr -d '\r' | sed '/^$/d' | awk '{$1=$1};1' | eval $cmd1 | eval $cmd2 | tr -s "$SEP" | sed "s/$SEP\+\$//" | sed "s/^$SEP\+//" | sed '/^$/d') < "$INPUTFILE" > "$OUTPUTFILE"
