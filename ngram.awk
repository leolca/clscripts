# ngram.awk --- extract n-grams from file

# Options:
#
# -w words n-grams   (default)
# -c characters n-grams
# -n create n-grams of n symbols (default n=2)
#
@include "getopt.awk"

function usage()
{
  print("Usage: ngram -w -c -n NUM ") > "/dev/stderr"
  exit 1
}

BEGIN {
  _nglen  = 2 # ngram length
  _ngmode = "chars" # ngram mode
  _SS = ""
  outputfile = "/dev/stdout"
  while ((c = getopt(ARGC, ARGV, "wcn:")) != -1) {
    if (c == "w") {
       _ngmode = "words"
       _SS = " "
    }
    else if (c == "c") {
       _ngmode = "chars"
       _SS = ""
    }
    else if (c == "n")
       _nglen = Optarg
    else
       usage()    
  }

  if (ARGV[Optind] ~ /^[[:digit:]]+$/)
    _nglen = ARGV[Optind++] + 0

  for (i = 1; i < Optind; i++)
    ARGV[i] = ""
}

{
  $0=tolower($0)
  if (_ngmode == "chars") {
    gsub(/[^[:alnum:]_]/, "", $0)
    split($0,symbols,"")
  }
  else {
    gsub(/[^[:alnum:]_[:blank:]]/, " ", $0)
    split($0,symbols," ")
  }
  begin_len=0 
  for (i in symbols){
    ngram=""
    for (ind=0;ind<_nglen;ind++){
        ngram = ngram _SS symbols[i+ind]
    }
    _len_ngram = split(ngram,_tmp,_SS)
    if(begin_len == 0){ 
        begin_len=_len_ngram
    }
    if(_len_ngram == begin_len){ 
        counter+=1
        freq_tabel[ngram]+=1
    }
  }
}

END {
  sort = "sort -k 1nr"
  for (ngram in freq_tabel)
    printf "%7i %s\n", freq_tabel[ngram], ngram	| sort
  close(sort)
}
