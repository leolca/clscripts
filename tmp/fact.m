function f = fact(m)

if m == 0, f = 1;
else f = m*fact(m-1);
endif

