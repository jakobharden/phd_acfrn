## Generate damped sinusoidal signal (exponential decay related to total signal length)
##
## Usage: [r_ss, r_nn, r_ns] = tool_gen_sinusoidal1(p_am, p_n0, p_nc, p_df)
##
## p_am ... signal amplitude, <dbl>
## p_n1 ... number of samples of one full period, n1 >= 5, <uint>
## p_nc ... number of cycles, nc >= 1, optional, default = 1, <dbl>
## p_df ... exponential decay factor, df >= 0, optional, default = 0, <dbl>
## r_ss ... return: signal amplitude array, [<dbl>]
## r_nn ... return: signal sample index, [<uint>]
## r_ns ... return: total number of samples, <uint>
##
## Sinusoidal signal model: s[n] = sin(n * omega) * exp(-df * n / N), omega = 2 * pi / N1
##
## Note: The exponential decay is related to the total signal length!
##
## see also: sin, exp
##
#######################################################################################################################
## LICENSE
##
##    Copyright (C) 2024 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU Affero General Public License as
##    published by the Free Software Foundation, either version 3 of the
##    License, or (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU Affero General Public License for more details.
##
##    You should have received a copy of the GNU Affero General Public License
##    along with this program.  If not, see <https://www.gnu.org/licenses/>.
##
#######################################################################################################################
## This file is part of the PhD thesis of Jakob Harden.
##
function [r_ss, r_nn, r_ns] = tool_gen_sinusoidal1(p_am, p_n1, p_nc, p_df)
  
  ## check arguments
  if (nargin < 4)
    p_df = [];
  endif
  if (nargin < 3)
    p_nc = [];
  endif
  if (nargin < 2)
    help tool_gen_sinusoidal1;
    error('Less arguments given!');
  endif
  if isempty(p_df)
    p_df = 0;
  endif
  if isempty(p_nc)
    p_nc = 1;
  endif
  if isempty(p_n1)
    help tool_gen_sinusoidal1;
    error('Sinusoidal signal period is empty!');
  endif
  if (p_n1 < 5)
    help tool_gen_sinusoidal1;
    error('Sinusoidal signal period is beyond 5 samples!');
  endif
  p_nc = max([abs(p_nc), 1]);
  p_df = abs(p_df);
  
  ## total number of samples
  r_ns = floor(p_nc * p_n1);
  
  ## sample index
  r_nn = 0 : r_ns - 1;
  
  ## signal amplitude array
  if (p_df < 1e-6)
    r_ss = p_am * sin(r_nn * (2 * pi / p_n1));
  else
    r_ss = p_am * sin(r_nn * (2 * pi / p_n1)) .* exp((-p_df / r_ns) * r_nn);
  endif
  
endfunction
