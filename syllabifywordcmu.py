#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from syllabify import syllabify,pprint
import sys
import os
import argparse

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def is_valid_file(parser, arg):
    arg = os.path.abspath(arg)
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return arg

parser = argparse.ArgumentParser()
parser.add_argument("-i", dest="filename", help="Input text file.", metavar="FILE", type=lambda x: is_valid_file(parser, x))
parser.add_argument("-d", dest="cmusource", help="CMU dictionary file (default: /tmp/cmudict).", metavar="FILE", type=lambda x: is_valid_file(parser, x))
parser.add_argument("--verbose", help="increase output verbosity", action="store_true")
args = parser.parse_args()

if args.filename:
  f = open(args.filename, "rt")
else:
  f = sys.stdin

if args.cmusource:
  source = open(args.cmusource, "rt")
else:
  source = open("/tmp/cmudict", "rt")

dic = {}
for line in source:
  if line[0] == ';': # header, commenst
     continue;
  (word, pron) = line.rstrip().split('  ',1);
  dic[word.lower()] = pron

for line in f.readlines():
    word = line.rstrip().lower()
    if word in dic:
       pron = dic[word]
       try:
         syllables = syllabify(pron.split()) 
         if args.verbose:
           print("word: {}\nnumber of syllables: {}\nsyllabification: {}".format(word, len(syllables), pprint(syllables)))
         else:
           print(pprint(syllables))
       except ValueError as e:
         eprint(str(e))
    else:
        print("{} not in dic".format(line.lower()))

