## Wrapper: compute parameter variation, ACF with noise reduction
##
## Usage: [r_mat] = wrapper_acfrn_pvar(p_cp, p_vp, p_mc)
##
## p_cp  ... constant parameters, cell array, {<any_octave_data_type>}
## p_vp  ... variation parameters, numeric array, [<numeric>]
## p_mc  ... number of Monte-Carlo turns
## r_mat ... return: result matrix [1 x 6], columns are explained below, <uint>
##
## Estimation methods:
##   Method 1: subtract noise power from zero lag magnitude of the ACF (requires noise data)
##   Method 2: ACF with noise reduction at zero lag of the ACF (does not require noise data)
##
## Result matrix columns:
##   r_mat(:, 1) = noise reduction mode, <int>
##   r_mat(:, 2) = reference signal power, <dbl>
##   r_mat(:, 3) = relative power error, method 1, <dbl>
##   r_mat(:, 4) = relative power error, method 2, <dbl>
##
## see also: test_acfrn, tool_gen_sinusoidal1, tool_scale_noise2snr, tool_est_acfrn
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
function [r_mat] = wrapper_acfrn_pvar(p_cp, p_vp, p_mc)
  
  ## check arguments
  if (nargin < 1)
    ## return number of result matrix columns
    r_mat = 4;
    return;
  endif
  
  ## const_par = {c_acf_mode, c_nrm_mode, c_A0, vv_mat}
  c_acf_mode = p_cp{1};
  c_nrm_mode = p_cp{2};
  c_A0 = p_cp{3};
  c_vvmat = p_cp{4};
  
  ## var_par = [v_N1, v_DF, v_SNR, v_NCY, v_idxMC]
  v_N1 = p_vp(1);
  v_DF = p_vp(2);
  v_SNR = p_vp(3);
  v_NCY = p_vp(4);
  v_idxMC = 1 : 1 : p_mc;
  
  ## generate signal
  [ss, nn, Ntot] = tool_gen_sinusoidal1(c_A0, v_N1, v_NCY, v_DF);
  ss = transpose(ss);
  psr = meansq(ss); # estimate signal power (reference signal power for error estimates)
  
  ## Monte-Carlo test
  r_mat = zeros(p_mc, 4);
  r_mat(:, 2) = psr;
  for k = v_idxMC
    ## scale noise to given SNR
    [vv, sf_0, ps_0, pv1] = tool_scale_noise2snr(psr, c_vvmat(nn + 1, k), v_SNR);
    ## generate signal in noise
    xx = ss + vv;
    ## estimate power of noisy signal
    px = meansq(xx);
    ## estimate signal power, classic method, method 1
    ps1 = px - pv1;
    ## estimate signal power by ACF with noise reduction, method 2
    [acf, lag, r_mat(k, 1), mli, m0] = tool_est_acfrn(xx, c_acf_mode, c_nrm_mode);
    ps2 = acf(m0);
    ## compute relative power error
    r_mat(k, 3) = abs(ps1 - psr) / psr;
    r_mat(k, 4) = abs(ps2 - psr) / psr;
  endfor
  
endfunction
