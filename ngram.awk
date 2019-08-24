# ngram.awk --- extract n-grams from file 
#               (characters are considered the default symbols)

# Options:
#
# -w words n-grams   
# -n [num] create n-grams of n symbols (default num=2)
# -s [mode] sort - modes: 0 no sort at all, [] (empty or 1 or f) by frequency (default), 2 (or a) alphabetical
# -c case sensitive (default is case insensitive)
#
# example: $ cat /tmp/ulysses.txt | tr -c 'a-zA-Z' ' ' | awk -f ngram.awk -- -n 2 -s a | head
#          $ awk -f ngram.awk -- -w -n 2 -s a /tmp/ulysses.txt | head
@include "getopt.awk"

function usage()
{
  print("Usage: ngram [-wc [-s MOD] [-n NUM]] [file] ") > "/dev/stderr"
  exit 1
}

BEGIN {
  _nglen  = 2 # ngram length
  _ngmode = "chars" # ngram mode
  _SS = ""
  _sortA = 0
  _caseinsen = 1
  outputfile = "/dev/stdout"
  while ((c = getopt(ARGC, ARGV, "wn:s:c")) != -1) {
    if (c == "w") {
       _ngmode = "words"
       _SS = " "
    }
    else if (c == "n")
       _nglen = Optarg
    else if (c == "s") {
       if (Optarg == "" || Optarg == "1" || Optarg == "f") _sortA = 1 # frequency
       else if (Optarg == "2" || Optarg == "a") _sortA = 2 # alphabetical
       else if (Optarg == "0") _sortA = 0 # no sort
       else usage()
       }
    else if (c == "c")
       _caseinsen = 0
    else
       usage()    
  }

  if (ARGV[Optind] ~ /^[[:digit:]]+$/)
    _nglen = ARGV[Optind++] + 0

  for (i = 1; i < Optind; i++)
    ARGV[i] = ""
}

{
  if (_caseinsen)
    $0=tolower($0)
  if (_ngmode == "chars") {
    gsub(/[^[:alnum:]_ ]/, "", $0)
    split($0,symbols,"")
  }
  else {
    gsub(/[^[:alnum:]_[:blank:]]/, " ", $0)
    split($0,symbols," ")
  }
  for (i in symbols){
    ngram=""
    for (ind=0;ind<_nglen;ind++){
	if (symbols[i+ind] ~ /[^[:blank:]]/)
            ngram = ngram _SS symbols[i+ind]
    }
    _len_ngram = split(ngram,_tmp,_SS)
    if(_len_ngram == _nglen){
        counter+=1
        freq_tabel[ngram]+=1
    }
  }
}

END {
  if (_sortA == 2)
    sort = "sort -k 2"
  else if (_sortA == 1)
    sort = "sort -k 1nr"
  else
    sort = ""
  if (length(sort) != 0) {
    for (ngram in freq_tabel)
      printf "%7i %s\n", freq_tabel[ngram], ngram | sort
    close(sort)
  }
  else
    for (ngram in freq_tabel)
      printf "%7i %s\n", freq_tabel[ngram], ngram
}
