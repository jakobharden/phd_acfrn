## Plot series of labels, horizontal or vertical distribution
##
## Usage: [r_ht] = tool_plot_labelseries(p_ah, p_dm, p_c, p_cc, p_vv, p_tfs, p_tfc, p_tpr, p_tha, p_tva)
##
## p_ah  ... axes handle, <dbl>
## p_dm  ... direction mode ('horz', 'vert'), see below, <str>
## p_c   ... common x or y coordinte of all labels, <dbl>
## p_cc  ... x or y coordinate array, see note below, [<dbl>]
## p_vv  ... label value list, optional, default = p_yy, [<dbl>]
## p_tfs ... label text font size, optional, default = axes fontsize, <uint>
## p_tfc ... label text forecolor [r, g, b], optional, default = [0, 0, 0] (black), [<dbl>]
## p_tpr ... label text precision, optional, default = 1, <uint>
## p_tha ... label text, horizontal alignment, <str>
## p_tva ... label text, vertical alignment, <str>
## r_ht  ... return: label text handles, [<dbl>]
##
## Direction modes:
##   p_dm = 'horz': horizontal direction, p_c is the common y coordinate, p_cc is the array of x coordinates
##   p_dm = 'vert': vertical direction, p_c is the common x coordinate, p_cc is the array of y coordinates
##
## Note:
##   If p_cc is a column vector [2 x 1], assume that p_cc holds the start and end value of an equally spaced array.
##
## see also: text
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
function [r_ht] = tool_plot_labelseries(p_ah, p_dm, p_c, p_cc, p_vv, p_tfs, p_tfc, p_tpr, p_tha, p_tva)
  
  ## check arguments
  if (nargin < 10)
    p_tva = [];
  endif
  if (nargin < 9)
    p_tha = [];
  endif
  if (nargin < 8)
    p_tpr = [];
  endif
  if (nargin < 7)
    p_tfc = [];
  endif
  if (nargin < 6)
    p_tfs = [];
  endif
  if (nargin < 5)
    help tool_plot_labelseries;
    error('Less arguments given!');
  endif
  if isempty(p_vv)
    help tool_plot_labelseries;
    error('Label value array is empty!');
  endif
  if isempty(p_tva)
    p_tva = 'baseline';
  endif
  if isempty(p_tha)
    p_tha = 'center';
  endif
  if isempty(p_tpr)
    p_tpr = 1; # display first digit after decimal separator
  endif
  if isempty(p_tfc)
    p_tfc = [0, 0, 0]; # label color, black
  endif
  if isempty(p_tfs)
    p_tfs = get(p_ah, 'fontsize'); # get axes fontsize
  endif
  if isempty(p_cc)
    p_cc = 1 : numel(p_vv);
  endif
  if (size(p_cc, 1) == 2)
    ## given: start and end value, equal spaced array
    if (p_cc(2, 1) < p_cc(1, 1))
      p_cc = linspace(p_cc(2, 1) : p_cc(1, 1), numel(p_vv));
    else
      p_cc = linspace(p_cc(1, 1) : p_cc(2, 1), numel(p_vv));
    endif
  endif
  if isempty(p_c)
    p_c = 0;
  endif
  if isempty(p_dm)
    p_dm = 'horz';
  endif
  if isempty(p_ah)
    fh = figure();
    p_ah = axes(fh);
  endif
  
  ## setup format string
  lfmt = ['%.', num2str(p_tpr), 'f'];
  
  ## iterate over label series
  r_ht = zeros(numel(p_vv), 1);
  for j = 1 : numel(p_vv)
    lblstr = sprintf(lfmt, p_vv(j));
    switch (lower(p_dm))
      case {'horz', 'horizontal', 'hor', 'h', 'x'}
        lx = p_cc(j);
        ly = p_c;
      otherwise
        lx = p_c;
        ly = p_cc(j);
    endswitch
    r_ht(j) = text(p_ah, lx, ly, lblstr, 'horizontalalignment', p_tha, 'verticalalignment', p_tva, 'fontsize', p_tfs, 'color', p_tfc);
  endfor
  
endfunction
