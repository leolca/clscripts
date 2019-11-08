## ngram
Two implementations are available: in C and in awk. Both may compute ngrams of chars or words.

### ngram.c
ngram implemented in C

### script usage 
See script help.

~~~ bash
$ ./ngram --help
Usage: ngram [OPTIONS]... [FILE]...
Output the n-grams from a given FILE to standard output,
printing each ngram in a different line.
Whitespace is considered a delimiter, n-grams are not allowed to countain any.

With no FILE, or when FILE is -, read standard input.
  -n, --length <n>     set n-gram length (n)
  -w, --word           word n-grams mode
  -b, --no-boundary    remove whitespace boundary restriction
  -i, --input          input filename (if not provided, read from stdin)
  -h, --help           display this help and exit

Examples:
  ngram -n 3 file   Output tri-grams in file.

~~~

### usage examples

Example using Ulysses.
~~~ bash
$ head -n 2 ulysses.txt | ./ngram -n 5
Proje
rojec
oject
Guten
utenb
tenbe
enber
nberg
EBook
Ulyss
lysse
ysses
sses,
James
Joyce
~~~

### ngram.awk
Compute ngrams (chars or words) frequency. 

### script usage 

~~~ bash
Usage: ngram [-wc [-s MOD] [-n NUM]] [file] 
~~~

### usage examples
The examples bellow will count the 2-grams made of characters from ulysses.txt:
~~~ bash
$ cat ulysses.txt | awk -f ngram.awk -- -c -n 2 | head
  21176 th
  19368 he
  11799 in
  11704 an
  10803 er
   9264 nd
   8904 ha
   8536 re
   7841 to
   7674 ou
~~~

[back](./)

