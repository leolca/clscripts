# clscripts
Repository for computational linguistics scripts (bash, python, octave, etc).


# Table of Contents
1. [wordcounttfl.sh](#wordcounttfl)
2. [entropy.py](#pyentropy)
3. [heapslaw.py](#heapslaw)

## wordcounttfl.sh <a name="wordcounttfl"></a>
Count the occurrence of words in a text file (or from stdin) and output a list of frequency and types (words) complatible with zipfR frequency spectrum file.

### usage examples
The examples bellow will count the ocurrences of words in ulysses.txt and output the result to the standard output:
```
$./wordcounttfl.sh ulysses.txt 
$./wordcounttfl.sh -i ulysses.txt
$./wordcounttfl.sh --input-file ulysses.txt
$cat ulysses.txt | ./wordcounttfl.sh 
```
Any of them will give the same result:
```
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
```

If you want to save the result in a file, you may simply redirect it to the desired file:
```
$./wordcounttfl.sh ulysses.txt > ulysses.tfl
```
or you may specify it as an argument to the script:
```
$./wordcounttfl.sh -i ulysses.txt -o ulysses.tfl
$./wordcounttfl.sh --input-file ulysses.txt --output-file ulysses.tfl
```

It is possible to output only the count values as exemplified bellow:
```
./wordcounttfl.sh -i ulysses.txt -c -o ulysses.cnt
./wordcounttfl.sh ---input-file ulysses.txt --output-file ulysses.cnt --counts
```

## entropy.py <a name="pyentropy"></a>

## heapslaw.py <a name="heapslaw"></a>
Extract vocabulary size from different lengths of a text file, suitable to check Heaps' (or Heardan's) law.
