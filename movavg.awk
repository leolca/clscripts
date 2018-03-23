#!/usr/bin/awk -f
# Moving average over the first column of a data file
# usage example: 
# $ echo -e '1\n2\n3\n4\n5\n6\n7' | ./movavg.awk -v P=2

{
    x = $1;	
    i = NR % P;
    MA += (x - Z[i]) / P;
    Z[i] = x;
    print MA;	
}
