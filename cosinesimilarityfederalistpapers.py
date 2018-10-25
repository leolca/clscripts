# -*- coding: utf-8 -*-

import re
import os
import numpy as np
import matplotlib.pyplot as plt 
from collections import Counter
from sklearn import manifold

la = np.linalg

vocabFile = 'vocabularytop2000'
vocabulary = []
with open(vocabFile,'r') as f:
  vocabulary = f.read().split()

dbpath = '~/the_federalist_papers/'
txtFiles = [os.path.join(dbpath, f) for f in os.listdir(dbpath) if os.path.isfile(os.path.join(dbpath, f)) and  f.endswith(".txt")]
shortNames = [f for f in os.listdir(dbpath) if os.path.isfile(os.path.join(dbpath, f)) and  f.endswith(".txt")]

def words(text): return re.findall(r'\w+', text.lower())

# words histogram matrix
X = np.zeros((len(vocabulary), len(txtFiles)))
for j in range(len(txtFiles)):
   WORDS = Counter(words(open(txtFiles[j]).read()))
   for i in range(len(vocabulary)):
      X[i,j] = WORDS[vocabulary[i]]

def dot(A,B): 
    return (sum(a*b for a,b in zip(A,B)))

def cosine_similarity(a,b):
    return dot(a,b) / ( (dot(a,a) **.5) * (dot(b,b) ** .5) )

# distance matrix
D = np.zeros((len(txtFiles),len(txtFiles)))
for i in range(len(txtFiles)):
   for j in range(len(txtFiles)):
      D[i,j] = cosine_similarity(X[:,i],X[:,j])

#plt.imshow(D)
#plt.gray()
#plt.show()

labelFiles = ['/ms/downloads/samples/the_federalist_papers/Jay.list', '/ms/downloads/samples/the_federalist_papers/onlyMadison.list', '/ms/downloads/samples/the_federalist_papers/onlyHamilton.list', '/ms/downloads/samples/the_federalist_papers/HamiltonANDMadison.list']
lcolors = ['blue', 'yellow', 'red', 'orange']
lbltxt = ['Jay', 'Madison', 'Hamilton', 'Hamilton and Madison']

def getcolor(shortNames,labelFiles,lcolors,lbl):
   for i in range(len(labelFiles)):
      with open(labelFiles[i]) as lblfile:
         if shortNames in lblfile.read():
            return (lcolors[i],lbl[i])
      

mds = manifold.MDS(n_components=2, dissimilarity="precomputed")
results = mds.fit(D)
coords = results.embedding_
plt.subplots_adjust(bottom = 0.1)
#plt.scatter(
#    coords[:, 0], coords[:, 1], marker = 'o'
#    )
for label, x, y in zip(shortNames, coords[:, 0], coords[:, 1]):
    thecolor, thelabel = getcolor(label,labelFiles,lcolors,lbltxt)
    plt.plot(x, y, 'o', color=thecolor, label=thelabel)
    plt.annotate(
        label,
        xy = (x, y), xytext = (-20, 20),
        textcoords = 'offset points', ha = 'right', va = 'bottom',
        bbox = dict(boxstyle = 'round,pad=0.5', fc = thecolor, alpha = 0.5),
        arrowprops = dict(arrowstyle = '->', connectionstyle = 'arc3,rad=0'))

plt.legend(bbox_to_anchor=(1.1, 1.05))
plt.show()


