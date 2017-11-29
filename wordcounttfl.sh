#!/bin/bash
# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # This is a flag type option. Will catch either -f or --foo
        -c|--counts)
        COUNTSONLY=1
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
        *)
        # Do whatever you want with extra options
        #echo "Unknown option '$key'"
	INPUTFILE="$1"
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

if [ -z "$COUNTSONLY" ]; then
   if [ -z "$OUTPUTFILE" ]; then
      echo -e "f\ttype" 
   else
      echo -e "f\ttype" > $OUTPUTFILE
   fi
fi


if [ -z "$OUTPUTFILE" ]; then
  if [ "$INPUTFILE" ]; then 
     cat "$INPUTFILE"
  else 
     cat
  fi | tr "A-Z" "a-z" | tr -sc "A-Za-z\'" "\n" | sed -e "s/'$//" | sed -e "s/^'//" | sort | uniq -c | sort -n -r | sed 's/[[:space:]]*\([0-9]*\) \([a-z]*\)/\1\t\2/' 
else
  if [ "$INPUTFILE" ]; then
     cat "$INPUTFILE"
  else
     cat
  fi | tr "A-Z" "a-z" | tr -sc "A-Za-z\'" "\n" | sed -e "s/'$//" | sed -e "s/^'//" | sort | uniq -c | sort -n -r | sed 's/[[:space:]]*\([0-9]*\) \([a-z]*\)/\1\t\2/' >> $OUTPUTFILE
fi
