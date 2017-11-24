#!/bin/bash
echo -e "f\ttype" 
tr "A-Z" "a-z" < $1 | tr -sc "A-Za-z\'" "\n" | sort | uniq -c | sort -n -r | sed 's/[[:space:]]*\([0-9]*\) \([a-z]*\)/\1\t\2/'
