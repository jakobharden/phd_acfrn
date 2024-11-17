## Vary up to 5 parameters with an additional Monte-Carlo test
##
## Usage: [r_vds] = var_param5mc(p_fn, p_cp, p_vp, p_mc)
##
## p_fn  ... function name, (wrapper) function to be evaluated, <type>
## p_cp  ... constant parameter list, cell array, {<any_octave_type>}
## p_vp  ... variation parameter list, cell array,  {<numeric_1D_array>}
## p_mc  ... number of Monte-carlo test turns, <uint>
## r_vds ... return: variation result data structure, <struct>
##
## Variation result data structure fields (r_vds):
##   .Nlvl  ... variation levels, variation depth without Monte-Carlo test, <uint>
##   .Ntot  ... total number of variations, <uint>
##   .Nres  ... number of results per variation, <uint>
##   .cpar  ... constant parameter list, {<any_octave_type>}
##   .vpar  ... variation parameter list including the Monte-Carlo test,  {<numeric_1D_array>}
##   .Nvar  ... variation length array [1 x Nlvl], [<uint>]
##   .resRM ... variation result matrix [r_vds.Ntot x r_vds.Nres], [[<dbl>]]
##   .resIM ... variation parameter index matrix [r_vds.Ntot x r_vds.Nres], [[<uint>]]
##
## Note: The Monte-Carlo test is added to all other variation levels (max levels = 6).
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
function [r_vds] = var_param5mc(p_fn, p_cp, p_vp, p_mc)
  
  ## check arguments
  if (nargin < 4)
    help var_param5mc;
    error('Less arguments given!');
  endif
  
  ## check variation levels
  Nlvl = length(p_vp) + 1; # add Monte-Carlo test
  Nvar = zeros(1, Nlvl);
  Nvar(Nlvl) = p_mc;
  for j = 1 : (Nlvl - 1)
    Nvar(j) = length(p_vp{j});
  endfor
  Ntot = prod(Nvar);
  
  ## Monte-Carlo index
  imc = transpose([1 : p_mc]);
  
  ## Result matrix column index
  nrescol = feval(p_fn);
  iRM = 1 : nrescol;
  iIM = 1 : Nlvl;
  
  ## init variation result data structure
  r_vds = [];
  r_vds.Nlvl = Nlvl; # variation levels, variation depth without Monte-Carlo test
  r_vds.Ntot = Ntot; # total number of variations
  r_vds.Nres = nrescol; # number of results per variation
  r_vds.cpar = p_cp; # constant parameter list
  r_vds.vpar = [p_vp, transpose(imc)]; # variation parameter list, add Monte-Carlo test
  r_vds.Nvar = Nvar; # variation length array [1 x Nlvl]
  r_vds.resRM = zeros(r_vds.Ntot, r_vds.Nres); # variation result matrix
  r_vds.resIM = zeros(r_vds.Ntot, r_vds.Nlvl); # variation parameter index matrix
  
  ## switch variation levels
  switch (r_vds.Nlvl)
    case 1
      ## variation, MC only
      printf('MC (%d steps)\n', r_vds.Nvar(1));
      r_vds.resRM(1 : p_mc, iRM) = feval(p_fn, p_cp, [], p_mc);
      r_vds.resIM(1 : p_mc, iIM) = [imc];
    case 2
      ## variation, 1 parameter + MC
      cnt = 1;
      printf('var_1: %d steps, MC: %d turns\n', r_vds.Nvar(1 : 2));
      for i1 = 1 : r_vds.Nvar(1)
        parlst = [r_vds.vpar{1}(i1)];
        ilst = repmat(i1, p_mc, 1);
        cnt1 = cnt + p_mc - 1;
        r_vds.resRM(cnt : cnt1, iRM) = feval(p_fn, p_cp, parlst, p_mc);
        r_vds.resIM(cnt : cnt1, iIM) = [ilst, imc];
        cnt += p_mc;
      endfor
    case 3
      ## variation, 2 parameters + MC
      cnt = 1;
      for i1 = 1 : r_vds.Nvar(1)
        printf('var_1: %d / %d, var_2: %d steps, MC: %d turns\n', i1, r_vds.Nvar(1 : 3));
        for i2 = 1 : r_vds.Nvar(2)
          parlst = [r_vds.vpar{1}(i1), r_vds.vpar{2}(i2)];
          ilst = repmat([i1, i2], p_mc, 1);
          cnt1 = cnt + p_mc - 1;
          r_vds.resRM(cnt : cnt1, iRM) = feval(p_fn, p_cp, parlst, p_mc);
          r_vds.resIM(cnt : cnt1, iIM) = [ilst, imc];
          cnt += p_mc;
        endfor
      endfor
    case 4
      ## variation, 3 parameters + MC
      cnt = 1;
      for i1 = 1 : r_vds.Nvar(1)
        for i2 = 1 : r_vds.Nvar(2)
          printf('var_1: %d / %d, var_2: %d / %d, var_3: %d steps, MC: %d turns\n', i1, r_vds.Nvar(1), i2, r_vds.Nvar(2 : 4));
          for i3 = 1 : r_vds.Nvar(3)
            parlst = [r_vds.vpar{1}(i1), r_vds.vpar{2}(i2), r_vds.vpar{3}(i3)];
            ilst = repmat([i1, i2, i3], p_mc, 1);
            cnt1 = cnt + p_mc - 1;
            r_vds.resRM(cnt : cnt1, iRM) = feval(p_fn, p_cp, parlst, p_mc);
            r_vds.resIM(cnt : cnt1, iIM) = [ilst, imc];
            cnt += p_mc;
          endfor
        endfor
      endfor
    case 5
      ## variation, 4 parameters + MC
      cnt = 1;
      for i1 = 1 : r_vds.Nvar(1)
        for i2 = 1 : r_vds.Nvar(2)
          for i3 = 1 : r_vds.Nvar(3)
            printf('var_1: %d / %d, var_2: %d / %d, var_3: %d / %d, var_4: %d steps, MC: %d turns\n', ...
              i1, r_vds.Nvar(1), i2, r_vds.Nvar(2), i3, r_vds.Nvar(3), r_vds.Nvar(4 : 5));
            for i4 = 1 : r_vds.Nvar(4)
              parlst = [r_vds.vpar{1}(i1), r_vds.vpar{2}(i2), r_vds.vpar{3}(i3), r_vds.vpar{4}(i4)];
              ilst = repmat([i1, i2, i3, i4], p_mc, 1);
              cnt1 = cnt + p_mc - 1;
              r_vds.resRM(cnt : cnt1, iRM) = feval(p_fn, p_cp, parlst, p_mc);
              r_vds.resIM(cnt : cnt1, iIM) = [ilst, imc];
              cnt += p_mc;
            endfor
          endfor
        endfor
      endfor
    case 6
      ## variation, 5 parameters + MC
      cnt = 1;
      for i1 = 1 : r_vds.Nvar(1)
        for i2 = 1 : r_vds.Nvar(2)
          for i3 = 1 : r_vds.Nvar(3)
            for i4 = 1 : r_vds.Nvar(4)
              printf('var_1: %d / %d, var_2: %d / %d, var_3: %d / %d, var_4: %d / %d, var_5: %d steps, MC: %d turns\n', ...
                i1, r_vds.Nvar(1), i2, r_vds.Nvar(2), i3, r_vds.Nvar(3), i4, r_vds.Nvar(4), r_vds.Nvar(5 : 6));
              for i5 = 1 : r_vds.Nvar(5)
                parlst = [r_vds.vpar{1}(i1), r_vds.vpar{2}(i2), r_vds.vpar{3}(i3), r_vds.vpar{4}(i4), r_vds.vpar{5}(i5)];
                ilst = repmat([i1, i2, i3, i4, i5], p_mc, 1);
                cnt1 = cnt + p_mc - 1;
                r_vds.resRM(cnt : cnt1, iRM) = feval(p_fn, p_cp, parlst, p_mc);
                r_vds.resIM(cnt : cnt1, iIM) = [ilst, imc];
                cnt += p_mc;
              endfor
            endfor
          endfor
        endfor
      endfor
  endswitch
  
endfunction
