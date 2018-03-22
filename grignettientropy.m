function [H, dH] = grignettientropy(s,N,q)
% Compute the Grignetti entropy approximation for a Zipfian  distributed source.
%   [H, dH] = grignettientropy(s,N,q)
%
% The source distribution is characterized by a Zipf's law with exponent s and vocabulary size N.
% For the Zipf-Mandelbrot approximation the parameter q should be provided to account for the flattening
% at low ranks.
%
% This function computes an upper bound for the entropy and a lower bound. The outputs are H, the mean between
% these bounds, and dH ,the difference from the upper to the lower bounds.
%
% More information is provided in the reference below:
% L. C. Araujo, T. Cristófaro-Silva and H. C. Yehia, Entropy of a Zipfian Distributed Lexicon, Glottometrics 26, 2013, 38-49
% https://www.ram-verlag.eu/wp-content/uploads/2017/02/g26zeit-1.pdf


% /home/leoca/ee/doutorado/2013_1/mle/entropyestimate.m

  if nargin < 3,
    q = 0;
  endif;

  C = 1./sum( ([1:N]+q).^(-s) );
  K = max( ceil(e^(1/s)-q) ,1);
  SK = 0; for n=1:K-1, SK+=log(n+q)/((n+q)^s); endfor;
  lm = integrallogxoverxs(N,s,q) - integrallogxoverxs(K,s,q) + SK + log(N+q)/((N+q)^s);
  LM = integrallogxoverxs(N-1,s) - integrallogxoverxs(K,s) + SK + log(K+q)/((K+q)^s) + log(N+q)/((N+q)^s);
  Hl = (s*C/log(2)) .* lm - log(C)/log(2);
  Hh = (s*C/log(2)) .* LM - log(C)/log(2);
  Hlbits = Hl; % ja esta em bits! / log2(e);
  Hhbits = Hh; % / log2(e);
  Hmean = (Hhbits + Hlbits)/2;
  Hdelta = Hhbits - Hlbits;

endfunction


function r = integrallogxoverxs(x,s,q)
if s != 1,
  r = ( ((x+q)^(1-s))/(1-s) ) * ( log(x+q) - 1/(1-s) );
else
  r = 0.5*log(x+q).^2;
endif
endfunction
