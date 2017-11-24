#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import math 

if len(sys.argv) > 1:
  base = int(sys.argv[1])
else:
  base = 2

x = []
for line in sys.stdin:
  x.append( float(line) )

p = []
M = sum(x)
if M != 1:
  p = [xx/M for xx in x] 
else:
  p = x

H = sum( [ -pp*math.log(pp,base) for pp in p ] )
print H
