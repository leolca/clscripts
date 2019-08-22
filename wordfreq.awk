# wordfreq.awk --- print list of word frequencies
#   from: Arnold Robbins, Effective awk Programming

{
  # remove case distinctions
  $0 = tolower($0)
  # remove punctuation
  gsub(/[^[:alnum:]_[:blank:]]/, "", $0)
  for (i = 1; i <= NF; i++)
  freq[$i]++
}
END {
  sort = "sort -k 2nr"
  for (word in freq)
    printf "%s\t%d\n", word, freq[word] | sort
  close(sort)
}
