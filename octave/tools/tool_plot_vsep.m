## Plot vertical separator lines with labels
##
## Usage: [r_hl, r_ht] = tool_plot_vsep(p_ah, p_xx, p_vv, p_tpf, p_tsf, p_tfs, p_tfc, p_tpr, p_slt, p_slw, p_slc)
##
## p_ah  ... axes handle, <dbl>
## p_xx  ... separator x coordinate list, [<dbl>]
## p_vv  ... separator value list, optional, default = p_xx, [<dbl>]
## p_tpf ... label text prefix, optional, default = "", <str>
## p_tsf ... label text suffix, optional, default = "", <str>
## p_tfs ... label text font size, optional, default = 10, <uint>
## p_tfc ... label text forecolor [r, g, b], optional, default = [0,0 0] (black), [<dbl>]
## p_tpr ... label text precision, optional, default = 2, <uint>
## p_tpo ... label text position (0 to 1), optional, default = 0.98, <dbl>
## p_slt ... separator line type, optional, default = "--" (dashed), <str>
## p_slw ... separator line width, optional, default = 1, <dbl>
## p_slc ... separator line color [r, g, b], optional, default = [0,0,0] (black), [<dbl>]
## r_hl  ... return: separator line handle, <dbl>
## r_ht  ... return: label text handle, <dbl>
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
function [r_hl, r_ht] = tool_plot_vsep(p_ah, p_xx, p_vv, p_tpf, p_tsf, p_tfs, p_tfc, p_tpr, p_tpo, p_slt, p_slw, p_slc)
  
  ## check arguments
  if (nargin < 12)
    p_slc = [];
  endif
  if (nargin < 11)
    p_slw = [];
  endif
  if (nargin < 10)
    p_slt = [];
  endif
  if (nargin < 9)
    p_tpo = [];
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
    p_tsf = [];
  endif
  if (nargin < 4)
    p_tpf = [];
  endif
  if (nargin < 3)
    p_vv = [];
  endif
  if isempty(p_slc)
    p_slc = [0, 0, 0];
  endif
  if isempty(p_slw)
    p_slw = 0.5;
  endif
  if isempty(p_slt)
    p_slt = '--';
  endif
  if isempty(p_tpo)
    p_tpo = 0.98;
  endif
  if isempty(p_tpr)
    p_tpr = 2;
  endif
  if isempty(p_tfc)
    p_tfc = [0, 0, 0];
  endif
  if isempty(p_tfs)
    p_tfs = 10;
  endif
  if isempty(p_tsf)
    p_tsf = '';
  endif
  if isempty(p_tpf)
    p_tpf = '';
  endif
  if isempty(p_vv)
    p_vv = p_xx;
  endif
  
  ## iterate over separator line coordinate list
  for j = 1 : length(p_xx)
    ## axes y limits
    a_ylim = ylim(p_ah);
    ## y coordinates
    y0 = a_ylim(1);
    y1 = a_ylim(2);
    yl = y0 + (y1 - y0) * p_tpo;
    ## setup label text
    if isempty(p_tpf)
      pfx = '';
    else
      pfx = [p_tpf, ' = '];
    endif
    if isempty(p_tsf)
      sfx = '';
    else
      sfx = [' ', p_tsf];
    endif
    fmtstr = ['%s', '%.', sprintf('%d', p_tpr), 'f', '%s'];
    lblstr = sprintf(fmtstr, pfx, p_vv(j), sfx);
    ## plot separator line
    r_hl(j) = plot(p_ah, [1, 1] * p_xx(j), [y0, y1], p_slt, 'linewidth', p_slw, 'color', p_slc, 'handlevisibility', 'off');
    ## plot label text
    if (j < length(p_xx))
      halign = 'left';
      lblstr = [' ', lblstr];
    else
      halign = 'right';
      lblstr = [lblstr, ' '];
    endif
    if (p_tpo <= 0.02)
      valign = 'bottom';
    elseif (p_tpo >= 0.98)
      valign = 'top';
    else
      valign = 'middle';
    endif
    r_ht(j) = text(p_ah, p_xx(j), yl, lblstr, 'horizontalalignment', halign, 'verticalalignment', valign, 'fontsize', p_tfs, 'color', p_tfc);
  endfor
  
endfunction
