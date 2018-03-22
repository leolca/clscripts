function f = trfact(m)

f = aux(m,1);

endfunction


function r = aux(n,acc)
  if n == 0, r = acc;
  else r = aux(n-1,acc*n);
  endif
endfunction
