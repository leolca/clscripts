#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os
import math 
import argparse

def is_valid_file(parser, arg):
    arg = os.path.abspath(arg)
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return arg

parser = argparse.ArgumentParser()
parser.add_argument("--base", help="Entropy base (default = 2, bits).", type=int, default=2)
parser.add_argument("-i", dest="filename", help="Input text file.", metavar="FILE", type=lambda x: is_valid_file(parser, x))
args = parser.parse_args()

base = 2
if args.base:
  base = args.base

if args.filename:
  f = open(args.filename, "rt")
else:
  f = sys.stdin

x = []
for line in f.readlines():
  x.append( float(line) )

p = []
M = sum(x)
if M != 1:
  p = [xx/M for xx in x] 
else:
  p = x

H = sum( [ -pp*math.log(pp,base) for pp in p ] )
print H
