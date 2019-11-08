## windowindex.py
Get star and end indexes of windows when subdividing the text extent.
 

### script usage 
The script help presents the available parameters that might be used.

~~~ bash
$ ./windowindex.py -h
usage: windowindex.py [-h] [-i FILE] [--start START] [--stop STOP]
                      [--token {word,char,line}]
                      [--wtype {cumulative,sliding}] [--nwin NWIN]
                      [--wscale {linear,log,log10,log2}]

optional arguments:
  -h, --help            show this help message and exit
  -i FILE               Input text file.
  --start START         Start index (default = 0).
  --stop STOP           Stop index (default = file_length - 1).
  --token {word,char,line}
                        Choose a token structures.
  --wtype {cumulative,sliding}
                        Window type.
  --nwin NWIN           Number of windows
  --wscale {linear,log,log10,log2}
                        Window scale.
~~~

### usage examples
Some usage examples are presented below.

~~~ bash
$ ./windowindex.py -i alice.txt --token line --nwin 10 --wscale log --wtype sliding
0       2
3       5
6       11
12      26
27      58
59      130
131     293
294     659
660     1484
1485    3340
~~~

~~~ bash
$ ./windowindex.py -i alice.txt --token line --nwin 10 --wscale linear --wtype sliding
0       334
335     668
669     1002
1003    1336
1337    1670
1671    2004
2005    2338
2339    2672
2673    3006
3007    3340
~~~


[back](./)

