set terminal cairolatex standalone pdf size 16cm,4cm dashed transparent monochrome header \
'\newcommand{\hl}[1]{\setlength{\fboxsep}{0.75pt}\colorbox{white}{#1}}'
set output outputfilename
set size ratio 0.125
set yrange[10:20]
set xrange[0:textlength]
unset ytics
unset key
set title 'wordchart - '.inputfilename
set label 1 '\hl{\small '.txtword.'}' at (textlength/20), 18 front nopoint tc def  
plot '<cat' u 1:(10):(0):(20) with vectors nohead 
