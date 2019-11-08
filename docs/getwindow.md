## getwindow.sh
Extract stretch of text from a file given the window start and end location. 

### script usage 
Consult the script help to see the list of available parameters.

~~~ bash
$ ./getwindow.sh -h
Usage: ./getwindow.sh [option...] 

   -h, --help                 Display this help message
   -i, --input-file           Specify input file name
   -s, --start                Specity the start position
   -p, --stop                 Specify the end position
   -t, --token                Specify token (char, word, line)
~~~

### usage examples
A simple usage example is presented below.

~~~ bash
$ ./getwindow.sh --input-file alice.txt --start 124 --stop 131 --token word | tr '\n' ' ' && echo "" 
when suddenly a White Rabbit with pink eyes 
~~~

[back](./)

