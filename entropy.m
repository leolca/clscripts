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
## @deftypefn {Function File} {@var{H} = } entropy (@var{p}, @var{b})
## @deftypefnx {Function File} {@var{H} = } entropy (@var{p})
##
## Compute the Shannon entropy of a given distribution.
## @table @code
## @item H = entropy(p,b)
## Compute the Shannon entropy of the probability mass funcion p in base b.
## If not provided, the default value of b is 2 and the entropy is given in bits.
## @end table
## @end deftypefn
## @seealso{jointentropy,mutualinformation,markoventropy}

function H = entropy(p,b)

  if (nargin == 0 || nargin > 2) print_usage (); endif;
  if any(p < 0) | any(p > 1) | abs(sum(p)-1) > 1E-10, error('not a valid pmf!'); endif;

  id = find(p!=0);
  p = p(id);
  H = sum( - p .* log2(p) );

  if nargin > 1, H *= log(2)/log(b); endif;

endfunction

%!demo
%! p = [0.5 0.5];
%! H = entropy(p);
%! printf('The pmf p has entropy = %.2f bits.\n',H);
%! He = entropy(p,e);
%! printf('The pmf p has entropy = %.2f nats.\n',He);
%! p = [0:0.02:1];
%! for i=1:length(p), H(i) = entropy([p(i), (1-p(i))]); endfor;
%! figure; plot(p,H); xlabel('p'); ylabel('H(p) (bits)'); title('binary entropy');

