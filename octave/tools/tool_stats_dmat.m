## Compute statistics for a 2D data matrix
##
## Usage: [r_sm] = tool_stats_dmat(p_vm, p_em, p_rs)
##
## p_vm ... data matrix (e.g. computation results from a parameter variation), [Nrow x Ncol], [[<dbl>]]
## p_em ... evaluation mode, optional, default = [], <str>
## p_rs ... result selection index, optional, default = [1, 6, 8, 2, 3], [<uint>]
## r_sm ... statistics matrix, [[<dbl>]]
##
## Evaluation modes:
##   p_em = 'row': row-wise stats, r_sm = [Nrow x 10]
##   p_em = 'col': column-wise stats, r_sm = [10 x Ncol]
##   p_em = 'mat': matrix-wise stats (compute stats w.r.t. matrix elements), r_sm = [10 x 1]
##   p_em = []:    operate on first non-singleton dimension of matrix, default GNU Octave behaviour
##                 if matrix is a row vector: r_sm = [10 x 1]
##                 if matrix is not a row vector: r_sm = [10 x Ncol]
##
## Statistical value index (row index if p_em = 'col' or 'mat' or []; column index if p_em = 'row'):
##   1  = median
##   2  = min
##   3  = max
##   4  = quantile 0
##   5  = quantile 5 %
##   6  = quantile 25 %
##   7  = quantile 50 %
##   8  = quantile 75 %
##   9  = quantile 95 %
##   10  = quantile 100 %
##   11  = mean
##   12 = std
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
function [r_sm] = tool_stats_dmat(p_vm, p_em, p_rs)
  
  ## check arguments
  if (nargin < 3)
    p_rs = [];
  endif
  if (nargin < 2)
    p_em = [];
  endif
  if (nargin < 1)
    help tool_stats_vmat;
    error('less arguments given!');
  endif
  if isempty(p_vm)
    tool_stats_vmat
    error('Data matrix is empty!');
  endif
  if isempty(p_rs)
    p_rs = [1, 6, 8, 2, 3];
  endif
  if isempty(p_em)
    p_em = '1st_nonsingleton_dimension';
  endif
  
  ## quantile limits
  qlim = [0.00, 0.05, 0.25, 0.50, 0.75, 0.95, 1.00]; # percent / 100
  
  ## switch evaluation mode
  switch (p_em)
    case {'col', 'column'}
      ## evaluate stats column-wise
      r_sm = zeros(10, size(p_vm, 2));
      r_sm(1, :) = median(p_vm, 1);
      r_sm(2, :) = min(p_vm, [], 1);
      r_sm(3, :) = max(p_vm, [], 1);
      r_sm(4 : 10, :) = quantile(p_vm, qlim, 1);
      r_sm(11, :) = mean(p_vm, 1);
      r_sm(12, :) = std(p_vm, 0, 1);
    case {'row'}
      ## evaluate stats row-wise
      r_sm = zeros(size(p_vm, 1), 10);
      r_sm(:, 1) = median(p_vm, 2);
      r_sm(:, 2) = min(p_vm, [], 2);
      r_sm(:, 3) = max(p_vm, [], 2);
      r_sm(:, 4 : 10) = quantile(p_vm, qlim, 2);
      r_sm(:, 11) = mean(p_vm, 2);
      r_sm(:, 12) = std(p_vm, 0, 2);
    case {'mat', 'matrix'}
      ## evaluate stats along both dimensions (entire matrix)
      r_sm = zeros(10, 1);
      cvec = p_vm(:); # column vector
      r_sm(1) = median(cvec);
      r_sm(2) = min(cvec);
      r_sm(3) = max(cvec);
      r_sm(4 : 10) = quantile(cvec, qlim);
      r_sm(11) = mean(cvec);
      r_sm(12) = std(cvec);
    otherwise
      ## evaluate stats along the first non-singleton dimension, default GNU Octave behaviour
      if (size(p_vm, 1) == 1)
        p_vm = p_vm(:);
      endif
      r_sm = zeros(10, size(p_vm, 2));
      r_sm(1, :) = median(p_vm);
      r_sm(2, :) = min(p_vm);
      r_sm(3, :) = max(p_vm);
      r_sm(4 : 10, :) = quantile(p_vm, qlim);
      r_sm(11, :) = mean(p_vm);
      r_sm(12, :) = std(p_vm);
  endswitch
  
  ## select results
  if not(isempty(p_rs))
    switch (p_em)
      case 'row'
        r_sm = r_sm(:, p_rs);
      otherwise
        r_sm = r_sm(p_rs, :);
    endswitch
  endif
  
endfunction
