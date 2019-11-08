## wordfreq.awk 
Compute word frequency. (code from: Arnold Robbins, Effective awk Programming)

### script usage 

~~~ bash
$ awk -f wordfreq.awk < input_file
~~~

### usage examples
The examples bellow will count the occurrences of words in ulysses.txt:

~~~ bash
$ cat ulysses.txt | awk -f wordfreq.awk | head
the     8031
and     5896
i       4711
to      4540
of      3738
a       2958
in      2554
he      2541
that    2454
it      2138
~~~

[back](./)

