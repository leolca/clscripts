#!/usr/bin/env python
import sys
import os
import re
import numpy as np
import argparse


def is_valid_file(parser, arg):
    arg = os.path.abspath(arg)
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return arg

parser = argparse.ArgumentParser()
parser.add_argument("--maxlen", required=False, help="maximum length of the sample that will be analyzed", type=int)
parser.add_argument("--samples", required=False, help="number of points in the output (linearly spaced or logarithmically spaced)", type=int, default=100)
parser.add_argument("--log", required=False, help="use log scale", action='store_true')
parser.add_argument("-i", dest="filename", required=False, help="input text file", metavar="FILE", type=lambda x: is_valid_file(parser, x))
args = parser.parse_args()

if args.maxlen:
  maxlen = args.maxlen
elif args.filename:
  # count number of words in the input file
  maxlen = sum(len(line.split()) for line in open(args.filename))
else:
  maxlen = -1

lsamples = []
if args.samples and maxlen > 0:
  if args.log:
    nsamples = int(args.samples)
    while len(lsamples) <> int(args.samples):
       lsamples = list(set( np.round(np.logspace(0, np.log10(maxlen), num=nsamples)) ))
       if len(lsamples) < args.samples:
          nsamples = 2*nsamples - len(lsamples)
       elif len(lsamples) > args.samples:
          nsamples = nsamples - max(1,round((len(lsamples)-nsamples)/2))
  else:
    lsamples = np.round(np.linspace(1, maxlen, num=args.samples))

words = []
doc = []
count = 0
if args.filename:
  f = open(args.filename, "rt")
else:
  f = sys.stdin
lines = f.readlines()
for line in lines:
    s = line.split()
    for word in s: 
        count+=1
	if args.maxlen and count > maxlen:
	   sys.exit(0)
        word = word.lower().strip()
        if not word in words:
           words.append(word)
        doc.append( (count, len(words)) )
	if any(lsamples):
	  if count in lsamples:
 	     print str(count) + '\t' + str(len(words))
	else:
	  print str(count) + '\t' + str(len(words))
