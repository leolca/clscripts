from syllabify import syllabify,pprint
import sys

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

if __name__ == '__main__':
  source = open('/tmp/cmudict','r')
  for line in source:
      if line[0] == ';': # header, commenst
          continue;
      (word, pron) = line.rstrip().split('  ',1);
      try:
        syllables = syllabify(pron.split()) 
        print("{}\t{}\t{}".format(word, len(syllables), pprint(syllables)))
      except ValueError as e:
        eprint(str(e))


