#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os
import commands
import math
import numpy
import argparse

def is_valid_file(parser, arg):
    arg = os.path.abspath(arg)
    if not os.path.exists(arg):
        parser.error("The file %s does not exist!" % arg)
    else:
        return arg

def file_max_len(filename, token):
    if token == "word":
      cmd = commands.getstatusoutput('wc -w ' + filename)
    elif token == "char":
      cmd = commands.getstatusoutput('wc -m ' + filename)
    elif token == "line":
      cmd = commands.getstatusoutput('wc -l ' + filename)
    else:
      cmd = math.nan

    if type(cmd[1]) is str:
      cmd = int( cmd[1].split()[0] )

    return cmd-1

parser = argparse.ArgumentParser()
parser.add_argument("-i", dest="filename", help="Input text file.", metavar="FILE", type=lambda x: is_valid_file(parser, x))
parser.add_argument("--start", help="Start index (default = 0).", type=int, default=0)
parser.add_argument("--stop", help="Stop index (default = file_length - 1).", type=int, default=0)
parser.add_argument("--token", help="Choose a token structures.", default="word", choices=["word", "char", "line"])
parser.add_argument("--wtype", help="Window type.", default="cumulative", choices=["cumulative", "sliding"])
parser.add_argument("--nwin", help="Number of windows", type=int, default=64)
parser.add_argument("--wscale", help="Window scale.", default="linear", choices=["linear", "log", "log10", "log2"])
args = parser.parse_args()

if args.stop == 0:
  args.stop = file_max_len(args.filename, args.token)

flgstartzero = False
if ( args.wscale == "log" or args.wscale == "log10" or args.wscale == "log2" ) and args.start == 0:
  args.start = 1
  flgstartzero = True

if args.wscale == "linear":
  wix = numpy.linspace(args.start, args.stop, num=(args.nwin+1))
elif args.wscale == "log" or args.wscale == "log10":
  wix = numpy.logspace(math.log10(args.start), math.log10(args.stop), num=(args.nwin+1))
elif args.wscale == "log2":
  wix = numpy.logspace(math.log2(args.start), math.log2(args.stop), num=(args.nwin+1), base=2)

if flgstartzero:
  wix[0] = 0

wix[0] -= 1
for ix in range( len(wix)-1 ):
  if args.wtype == "sliding":
    print str(int(wix[ix].round())+1) + "\t" + str(int(wix[ix+1].round()))
  elif args.wtype == "cumulative":
    print str(int(wix[0].round())+1) + "\t" + str(int(wix[ix+1].round()))


