#!/bin/bash

function has_bom() { 
  head -c3 "$1" | LC_ALL=C grep -qP '\xef\xbb\xbf'; 
}

function validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK\|HTTP/1.0 200 OK'` ]]; then echo -e "true\c"; else echo -e "false\c"; fi
}

# remove empty files
find . -name '*.txt' -size 0 -print0 | xargs -0 -r rm
BASEURL='http://www.gutenberg.org/files/'
wget http://www.gutenberg.org/browse/scores/top -q -O top100.html
LINENUM=$(($(grep -n "<h2 id=\"books-last30\">Top 100 EBooks last 30 days</h2>" top100.html | cut -f1 -d":")+1))
LENGTH=$(tail -n +$LINENUM top100.html | grep -n "</ol>" -m 1 | cut -f1 -d":")
tail -n +$LINENUM top100.html | head -n $LENGTH | grep -o -E '/ebooks/[0-9]+' | grep -o -E '[0-9]+' > top100list
while read GNUM; do
  COUNTER=0
  while [[ $COUNTER -lt 3 ]]; do
     let COUNTER=COUNTER+1
     theURL="$BASEURL$GNUM/$GNUM-0.txt"
     if [ "$(validate_url $theURL)" = "true" ]
     then
        echo trying to download from $theURL... $COUNTER/10
        wget $theURL -q -O $GNUM.txt
     else
        echo $theURL not found
        theURL="$BASEURL$GNUM/$GNUM.txt"
        if [ "$(validate_url $theURL)" = "true" ]
           then 
           echo trying to download from $theURL... $COUNTER/10
           wget $theURL -q -O $GNUM.txt
        else
           echo $theURL not found
           theURL="$BASEURL$GNUM/$GNUM.txt.uff-8"
           if [ "$(validate_url $theURL)" = "true" ]
           then
              echo trying to download from $theURL... $COUNTER/10
              wget $theURL -q -O $GNUM.txt
           else
              echo $theURL not found
           fi
        fi
     fi
     if [ -s "$GNUM.txt" ]
     then
        echo done 
        break
     fi
     sleep 1 
  done
  if [ -s "$GNUM.txt" ]
  then
     START=$(($(grep -ni "START OF THIS PROJECT GUTENBERG EBOOK" $GNUM.txt | cut -f1 -d":")+1))
     if [ "$START" -eq 1 ]
     then
        START=$(($(grep -ni "START OF THE PROJECT GUTENBERG EBOOK" $GNUM.txt | cut -f1 -d":")+1))
     fi
     END=$(($(grep -ni "End of Project Gutenberg" $GNUM.txt | cut -f1 -d":")-1))
     if [ "$END" -eq -1 ]
     then
        END=$(($(grep -ni "End of the Project Gutenberg" $GNUM.txt | cut -f1 -d":")-1))
        if [ "$END" -eq -1 ]
        then
           END=$(($(grep -ni "END OF THIS PROJECT GUTENBERG EBOOK" $GNUM.txt | cut -f1 -d":")-1))
        fi
     fi
     if [ "$END" -ne -1 ]
     then
        cat $GNUM.txt | sed -n "${START},${END}p" > tmp
     else
        cat $GNUM.txt > tmp
     fi
     tr -d '\r' < tmp > $GNUM.txt
     iconv -f utf-8 -t ascii//translit < $GNUM.txt > tmp
     mv tmp $GNUM.txt
     FILEBOM=$(has_bom $GNUM.txt && echo "yes" || echo "no")
     if [ "$FILEBOM" == "yes" ]; then
        tail --bytes=+4 $GNUM.txt > tmp
        mv tmp $GNUM.txt
     fi
     echo "Success!"
   else
     echo "File $GNUM.txt not found."
   fi
done < top100list
