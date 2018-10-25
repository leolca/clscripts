#!/bin/bash

# https://www.congress.gov/resources/display/content/The+Federalist+Papers

BASEURL='http://avalon.law.yale.edu/18th_century/fed'
for i in `seq -w 01 85`;
do
   theURL="$BASEURL$i.asp"
   wget $theURL -q -O fed$i.html
   html2text fed$i.html > fed$i.tmp
   STARTNUM=$(($(grep -n -m1 '|Previous_Document|Contents|Next_Document|' fed$i.tmp | cut -f1 -d':')+1))
   if [ "$STARTNUM" -eq 1 ]
   then 
      STARTNUM=$(($(grep -n -m1 '|Contents|Next_Document|' fed$i.tmp | cut -f1 -d':')+1))
      if [ "$STARTNUM" -eq 1 ]
      then
         STARTNUM=$(($(grep -n -m1 '|Previous_Document|Contents|' fed$i.tmp | cut -f1 -d':')+1))
      fi
   fi
   ENDNUM=$(($(grep -n -m2 '|Previous_Document|Contents|Next_Document|' fed$i.tmp | tail -n1 | cut -f1 -d':')-1))
   if [ "$ENDNUM" -eq -1 ]
   then 
      ENDNUM=$(($(grep -n -m2 '|Contents|Next_Document|' fed$i.tmp | tail -n1 | cut -f1 -d':')-1))
      if [ "$ENDNUM" -eq -1 ]
      then
         ENDNUM=$(($(grep -n -m2 '|Previous_Document|Contents|' fed$i.tmp | tail -n1 | cut -f1 -d':')-1))
      fi
   fi
   tail -n +$STARTNUM fed$i.tmp | head -n $(($ENDNUM - $STARTNUM)) > fed$i.txt
   rm fed$i.html fed$i.tmp
done

grep -l MADISON *.txt > Madison.list
grep -l HAMILTON *.txt > Hamilton.list
grep -l JAY *.txt > Jay.list
comm -23 Madison.list Hamilton.list > onlyMadison.list
comm -13 Madison.list Hamilton.list > onlyHamilton.list
comm -12 Madison.list Hamilton.list > HamiltonANDMadison.list

