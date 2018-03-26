n=numbins #number of intervals
max=maxvalue #max value
min=minvalue #min value
thelegend=lbllegend
thexlabel=lblxlabel
theylabel=lblylabel
thefilename=outputfilename
width=(max-min)/n #interval width
#function used to map a value to the intervals
hist(x,width)=width*floor(x/width)+width/2.0
set boxwidth width*0.9
set style fill solid 0.5 # fill style
set terminal png
set output thefilename
set xlabel thexlabel
set ylabel theylabel
#count and plot
plot '<cat' u (hist($1,width)):(1.0) smooth freq w boxes lc rgb"blue" title thelegend

