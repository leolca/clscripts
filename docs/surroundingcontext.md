## surroundingcontext.sh 
Show text surrounding context for a given word.

### script usage 
Use the script's help to see the syntax and available parameters.

~~~ bash
$ ./surroundingcontext.sh -h
Usage: ./surroundingcontext.sh [option...] 

   -h, --help                 Display this help message
   -o, --output-file          Specify output file name
   -i, --input-file           Specify input file name
   -w, --word	              Specity the desired word to grep
   -n, --number-of-words      The number of words in surrounding context to retrieve
~~

### usage examples
We present bellow the context of the word **clock** in *Alice's Adventures in Wonderland*:

~~~ bash
$ ./surroundingcontext.sh -i alice.txt -w clock -n 3
doesn’t tell what o’clock it is
liked with the clock
it were nine o’clock in the morning
round goes the clock in a twinkling
it’s always six o’clock now
~~~ 

Running in your computer you will see the matched word colored.


[back](./)

