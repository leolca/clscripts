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

def valid_len(string):
    value = string.lower()
    if value in ('inf','all'):
       value = -1
    else:
       value = int(string)
    return value

parser = argparse.ArgumentParser()
parser.add_argument("-m","--maxlen", help="Maximum length of the sample that will be analyzed.", type=int)
parser.add_argument("-s","--samples", help="Number of points in the output (linearly spaced or logarithmically spaced). Use Inf or All to print every single sample.", type=valid_len, default=-1)
parser.add_argument("-l","--log", help="Use logarithmic spaced samples.", action='store_true')
parser.add_argument("-i", "--input", dest="filename", help="Input text file name.", metavar="FILE", type=lambda x: is_valid_file(parser, x))
parser.add_argument("-V", "--legomenon", dest="legomenon", help="Number of types in the corresponding frequency classes at the specified Ns (-V 1: hapax legomena, -V 2: hapax and dis legomenon, -V 3: hapax, dis and tris legomenon, etc).", type=int, default=1)
parser.add_argument("-c", "--counts", help="Print only counts (remove header)", action='store_false')
args = parser.parse_args()

if args.maxlen:
  maxlen = args.maxlen
elif args.filename:
  # count number of words in the input file
  maxlen = sum(len(line.split()) for line in open(args.filename))
else:
  maxlen = float('Inf')

if not args.filename and args.samples != -1:
   raise ValueError('When file is not given, the maximum length is unknown and maxlen must be set to Infinite!')

if not args.filename and args.log:
   raise ValueError('When file is not given, it is not possible to use logarithmically spaced samples!')

# list with indexes for the samples
if args.samples > 0:
   lsamples = []
   if args.log:
     nsamples = int(args.samples)
     while len(lsamples) <> int(args.samples): # loop to get the exact number of samples in a log scale, since the indexes are integers (rounded)
        lsamples = list(set( np.round(np.logspace(0, np.log10(maxlen), num=nsamples)) ))
        if len(lsamples) < args.samples:
           nsamples = 2*nsamples - len(lsamples)
        elif len(lsamples) > args.samples:
           nsamples = nsamples - max(1,round((len(lsamples)-nsamples)/2))
   else:
     lsamples = np.round(np.linspace(1, maxlen, num=args.samples))

if args.counts: #print headers
  print 'N' + '\t' + 'V',
  for i in range(0,args.legomenon):
     print '\t' + 'V' + str(i+1),
  print ''

words = {}	# dictionary with word as key and frequency as value
Nf = {} 	# dictionary with frequency as key and number of types with that given frequency (freq. of freq.) as value
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
	if count > maxlen:
	   sys.exit(0)
        word = word.lower().strip()
        if not word in words:
           words[word] = 0
        if words[word] in Nf:
           Nf[ words[word] ] -= 1
        words[word] += 1
        if words[word] in Nf:
           Nf[ words[word] ] += 1
        else:
           Nf[ words[word] ] = 1
	if args.samples == -1 or count in lsamples: # if -1 (print all) or is is in the list of desired samples
 	   print str(count) + '\t' + str(len(words)),
           if args.legomenon:
              for i in range(0,args.legomenon):
                  if i+1 in Nf:
                     print '\t' + str(Nf[i+1]),
                  else:
                     print '\t0', 
           print ''

