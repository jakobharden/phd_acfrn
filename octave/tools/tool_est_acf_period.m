## Estimate period of auto-correlation function (ACF) of sinusoidal signals
##
## Usage: [r_ap, r_m0] = tool_est_acf_period(p_acf, p_lag)
##
## p_acf ... auto-correlation function (ACF), [<dbl>]
## p_lag ... lag index array, [<int>]
## r_ap  ... return: ACF period estimate, <dbl>
## r_m0  ... return: zero lag index (m = 0), <uint>
##
## see also: 
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
function [r_ap, r_m0] = tool_est_acf_period(p_acf, p_lag)
  
  ## check arguments
  if (nargin < 2)
    help tool_est_acf_period;
    error('Less arguments given!');
  endif
  
  ## init return values
  r_ap = [];
  r_m0 = 0;
  
  ## determine zero-lag index
  r_m0 = find(p_lag >= 0, 1, 'first');
  
  ## detect first x axis crossing next to the zero lag
  m1 = find(p_acf(1 : r_m0) <= 0, 1, 'last');
  if isempty(m1)
    printf('tool_est_acf_period: Cannot find x axis crossing next to zero lag.\n');
    return;
  else
    kx = p_acf(m1 + 1) - p_acf(m1);
    mx = m1 - p_acf(m1) / kx;
  endif
  
  ## estimate ACF period
  r_ap = (r_m0 - mx) * 2 + 1;
  
endfunction
