#!/bin/bash
echo -e "f\ttype" 
if [ "$1" ]; then 
   cat "$1"
else 
   cat
fi | tr "A-Z" "a-z" | tr -sc "A-Za-z\'" "\n" | sed -e "s/'$//" | sed -e "s/^'//" | sort | uniq -c | sort -n -r | sed 's/[[:space:]]*\([0-9]*\) \([a-z]*\)/\1\t\2/'
