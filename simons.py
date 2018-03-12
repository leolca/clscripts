#!/usr/bin/env python
from __future__ import division
import sys
import os
import re
import argparse

# usage example
# cat casa.txt | ./simons.py | sort | uniq -c | awk -F" " '{print $1}' | awk '{s+=$1} END {print $1/s}'

def is_valid_file(parser, arg):
    arg = os.path.abspath(arg)
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return arg

parser = argparse.ArgumentParser()
parser.add_argument("-i", dest="filename", required=False, help="input text file", metavar="FILE", type=lambda x: is_valid_file(parser, x))
parser.add_argument("--newratio", required=False, help="show the ratio of new words in the data", action='store_true')
parser.add_argument("--newratioevo", required=False, help="show the ratio of new words evolution in the data", action='store_true')
args = parser.parse_args()


words = []
count = 0
newword = 0
if args.filename:
  f = open(args.filename, "rt")
else:
  f = sys.stdin
lines = f.readlines()
for line in lines:
    s = line.split()
    for word in s: 
        count+=1
        word = word.lower().strip()
        if not word in words:
           words.append(word)
	   newword+=1
	   if not args.newratio and not args.newratioevo:
	      print '1'
	else:
	   if not args.newratio and not args.newratioevo:
	      print '0'
        if not args.newratio and args.newratioevo:
	   print newword/count
if args.newratio:
   print newword/count
