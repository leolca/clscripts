## wordcounttfl.sh 
Count the occurrence of words in a text file (or from stdin) and output a list of frequency and types (words) compatible with zipfR frequency spectrum file.

### usage examples
The examples bellow will count the occurrences of words in ulysses.txt and output the result to the standard output:
~~~ bash
$ ./wordcounttfl.sh ulysses.txt 
$ ./wordcounttfl.sh -i ulysses.txt
$ ./wordcounttfl.sh --input-file ulysses.txt
$ cat ulysses.txt | ./wordcounttfl.sh 
~~~ 
Any of them will give the same result:
~~~ txt
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
~~~

If you want to save the result in a file, you may simply redirect it to the desired file:
~~~ bash
$ ./wordcounttfl.sh ulysses.txt > ulysses.tfl
~~~ 
or you may specify it as an argument to the script:
~~~ bash
$ ./wordcounttfl.sh -i ulysses.txt -o ulysses.tfl
$ ./wordcounttfl.sh --input-file ulysses.txt --output-file ulysses.tfl
~~~ 

It is possible to output only the count values as exemplified bellow:
~~~ bash
$ ./wordcounttfl.sh -i ulysses.txt -c -o ulysses.cnt
$ ./wordcounttfl.sh ---input-file ulysses.txt --output-file ulysses.cnt --counts
~~~ 

Using the frequency spectrum file with zipfR:
~~~ R
> library(zipfR)
> ulysses = read.tfl('ulysses.tfl')
> summary(ulysses)
zipfR object for frequency spectrum
Sample size:     N  = 264625 
Vocabulary size: V  = 29743 
Range of freq's: f  = 1 ... 14952 
Mean / median:   mu = 8.897051 ,  M = 1 
Hapaxes etc.:    V1 = 16199 ,  V2 = 4788 
Types:    a aaron aback abaft abandon ...
> png('ulysses_f.png')
> plot(ulysses, log="xy")
> dev.off()
~~~ 
![ulysses frequency spectrum](../images/ulysses_f.png)


You may also get the frequency counts for multiple files in parallel using GNU Parallel as shown below:
~~~ bash
$ ls *.txt | parallel 'cat {} | ./wordcounttfl.sh > {.}.flt'
~~~ 

[back](./)
