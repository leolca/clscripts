## tokenize.sh
Simple script to tokenize a text file. You may consider tokens as 
strings composed only of alpha characters or you may also consider
hyphens and apostrophes as part of tokens.
You may also print one sentence per line and define an output token separator.

## script usage
Help shows the usage syntax and available parameters.

~~~ bash
$ ./tokenize.sh -h
Usage: ./tokenize.sh [option...] 

   -h                 Display this help message
   -s			Specify the token separator in output (blank space is the default)
   -n		        Do not break on hyphens
   -a		  	Do not break on apostrophes
   -l			One sentence per line
   -o			Specify output file name
   -i			Specify input file name
~~~

### usage examples

~~~ bash
$ wget http://www.gutenberg.org/files/29090/29090-0.txt -O /tmp/29090-0.txt
$ head -n 27430 /tmp/29090-0.txt | tail -n 20 | ./tokenize.sh -l -a -n -s "|"
THE|SUICIDE'S|ARGUMENT
Ere|the|birth|of|my|life|if|I|wished|it|or|no
No|question|was|asked|meit|could|not|be|so
If|the|life|was|the|question|a|thing|sent|to|try
And|to|live|on|be|Yes|what|can|No|be
to|die
NATURE'S|ANSWER
Is't|returned|as|'twas|sent
Is't|no|worse|for|the|wear
Think|first|what|you|are
Call|to|mind|what|you|were
I|gave|you|innocence|I|gave|you|hope
Gave|health|and|genius|and|an|ample|scope
Return|you|me|guilt|lethargy|despair
Make|out|the|invent'ry|inspect|compare
Then|dieif|die|you|dare
~~~


[back](./)

