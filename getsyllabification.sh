#!/bin/bash

# help
display_help() {
    echo "Usage: $0 [option...] " >&2
    echo
    echo "   -h, --help                 Display this help message"
    echo "   -d, --dictionary           Specify dictionary to get syllabification. The available options are: 'ws' (for wordsmyth). The following are not working anymore: 'dc' (for dictionary.com) and 'mw' (for merriam-webster)"
    echo "   -i, --input-file           Specify input file with list of words (one word per line)"
    echo
    exit 1
}

DIC='ws' #default
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
    -d|--dictionary)
    shift
    DIC="$1"
    ;;
    -i|--input-file)
    shift
    INFILE="$1"
    ;;
    -h | --help)
    display_help  # Call your function
    exit 0
    ;;
    *)
    esac
    # Shift after checking all the cases to get the next option
    shift
done

while read line
do
  SYLLABLES=""
  case "$DIC" in  
     dc) SYLLABLES="$(curl -k -s https://www.dictionary.com/browse/$line | grep -o '<span class="pron-spell-content.*]<\/span>' | sed -e 's/<[^>]*>//g' | sed 's/[][\ ]//g')"
     ;;
     mw) SYLLABLES="$(curl -s https://www.merriam-webster.com/dictionary/$line | grep '<span\ class="word-syllables">' | uniq | sed -e 's/[[:space:]]\+<span class="word-syllables">\(.*\)<\/span>/\1/' | sed -e 's/·&#8203;/-/g')"
     ;;
     ws) SYLLABLES="$(curl -k -s https://www.wordsmyth.net/?ent=$line | grep '<h3\ class="headword syl">' | uniq | sed -e 's/<td class="default"><h3 class="headword syl">\(.*\)<\/h3>/\1/' | sed -e 's/&#xB7;/-/g')"
     ;;
     *) echo "Dictionary not found."
	exit 0
     ;;
    esac 
  if [ -z "$SYLLABLES" ]
  then
     echo $line
  else
     echo $SYLLABLES
  fi
done < "${INFILE:-/dev/stdin}"

