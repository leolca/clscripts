#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os
import math 
import argparse


# compute entropy from probabilities
# p: counts
# b: base
def entropy(p, b):
  p = filter(lambda a: a != 0, p)
  return sum( [ -pp*math.log(pp,b) for pp in p ] )

def is_valid_file(parser, arg):
    arg = os.path.abspath(arg)
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return arg

parser = argparse.ArgumentParser()
parser.add_argument("--base", help="Entropy base (default = 2, bits).", type=int, default=2)
parser.add_argument("-i", dest="filename", help="Input text file.", metavar="FILE", type=lambda x: is_valid_file(parser, x))
parser.add_argument("--method", help="Specify which method will be used to estimate the entropy.", default="mle", choices=['mle','plugin','jk','jackknife','mm','millermadow'])
args = parser.parse_args()

base = 2
if args.base:
  base = args.base

if args.filename:
  f = open(args.filename, "rt")
else:
  f = sys.stdin

n = []
for line in f.readlines():
  line = line.replace(',',' ')
  values = line.split()
  for v in values:
      n.append( float(v) )


M = sum(n)    # sample size
N = len(n) # vocabulary size
if args.method == 'mle' or args.method == 'plugin':
  p = [nn/M for nn in n]
  #H = sum( [ -pp*math.log(pp,base) for pp in p ] )
  H = entropy(p, base)
elif args.method == 'jk' or args.method == 'jackknife':
  n = filter(lambda a: a != 0, n)
  N = len(n)
  p = [nn/M for nn in n]
  #H = M*sum( [ -pp*math.log(pp,base) for pp in p ] )
  H = M*entropy(p, base)
  for i in range(0,N):
     nt = n
     nt[i] -= 1
     Mt = sum(nt)
     p = [nn/Mt for nn in nt]
     H -= ((M-1)/M) * n[i] * entropy(p,base)
   
print H
