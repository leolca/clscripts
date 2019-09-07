/*
 *  This file is part of the clscripts (https://github.com/leolca/clscripts).
 *  Copyright (c) 2019 Leonardo Araujo (leolca@gmail.com).
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>
 * 
*/
#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <string.h>
#include <getopt.h>

void PrintHelp()
{
    printf("Usage: type [FILE]...\n");
    printf("Output the types of each line from a given FILE to standard output.\n");
    printf("With no FILE, or when FILE is -, read standard input.\n");
    printf("  type file   Output tri-grams in file.\n");
    exit(1);
}

int main(int argc, char *argv[])
{
    char *locale;
    locale = setlocale(LC_ALL, "");
    char buf[BUFSIZ];
    int i, len;
    int opt;
    FILE *stream = NULL;

    const char* const short_opts = "i:";
    static struct option long_options[] =
    {
       {"input", required_argument, 0, 'i'},
       {"help" , no_argument,       0, 'h'},
       {0      , no_argument,       0,  0 }
    };
    while ((opt = getopt_long (argc, argv, short_opts, long_options, NULL)) != -1)
    {
      switch (opt) 
      {
         case 'i':
            if((stream = fopen(optarg,"r"))==NULL) { printf("Input file not found!\n"); exit(-1); }
            break;
         case 'h': // -h or --help
         case '?': // Unrecognized option
         default:
            PrintHelp();
            break;
      }
    }
    if (stream == NULL) stream = stdin;

    while(fgets(buf, sizeof buf, stream) != NULL)
    {
    int freq[26];
    for(i=0; i<26; i++)
          freq[i] = 0;
    len = strlen(buf);
    for(i=0; i<len; i++)
      if(buf[i]>='a' && buf[i]<='z')
         freq[buf[i] - 97]++;
    
    for(i=0; i<26; i++)
	    if(freq[i] != 0)
		    printf("%c%d", (i + 97), freq[i]);
    printf("\n");
    }
}

