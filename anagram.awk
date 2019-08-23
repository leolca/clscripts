# anagram.awk --- An implementation of the anagram-finding algorithm.
#                 Implementation done by Arnold Robbins (in Effective awk Programming)
#                 on the algorithm  from Jon Bentley's 'Programming Pearls'.

# usage example:
# $ awk -f anagram.awk /usr/share/dict/words | grep '^b'

/'s$/ { next } # Skip possessives

function word2key(word,     a, i, n, result)
{
  n = split(word, a, "")
  asort(a)
  for (i = 1; i <= n; i++)
    result = result a[i]
  return result
}

{
  key = word2key($1) # Build signature
  data[key][$1] = $1 # Store word with signature
}

END {
  sort = "sort"
  for (key in data) {
    # Sort words with same key
    nwords = asorti(data[key], words)
    if (nwords == 1)
      continue
    # And print. Minor glitch: trailing space at end of each line
    for (j = 1; j <= nwords; j++)
      printf("%s ", words[j]) | sort
    print "" | sort
  }
  close(sort)
}


