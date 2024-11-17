## Serialize array variable to TeX code (comma-separated list, e.g. version numbers)
##
## FUNCTION SYNOPSIS:
##
## Usage 1: [r_tc] = tex_def_csvarray(p_ss, p_vn, p_vt, p_vv, p_tc)
##                     non-interactive mode
##                     update existing TeX code listing
##
## Usage 2: [r_tc] = tex_def_csvarray(p_ss, p_vn, p_vt, p_vv, [])
##          [r_tc] = tex_def_csvarray(p_ss, p_vn, p_vt, p_vv)
##                     non-interactive mode
##                     return TeX code for variable only
##
## Usage 3: [r_tc] = tex_def_csvarray([], p_vn, p_vt, p_vv, p_tc)
##                     non-interactive mode
##                     load default TeX serialization settings (see tex_settings.m)
##
## p_ss ... serialization settings data structure, <struct_tex_settings>
## p_vn ... variable name, <str>
## p_vt ... variable type enumerator, <str>
## p_vv ... variable value, [<int>] or {<string>}
## p_tc ... TeX code listing to be updated, optional, {<str>}
## r_tc ... return: TeX code listing (usage 1) or TeX code for variable (usage 2), {<str>} or <str>
##
## see also: tex_settings.m, tex_serialize.m
##
## Copyright 2023 Jakob Harden (jakob.harden@tugraz.at, Graz University of Technology, Graz, Austria)
## License: MIT
## This file is part of the PhD thesis of Jakob Harden.
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
## documentation files (the “Software”), to deal in the Software without restriction, including without 
## limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of 
## the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
## 
## THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
## THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##
function [r_tc] = tex_def_csvarray(p_ss, p_vn, p_vt, p_vv, p_tc)
  
  ## check arguments
  if (nargin < 4)
    help tex_def_csvarray;
    error('Less arguments given!');
  endif
  if (nargin < 5)
    append_list = false;
  else
    append_list = true;
  endif
  
  ## set default values
  if isempty(p_ss)
    p_ss = tex_settings();
  endif
  
  ## render TeX code
  if isempty(p_vv)
    if append_list
      r_tc = p_tc;
    else
      r_tc = '';
    endif
  else
    ## serialize array
    carr = cell(1, numel(p_vv));
    if iscellstr(p_vv)
      for i = 1 : numel(p_vv)
        carr(i) = tex_serialize(p_ss, p_vt, p_vv{i});
      endfor
    else
      for i = 1 : numel(p_vv)
        carr(i) = tex_serialize(p_ss, p_vt, p_vv(i));
      endfor
    endif
    ## create TeX code
    cmd1 = sprintf([p_ss.ser.cmd_pfx, ' %s', p_ss.ser.cmd_sfx], p_vn);
    cmd2 = ['{', strjoin(carr, '.'), '}'];
    tc = [cmd1, cmd2];
    if append_list
      ## append result to given list
      r_tc = [p_tc; tc];
    else
      ## return result only
      r_tc = tc;
    endif
  endif
  
endfunction