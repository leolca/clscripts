## entropy.py <a name="pyentropy"></a>
Compute an estimate for the Shannon entropy given a vector of counts 
read from in a input file or from the stdin. 
As default, the entropy is calculated in bits, 
but you might specify the desired base as well. 
The entropy might be estimated using the following approaches: 
- maximum likelihood estimate (using the plug-in formula, used as the default approach), 
- jackknife resampling technique, or 
- Miller-Madow correction to the plug-in estimate. 
For each of them you must provide a string with the method name: 
'mle' or 'plugin', jk' or 'jackknife' and 'mm' or 'millermadow', respectively.

### script usage 
You may type help to see the script usage and the possible parameters available.
~~~ bash
$ ./entropy.py --help
usage: entropy.py [-h] [--base BASE] [-i FILE]
                  [--method {mle,plugin,jk,jackknife,mm,millermadow}]

optional arguments:
  -h, --help            show this help message and exit
  --base BASE           Entropy base (default = 2, bits).
  -i FILE               Input text file.
  --method {mle,plugin,jk,jackknife,mm,millermadow}
                        Specify which method will be used to estimate the
                        entropy.
~~~


### usage examples
A simple example to compute the word counts from the text Ulysses and use the maximum likelihood estimate to estimate the entropy in bits.

As input we will use the output from [wordcounttfl.sh](wordcounttfl.html). 
First, last take a look at the first and last 5 lines of its output when
applyed to *Ulysses* by James Joyce.

~~~ bash
$ cat ulysses.txt | ./wordcounttfl.sh -c | (head -5; echo "..."; tail -5) 
14956
8144
7218
6532
4960
...
1
1
1
1
1
~~~

This sequence of counts produced will be the input to the entropy computing script.
We might also save the counts to a file and use this file as
input to *entropy.py*, as in the third and last line in the examples below.

~~~ bash
$ cat ulysses.txt | ./wordcounttfl.sh -c | ./entropy.py
$ ./wordcounttfl.sh -c -i ulysses.txt | ./entropy.py
$ ./wordcounttfl.sh -c -i ulysses.txt -o ulysses.cnt && ./entropy.py -i ulysses.cnt 
$ ./wordcounttfl.sh -c -i ulysses.txt | ./entropy.py --method mm
$ ./wordcounttfl.sh -c -i ulysses.txt -o ulysses.cnt && ./entropy.py -i ulysses.cnt --method mm
~~~


[back](./)
