## Estimate auto-correlation function (ACF) with reduced impact of noise
##
## Usage: [r_acf, r_lag, r_nrm, r_mli, r_m0, r_dx] = tool_est_acfrn(p_xx, p_acm, p_nrm)
##
## p_xx  ... signal amplitude array, signal in noise, [<dbl>]
## p_acm ... auto-correlation scaling mode, optional, default = 'none', <str>
## p_nrm ... noise reduction modes, optional, default = 'm0', <str>
## r_acf ... return: auto-correlation function (ACF), [<dbl>]
## r_lag ... return: ACF lag, [<int>]
## r_nrm ... return: ACF noise reduction mode, <uint>
## r_mli ... return: modified lag index, [<uint>]
## r_m0  ... return: zero-lag index, <uint>
## r_dx  ... return: ACF period estimate, <dbl>
##
## Auto-correlation scaling modes:
##   p_acm = 'none':     correlation sum
##   p_acm = 'biased':   biased ACF estimate
##   p_acm = 'unbiased': unbiased ACF estimate
##
## Noise reduction modes - input:
##   p_nrm = 'm0':  Reduce noise at zero-lag only
##   p_nrm = 'm01': Reduce noise at zero-lag and at lag m = +/- 1
##   p_nrm = 'mx2': Reduce noise (polynomial regression) at symmetric section around the zero lag.
##                  Section width is 1/3 of the distance between the x axis crossing of the ACF next to the zero-lag.
##
## Prerequisites and assumptions:
##   1) Signal model x[n] = s[n] + v[n]
##   2) Noise is i.i.d. Gaussian white noise
##   3) Signal x is a (mostly) mean-free (damped) sinusoidal signal
##   4) The distance between the first ACF x axis crossings next to the zero lag has to be greater or equal to 7 samples.
##
## Algorithm:
##   step 1: Estimate ACF (xcorr)
##   step 2: Determine zero-lag index and ACF period
##   step 3: Determine regression interval limits, centered to zero lag
##   step 4: Fit polynome of 2nd order to ACF inside regression interval
##   step 5: Replace ACF magnitudes with regression polynome magnitududes (depends on noise reduction mode r_nrm)
##
## see also: xcorr, polyfit, tool_est_acf_period
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
function [r_acf, r_lag, r_nrm, r_mli, r_m0, r_dx] = tool_est_acfrn(p_xx, p_acm, p_nrm)
  
  ## check arguments
  if (nargin < 3)
    p_nrm = [];
  endif
  if (nargin < 2)
    p_acm = [];
  endif
  if (nargin < 1)
    help tool_est_acfrn;
    error('Less arguments given!');
  endif
  if isempty(p_nrm)
    ## use noise reduction mode 'm0'
    p_nrm = 'm0';
  endif
  if isempty(p_acm)
    ## return the correlation sum
    p_acm = 'none';
  endif
  
  ## init return values
  r_acf = []; # auto-correlation function r_xx
  r_lag = []; # lag index of rxx
  r_nrm = 0; # noise reduction mode
  r_mli = []; # modified lag index, lag indeces affected by noise reduction
  
  ## step 1: estimate ACF
  [r_acf, r_lag] = xcorr(p_xx, p_xx, p_acm);
  
  ## step 2: determine zero-lag index, estimate ACF period
  [r_dx, r_m0] = tool_est_acf_period(r_acf, r_lag);
  if (r_dx < 7)
    printf('Distance between the ACF x axis crossings next to the zero lag is smaller than 7 samples!\nUsing ACF(ACF(x)) to estimate the distance between the x axis crossings.\n');
    [acftmp1, lagtmp1] = xcorr(r_acf, r_acf, floor(length(r_acf) / 2), p_acm);
    [r_dx, ~] = tool_est_acf_period(acftmp1, lagtmp1);
    if (r_dx < 7)
      warning('Distance between the ACF x axis crossings next to the zero lag is still smaller than 7 samples! Return ACF without noise reduction.');
      return;
    endif
  endif
  
  ## step 3: determine regression interval limits, centered to zero-lag
  dx6 = ceil(r_dx / 6); # 1/6 distance
  ridx = transpose([r_m0 - dx6 : r_m0 + dx6]); # regression index
  
  ## step 4: fit polynome of 2nd order to ACF inside regression interval
  ## least-squares approach
  [p, s, mu] = polyfit(ridx, r_acf(ridx)(:), 2);
  
  ## step 5: select noise reduction mode, replace ACF values
  switch (p_nrm)
    case 'm0'
      r_mli = r_m0; # modified lag index
      r_acf(r_mli) = s.yf(dx6 + 1); # replace ACF samples
      r_nrm = 1; # update noise reduction mode
    case 'm01'
      r_mli = [r_m0 - 1; r_m0; r_m0 + 1]; # modified lag index
      r_acf(r_mli) = s.yf([dx6, dx6 + 1, dx6 + 2]); # replace ACF samples
      r_nrm = 2; # update noise reduction mode
    case 'mx2'
      r_mli = ridx; # modified lag index
      r_acf(r_mli) = s.yf; # replace ACF samples
      r_nrm = 3; # update noise reduction mode
  otherwise
      help tool_est_acfrn;
      error('Noise reduction mode %s not implemented yet!', p_nrm);
  endswitch
  
endfunction
