# clscripts
Repository for computational linguistics scripts (bash, python, octave, etc).

## wordcounttfl.sh
Count the occurrence of words in a text file and output a list of frequency and types (words) complatible with zipfR frequency spectrum file.
usage example: ./wordcounttfl.sh Ulysses.txt
  f     type
  14952 the
  8141  of
  7217  and
  6521  a
  4963  to
  4946  in
  4032  he
  3333  his
  2708  i
    ...

## heapslaw.py
Extract vocabulary size from different lengths of a text file, suitable to check Heaps' (or Heardan's) law.
