#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>
#include <wchar.h> 
#include <locale.h>

#define WORDMAXLEN 100

void PrintHelp()
{
    printf("Usage: ngram [OPTIONS]... [FILE]...\n");
    printf("Output the n-grams from a given FILE to standard output,\nprinting each ngram in a different line.\n");
    printf("Whitespace is considered a delimiter, n-grams are not allowed to countain any.\n\n");
    printf("With no FILE, or when FILE is -, read standard input.\n");
    printf("  -n, --length <n>     set n-gram length (n)\n");
    printf("  -w, --word           word n-grams mode\n");
    printf("  -b, --no-boundary    remove whitespace boundary restriction\n");
    printf("  -h, --help           display this help and exit\n\n");
    printf("Examples:\n");
    printf("  ngram -n 3 file   Output tri-grams in file.\n");
    exit(1);
}

int isngram(wint_t *ngram) 
{
  if (ngram[0] == '\0') return 0;
  for(int i=1; ;i++) 
     if (ngram[i] == '\0') return 1;
     else if (ngram[i] == ' ' && ngram[i+1] != '\0') return 0;

  return 1;
}

int not_blank(wint_t *ngram)
{
  int not_blank = 1;
  if (ngram[0] == '\0') return 0;
  for(int i=0; ;i++)
  {
     if (ngram[i] == ' ' ||  ngram[i] == '\n') not_blank *= 0;
     if (ngram[i] == '\0') return not_blank;
  }
  return 1;
}

int main(int argc, char *argv[]) 
{

  char *locale;
  locale = setlocale(LC_ALL, "");
  int opt;
  int len = 1;
  int wordmode_flag = 0;
  int boundary_flag = 1;

  const char* const short_opts = "n:wbh";
  static struct option long_options[] =
  {
       {"length", required_argument, 0, 'n'},
       {"word", no_argument,         0, 'w'},
       {"no-boundary", no_argument,  0, 'b'},
       {"help"  , no_argument,       0, 'h'},
       {0       , no_argument,       0,  0 }
  };

  while ((opt = getopt_long (argc, argv, short_opts, long_options, NULL)) != -1)
  {
    switch (opt) 
    {
       case 'n':
	  len = atoi(optarg);
	  if(len < 1) 
	  {
             printf("Invalid length!\n");
	     exit (-1);
	  }
          break;
       case 'w':
	  wordmode_flag = 1;
	  break;
       case 'b':
	  boundary_flag = 0;
	  break;
       case 'h': // -h or --help
       case '?': // Unrecognized option
       default:
	  PrintHelp();
          break;
    }
  }

  if(!wordmode_flag)
  {
    wint_t buf;
    wint_t *ngram = (wint_t*) malloc(sizeof(wint_t) * (len + 1));
    for(int i=0; i<len; i++) ngram[i]=' ';
    ngram[len] = '\0';
    while( (buf = getwchar()) != WEOF ) {
       for(int i=0; i<len-1; i++)
          ngram[i] = ngram[i+1];
       ngram[len-1] = buf;
       if (isngram(ngram)) 
  	  if(boundary_flag)
	  {
             if (not_blank(ngram)) 
                printf("%ls\n", ngram);
	  }
          else
	     printf("%ls\n", ngram);
    }
  }
  else
  {
    int count = 0;
    wint_t buf;
    wint_t wbuf[WORDMAXLEN];
    wint_t **ngram = (wint_t **) malloc(sizeof(wint_t*) * len);
    while( (buf = getwchar()) != WEOF ) {
       if (buf != ' ' && buf != '\n' && buf != '\0')
          wbuf[count++] = buf;
       else
       {
	  if (count > 0)
	  {
	     wint_t *word = (wint_t *) malloc(sizeof(wint_t) * (count + 1));
	     for(int i=0; i<count; i++) word[i]=wbuf[i];
	     word[count]='\0';
	     count = 0;
	     wint_t *firstw = ngram[0];
	     for(int i=0; i<len-1; i++)
                ngram[i] = ngram[i+1];
	     ngram[len-1] = word;
	     if (firstw != NULL) 
		free(firstw);
	     int hasempty = 0;
	     for(int i=0; i<len; i++)
		if (ngram[i] == NULL)
		   hasempty = 1;
	     if (!hasempty)
	     {
	       for(int i=0; i<len; i++) 
	  	  if (ngram[i] != NULL)
		     printf("%ls ", ngram[i]);
	       printf("\n");
	     }
	  }
       }
    }
  }
  return 0;
} 
