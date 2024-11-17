## Plot groups of labels, horizontal or vertical distribution
##
## Usage: [r_ht, r_hl] = tool_plot_labelgroups(p_ah, p_dm, p_c, p_cc, p_vv, p_gw, p_tfs, p_tfc, p_tpr, p_tha, p_tva, p_ls, p_lw, p_lc)
##
## p_ah  ... axes handle, <dbl>
## p_dm  ... direction mode ('horz', 'vert'), see below, <str>
## p_c   ... common x or y coordinte of all labels and lines [label_coord, line_coord], [<dbl>]
## p_cc  ... x or y coordinate array, see note below, [<dbl>]
## p_vv  ... label value list, optional, default = p_yy, [<dbl>]
## p_gw  ... group width, <dbl>
## p_tfs ... label text font size, optional, default = axes fontsize, <uint>
## p_tfc ... label text forecolor [r, g, b], optional, default = [0, 0, 0] (black), [<dbl>]
## p_tpr ... label text precision, optional, default = 1, <uint>
## p_tha ... label text, horizontal alignment, optional, default = 'center', <str>
## p_tva ... label text, vertical alignment, optional, default = 'middle', <str>
## p_ls  ... line style, optional, default = '-', <str>
## p_lw  ... line width, optional, default = 1, <dbl>
## p_lc  ... line color [r, g, b], optional, default = [0.5, 0.5, 0.5] (gray), [<dbl>]
## r_ht  ... return: label text handles, [<dbl>]
## r_hl  ... return: line handles, [<dbl>]
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
function [r_ht, r_hl] = tool_plot_labelgroups(p_ah, p_dm, p_c, p_cc, p_vv, p_gw, p_tfs, p_tfc, p_tpr, p_tha, p_tva, p_ls, p_lw, p_lc)
  
  ## check arguments
  if (nargin < 14)
    p_ls = [];
  endif
  if (nargin < 13)
    p_lw = [];
  endif
  if (nargin < 12)
    p_lc = [];
  endif
  if (nargin < 11)
    p_tva = [];
  endif
  if (nargin < 10)
    p_tha = [];
  endif
  if (nargin < 9)
    p_tpr = [];
  endif
  if (nargin < 8)
    p_tfc = [];
  endif
  if (nargin < 7)
    p_tfs = [];
  endif
  if (nargin < 6)
    p_gw = [];
  endif
  if (nargin < 5)
    help tool_plot_labelgroups;
    error('Less arguments given!');
  endif
  if isempty(p_vv)
    help tool_plot_labelgroups;
    error('Label value array is empty!');
  endif
  if isempty(p_ls)
    p_ls = '-';
  endif
  if isempty(p_lw)
    p_lw = 1;
  endif
  if isempty(p_lc)
    p_lc = [1, 1, 1] * 0.5;
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
  if isempty(p_gw)
    p_gw = 1;
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
    p_c = [0, 0.25];
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
  r_hl = zeros(numel(p_vv), 1);
  for j = 1 : numel(p_vv)
    lblstr = sprintf(lfmt, p_vv(j));
    switch (lower(p_dm))
      case {'horz', 'horizontal', 'hor', 'h', 'x'}
        tx = p_cc(j);
        ty = p_c(1);
        lx = [-p_gw, p_gw] * 0.5 + tx;
        ly = [1, 1] * p_c(2);
      otherwise
        tx = p_c(1);
        ty = p_cc(j);
        lx = [1, 1] * p_c(2);
        ly = [-p_gw, p_gw] * 0.5 + ty;
    endswitch
    r_ht(j) = text(p_ah, tx, ty, lblstr, 'horizontalalignment', p_tha, 'verticalalignment', p_tva, 'fontsize', p_tfs, 'color', p_tfc);
    r_hl(j) = plot(p_ah, lx, ly, 'linestyle', p_ls, 'linewidth', p_lw, 'color', p_lc, 'handlevisibility', 'off');
  endfor
  
endfunction
