## downloadGutenbergTop100in30days.sh
Download the top 100 ebooks (in the last 30 days) from the Project Gutenberg. 
Files are saved in current folder and processed, removing carriage returns (\r), 
translating non-ASCII characters, removing disclaimers and removing BOM (Byte order mark).

### script usage 
Just call the script. There is no argument to give.

### usage examples

~~~ bash 
$ ./downloadGutenbergTop100in30days.sh
$ cat *.txt | ./wordcounttfl.sh | head 
f       type
694631  the
461851  and
380760  of
330844  to
237780  a
203042  i
202164  in
168186  that
148586  he
~~~


[back](./)

