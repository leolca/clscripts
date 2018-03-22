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
args = parser.parse_args()

wordfreq = {}
Nf = []
if args.filename:
  f = open(args.filename, "rt")
else:
  f = sys.stdin
lines = f.readlines()
for line in lines:
    s = line.split()
    for word in s: 
        word = word.lower().strip()
        if not word in wordfreq:
	   wordfreq[word] = 0
	wordfreq[word] += 1
	if wordfreq[word] - 1 < len(Nf):
	   Nf[ wordfreq[word] - 1 ] += 1
	   if wordfreq[word] - 1 > 0:
 	      Nf[ wordfreq[word] - 2 ] -= 1
	else:
	   Nf.append(1)
	   if wordfreq[word] - 1 > 0:
	      Nf[ wordfreq[word] - 2 ] -= 1
	#print Nf
print Nf
