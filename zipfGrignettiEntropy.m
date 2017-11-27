## Copyright (C) 2017 Leonardo Araujo
##
## This program is free software; you can redistribute it
## and/or modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 3 of
## the License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied warranty
## of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with the fuzzy-logic-toolkit; see the file COPYING.  If not,
## see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{Hmean}, @var{Hdelta}] = } dpcmenco (@var{s}, @var{N}, @var{q}, @var{b})
## @deftypefnx {Function File} {[@var{Hmean}, @var{Hdelta}] = } dpcmenco (@var{s}, @var{N}), @var{q})
## @deftypefnx {Function File} {[@var{Hmean}, @var{Hdelta}] = } dpcmenco (@var{s}, @var{N}), @var{[]}, @var{b})
## @deftypefnx {Function File} {[@var{Hmean}, @var{Hdelta}] = } dpcmenco (@var{s}, @var{N})
##
## Estimate zipfian(-mandelbrot) entropy using Grignetti's approach.
## @table @code
## @item [Hmean, Hdelta] = zipfGrignettiEntropy(s,N,q,b)
## Estimate the entropy of a zipfian-mandelbrot distributted source with Zipf's exponnet s,
## Mandelbrot's flattening constant q, vocabulary size N and base b.
##
## @item [Hmean, Hdelta] = zipfGrignettiEntropy(s, N, q)
## Use base 2. The results are given in bits.
##
## @item [Hmean, Hdelta] = zipfGrignettiEntropy(s, N, [], b)
## Compute the Zipf's entropy in base b.
##
## @item [Hmean, Hdelta] = zipfGrignettiEntropy(s, N)
## Zipf's entropy is given in bits.
##
## @end table
## @end deftypefn
## @seealso{entropy}

function [Hmean, Hdelta] = zipfGrignettiEntropy(s,N,q,b)

narginchk(2,4);

if !isnumeric(s) || !isnumeric(N) || (exist("q") && !isnumeric(q)) || (exist("b") && !isnumeric(b)), error('Only numeric entries are allowed!'); endif;
if s < 0 || N < 0 || (exist("q") && q < 0) || (exist("b") && b < 0), error('You must provide positive values only!'); endif;
if N != floor(N), error('The vocabulary length must be integer!'); endif;


if nargin < 3, % Zipf's law
  C = 1./sum( [1:N].^(-s) );
  K = max( ceil(e^(1/s)) ,1);
  SK = 0; for n=1:K-1, SK+=log(n)/(n^s); endfor;
  lm = integrallogxx(N,s) - integrallogxx(K,s) + SK + log(N)/(N^s);
  n=K; SK+=log(n)/(n^s); 
  LM = integrallogxx(N-1,s) - integrallogxx(K,s) + SK + log(N)/(N^s);
  Hl = (s*C/log(2)) .* lm - log(C)/log(2);
  Hh = (s*C/log(2)) .* LM - log(C)/log(2);
  if nargin > 3, % change base from 2 (bits) to b
    Hl = Hl / log2(b);
    Hh = Hh / log2(b);
  endif
  Hmean = (Hh + Hl)/2;
  Hdelta = Hh - Hl;
else, % Zipf-Mandelbrot
  C = 1./sum( ([1:N]+q).^(-s) );
  K = max( ceil(e^(1/s)-q) ,1);
  SK = 0; for n=1:K-1, SK+=log(n+q)/((n+q)^s); endfor;
  lm = integrallogxx(N,s,q) - integrallogxx(K,s,q) + SK + log(N+q)/((N+q)^s);
  LM = integrallogxx(N-1,s) - integrallogxx(K,s) + SK + log(K+q)/((K+q)^s) + log(N+q)/((N+q)^s);
  Hl = (s*C/log(2)) .* lm - log(C)/log(2);
  Hh = (s*C/log(2)) .* LM - log(C)/log(2);
  if nargin > 3, % change base from 2 (bits) to b
    Hl = Hl / log2(b);
    Hh = Hh / log2(b);
  endif 
  Hmean = (Hh + Hl)/2;
  Hdelta = Hh - Hl;
endif

endfunction

function r = integrallogxx(x,s,q)
if nargin < 3,
  if s != 1,
    r = ( (x^(1-s))/(1-s) ) * ( log(x) - 1/(1-s) );
  else
    r = 0.5*log(x).^2;
  endif
else,
  if s != 1,
    r = ( ((x+q)^(1-s))/(1-s) ) * ( log(x+q) - 1/(1-s) );
  else
    r = 0.5*log(x+q).^2;
  endif
endif
endfunction


