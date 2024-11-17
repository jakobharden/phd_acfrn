## Test: Estimate auto-correlation function (ACF) with reduced impact of noise for sinusoidal low-pass signals
##
## Usage: test_acfrn(p_rm)
##
## p_rm ... run mode (see below), optional, default = 'sig', <str>
##
## Run modes:
##   p_rm = 'pvar':   compute parameter variation
##   p_rm = 'stats1': plot parameter variation stats, relative error vs. signal length, method comparison
##   p_rm = 'stats2': plot parameter variation stats, error distribution, method comparison
##   p_rm = 'sig':    plot synthetic test signals
##   p_rm = 'acf':    compute/plot ACF examples
##   p_rm = 'nat':    compute/plot application examples, natural signals
##
## Signal model: see tool_gen_sinusoidal1
##
## see also: tool_gen_noise, tool_gen_sinusoidal1, tool_scale_noise2snr, tool_est_acfrn, var_param5mc, wrapper_acfrn_pvar,
##           tool_plot_errorbar_extended, tool_plot_perfassmat, tool_stats_dmat
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
function test_acfrn(p_rm)
  
  ## check arguments
  if (nargin < 1)
    p_rm = 'sig';
  endif
  
  ## result directory path
  rpath = './results/test_acfrn';
  
  ## dataset path and file name
  dspath = '/home/harden/Documents/tugraz/0_test_series/ts1_cem1_paste/oct';
  dsfname = 'ts1_wc040_d70_1.oct'; # cement paste test, w/c ratio 0.4, distance 70mm, turn 1
  
  ## Constant parameters
  c_A0 = 1; # V, default signal amplitude
  c_acf_mode = 'unbiased'; # default ACF mode
  c_nrm_mode = 'm0'; # noise reduction mode
  
  ## Variation parameters
  v_DF = [0, 2, 4]; # decay factor DF is related to signal length N = Ncy * N1
  v_SNR = [5, 10, 15, 20]; # signal-to-noise ratio, dB (SNR)
  v_N1 = 2.^([6, 8, 10, 12]); # signal period variation
  v_NCY = linspace(1, 5, 81); # signal period cycle variation
  Nmc = 500; # Monte-Carlo test turns
  
  ## plot settings structure
  ps.rpath = rpath;
  ps.xlbl = 'N = N1 * Ncy'; # x axis label
  ps.xunit = '#'; # x axis unit
  ps.ylbl = 'Relative error'; # y axis label
  ps.yunit = '%'; # y axis unit
  ps.tit1 = 'Signal power Ps'; # title, method 1
  ps.tit2 = 'Signal-to-noise ratio SNR'; # title, method 2
  ps.le1s = 'M1'; # legend, short text, method 1
  ps.le2s = 'M2'; # legend, short text, method 2
  ps.le1l = 'Method 1'; # legend, long text, method 1
  ps.le2l = 'Method 2'; # legend, long text, method 2
  ps.lc1 = [1, 1, 1] * 0.5; # line color, method 1
  ps.lc2 = [0.1, 0.1, 0.75]; # line color, method 2
  ps.lc3 = [1, 1, 1] * 0.2; # line color, separator lines
  ps.lc_x = [1, 1, 1] * 0.5; # gray, line color, signal in noise
  ps.lc_s = [0.654902, 0.027451, 0.254902]; # dark magenta, line color, signal
  ps.lw1 = [1, 0.5, 0.5]; # line width, method 1
  ps.lw2 = [2, 1, 1]; # line width, method 2
  ps.lw_s = 2; # line width, signal
  ps.lw_x = 0.5; # line width, signal in noise
  ps.cylim = floor(v_NCY(1) : 1 : v_NCY(end)); # cycle limits
  ps.errlim = [5, 10]; # 5 and 10 percent error limit
  ps.boxsep = [0.5, 0.25]; # box separator, [dist_to_y_axis, dist_between_groups]
  ps.boxshp = 'box'; # box shape
  ps.boxwid = [0.5, 0.25, 0.1]; # box width
  ps.boxlw = [1.5, 1]; # box line widths [major, minor]
  ## performance assessment
  ps.pa_boxsz = [1, 1] * 0.8; # matrix box size [width, height]
  ps.pa_legsz = [1.5, 0.5]; # legend box size [width, width]
  ps.pa_bcols = [[0.8, 1, 0.8]; [1, 0.86, 0.73]; [1, 0.8, 0.8]]; # background colors, green/orange/red
  ps.pa_fcols = [[0, 0, 0]; [0, 0, 0]; [1, 0, 0]]; # foreground colors, black/black/red
  ps.pa_scol = [1, 1, 1] * 0.5; # group separator color, gray 50%
  
  ## Generate/load standard noise (for reproducibility reasons)
  Nmax = max(v_N1) * max(v_NCY); # max number of samples
  vv_mat = tool_gen_noise(Nmax, Nmc, 1, rpath);
  
  ## constant parameter list
  c_par = {c_acf_mode, c_nrm_mode, c_A0, vv_mat};
  
  ## variation parameter list (+ Monte-Carlo test)
  v_par = {v_N1, v_DF, v_SNR, v_NCY};
  
  ## select run mode
  switch (p_rm)
    case 'pvar'
      ## compute variation
      ads = var_param5mc('wrapper_acfrn_pvar', c_par, v_par, Nmc);
      save('-binary', fullfile(rpath, sprintf('var_%s.oct', c_acf_mode)), 'ads');
    case 'stats1'
      ## plot variation stats 1
      ads = load(fullfile(rpath, sprintf('var_%s.oct', c_acf_mode)), 'ads').ads;
      test_acfrn_stats1(ads, ps);
    case 'stats2'
      ## plot variation stats 2
      ads = load(fullfile(rpath, sprintf('var_%s.oct', c_acf_mode)), 'ads').ads;
      test_acfrn_stats2(ads, ps);
    case 'stats3'
      ## performance stats
      ads = load(fullfile(rpath, sprintf('var_%s.oct', c_acf_mode)), 'ads').ads;
      test_acfrn_stats3(ads, ps, 'MAX', ps.errlim);
      test_acfrn_stats3(ads, ps, 'Q95', ps.errlim);
      test_acfrn_stats3(ads, ps, 'Q3', ps.errlim);
    case 'nat'
      ## application examples
      nat_dsfp = fullfile(dspath, dsfname);
      nat_cid = 1; # channel id, P-wave
      ## signal 1
      nat_sid = 288; # signal id, maturity 24h
      nat_lim = [1222, 1319]; # window limits
      test_acfrn_nat(ps, nat_dsfp, nat_cid, nat_sid, nat_lim);
      ## signal 2
      nat_sid = 50; # signal id, maturity 4.2h
      nat_lim = [1462, 1878]; # window limits
      test_acfrn_nat(ps, nat_dsfp, nat_cid, nat_sid, nat_lim);
      ## signal 3
      nat_sid = 20; # signal id, maturity 1.7h
      nat_lim = [1930, 5030]; # window limits
      test_acfrn_nat(ps, nat_dsfp, nat_cid, nat_sid, nat_lim);
    case 'sig'
      ## plot signals
      ## signal parameters
      N1 = 2^10; # period, number of samples
      NCY = 3; # cycles, number of periods
      A0 = 1; # signal amplitude, V
      DF = [0, 2, 4]; # exponential decay factors
      SNR = [5, 10, 20]; # signal-to-noise ratios, dB
      test_acfrn_sig(ps, N1, NCY, A0, DF, SNR, vv_mat, rpath);
    case 'acf'
      ## plot ACF with reduced impact of noise
      ## signal parameters
      N1 = 2^10; # period, number of samples
      NCY = 3; # cycles#, number of periods
      A0 = 1; # amplitude, V
      DF = [0, 2, 4]; # exponential decay factors
      SNR = [5, 10, 20]; # signal-to-noise ratios, dB
      test_acfrn_acf(ps, N1, NCY, A0, DF, SNR, vv_mat, c_acf_mode, c_nrm_mode, rpath);
  endswitch
  
endfunction


function test_acfrn_stats1(p_ads, p_ps)
  ## Plot variation results
  ##
  ## p_ads ... analysis result data structure, <struct>
  ## p_ps  ... plot settings structure, <struct>
  
  ## const_par = {c_acf_mode, c_nrm_mode, c_A0, vv_mat}
  c_acf_mode = p_ads.cpar{1};
  c_nrm_mode = p_ads.cpar{2};
  c_A0 = p_ads.cpar{3};
  
  ## var_par = [v_N1, v_DF, v_SNR, v_NCY, v_idxMC]
  v_N1 = p_ads.vpar{1};
  v_DF = p_ads.vpar{2};
  v_SNR = p_ads.vpar{3};
  v_NCY = p_ads.vpar{4};
  v_idxMC = p_ads.vpar{5};
  
  ## loop over period N1
  for i1 = 1 : p_ads.Nvar(1)
    N1 = v_N1(i1);
    idx1 = find(p_ads.resIM(:, 1) == i1);
    ## loop over DF
    for i2 = 1 : p_ads.Nvar(2)
      DF = v_DF(i2);
      idx2 = find(p_ads.resIM(idx1, 2) == i2) + idx1(1) - 1;
      ## loop over SNR
      for i3 = 1 : p_ads.Nvar(3)
        SNR = v_SNR(i3);
        idx3 = find(p_ads.resIM(idx2, 3) == i3) + idx2(1) - 1;
        ## info string
        istr = sprintf('N1 = %d [#], Ncy = %d,...,%d, DF = %d [1], SNR = %d [dB]', N1, v_NCY(1), v_NCY(end), DF, SNR);
        ## print status message
        printf('Plotting stats: %s\n', istr);
        ## compute stats, columns: 3 = ep1, 4 = ep2, 5 = es1, 6 = es2
        ep1 = reshape(p_ads.resRM(idx3, 3), p_ads.Nvar(5), p_ads.Nvar(4));
        ep2 = reshape(p_ads.resRM(idx3, 4), p_ads.Nvar(5), p_ads.Nvar(4));
        st_ep1 = tool_stats_dmat(ep1, 'col', []) * 100;
        st_ep2 = tool_stats_dmat(ep2, 'col', []) * 100;
        ## abszissa, total number of samples
        xx = v_NCY * N1;
        ## x axis limits
        xl1 = xx(1) - 0.05 * (xx(end) - xx(1));
        xl2 = xx(end) + 0.05 * (xx(end) - xx(1));
        ## create figure
        fh = figure('name', 'Stats1, Ps', 'position', [100, 100, 800, 500]);
        ## create axes
        ah = axes(fh);
        ## begin plot
        hold(ah, 'on');
        ## variation results
        test_acfrn_stats1_detail(ah, xx, st_ep1, p_ps.le1s, p_ps.lc1, p_ps.lw1);
        test_acfrn_stats1_detail(ah, xx, st_ep2, p_ps.le2s, p_ps.lc2, p_ps.lw2);
        ## cycle limits, vertical lines with label
        tool_plot_vsep(ah, p_ps.cylim * N1, p_ps.cylim, 'Ncy', [], 10, p_ps.lc3, 0, 1, [], [], []);
        ## end plot
        hold(ah, 'off');
        ## x limits
        xlim(ah, [xl1, xl2]);
        ## tick mark direction, outwards
        set(ah, 'tickdir', 'out');
        ## labels, title
        xlabel(ah, sprintf('%s [%s]', p_ps.xlbl, p_ps.xunit));
        ylabel(ah, sprintf('%s [%s]', p_ps.ylbl, p_ps.yunit));
        title(ah, sprintf('%s\n%s', p_ps.tit1, istr));
        ## legend
        legend(ah, 'box', 'off', 'location', 'southoutside', 'orientation', 'horizontal', 'numcolumns', 5);
        ## add copyright information
        #annotation("textbox", [0, 0, 100, 10], 'string', 'Copyright 2024 Jakob Harden', 'linestyle', 'none', 'fontsize', 8);
        ## save figure
        ofn_pfx = sprintf('stats1_%s_N1_%d_DF_%d_SNR_%d', c_acf_mode, N1, DF, SNR);
        hgsave(fh, fullfile(p_ps.rpath, sprintf('%s.ofig', ofn_pfx)));
        saveas(fh, fullfile(p_ps.rpath, sprintf('%s.png', ofn_pfx)), 'png');
        close(fh);
      endfor
    endfor
  endfor

endfunction


function test_acfrn_stats1_detail(p_ah, p_xx, p_sm, p_pn, p_lc, p_lw)
  ## Plot distribution lines
  ##
  ## p_ah ... axes handle, <dbl>
  ## p_xx ... x axis value array, [<dbl>]
  ## p_sm ... stats matrix [5 x N], [[<dbl>]]
  ## p_pn ... property name (legend), <str>
  ## p_lc ... line color string or RGB triple, <str> or [<dbl>, <dbl>, <dbl>]
  ## p_lw ... line width [lw_major, lw_minor], [<dbl>, <dbl>]
  
  plot(p_ah, p_xx, p_sm(1, :), sprintf('-;%s, med;', p_pn), 'linewidth', p_lw(1), 'color', p_lc);
  plot(p_ah, p_xx, p_sm(2, :), sprintf('--;%s, Q1;', p_pn), 'linewidth', p_lw(2), 'color', p_lc);
  plot(p_ah, p_xx, p_sm(3, :), sprintf('--;%s, Q3;', p_pn), 'linewidth', p_lw(2), 'color', p_lc);
  plot(p_ah, p_xx, p_sm(4, :), sprintf(':;%s, min;', p_pn), 'linewidth', p_lw(2), 'color', p_lc);
  plot(p_ah, p_xx, p_sm(5, :), sprintf(':;%s, max;', p_pn), 'linewidth', p_lw(2), 'color', p_lc);
  
endfunction


function test_acfrn_stats2(p_ads, p_ps)
  ## Plot distribution comparison
  ##
  ## p_ads ... analysis result data stricture, <struct>
  ## p_ps  ... plot settings structure, <struct>
  
  ## const_par = {c_acf_mode, c_nrm_mode, c_A0, vv_mat}
  c_acf_mode = p_ads.cpar{1};
  c_nrm_mode = p_ads.cpar{2};
  c_A0 = p_ads.cpar{3};
  
  ## var_par = [v_N1, v_DF, v_SNR, v_NCY, v_idxMC]
  v_N1 = p_ads.vpar{1};
  v_DF = p_ads.vpar{2};
  v_SNR = p_ads.vpar{3};
  v_NCY = p_ads.vpar{4};
  v_idxMC = p_ads.vpar{5};
  
  ## update plot settings
  p_ps.v_grp1 = v_DF;
  p_ps.v_grp2 = v_SNR;
  
  ## loop over period N1
  for i1 = 1 : p_ads.Nvar(1)
    N1 = v_N1(i1);
    idx1 = find(p_ads.resIM(:, 1) == i1);
    ## init group-wise stats
    Ngrp = p_ads.Nvar(2) * p_ads.Nvar(3);
    gst_ep1 = zeros(Ngrp, 5);
    gst_ep2 = zeros(Ngrp, 5);
    gst_idx = transpose(reshape([1 : Ngrp], p_ads.Nvar(3), p_ads.Nvar(2)));
    gcnt = 1;
    ## loop over DF
    for i2 = 1 : p_ads.Nvar(2)
      DF = v_DF(i2);
      idx2 = find(p_ads.resIM(idx1, 2) == i2) + idx1(1) - 1;
      ## loop over SNR
      for i3 = 1 : p_ads.Nvar(3)
        SNR = v_SNR(i3);
        idx3 = find(p_ads.resIM(idx2, 3) == i3) + idx2(1) - 1;
        ## compute stats, columns: 3 = ep1, 4 = ep2, 5 = es1, 6 = es2
        gst_ep1(gcnt, 1:5) = transpose(tool_stats_dmat(p_ads.resRM(idx3, 3), 'col', []) * 100);
        gst_ep2(gcnt, 1:5) = transpose(tool_stats_dmat(p_ads.resRM(idx3, 4), 'col', []) * 100);
        gcnt += 1;
      endfor
    endfor
    ## print status message
    printf('Plotting stats: N1 = %d, Ncy = %d,...,%d, Nmc = %d\n', N1, v_NCY(1), v_NCY(end), v_idxMC(end));
    ## update plot settings
    #p_ps.rtp = 'pow';
    p_ps.tit = sprintf('%s (N1 = %d, Ncy = %d,...,%d, Nmc = %d)', p_ps.tit1, N1, v_NCY(1), v_NCY(end), v_idxMC(end));
    ## plot power stats
    fh1 = figure('name', 'Stats2, Ps', 'position', [100, 100, 800, 500]);
    test_acfrn_stats2_detail(fh1, gst_ep1, gst_ep2, gst_idx, p_ps);
    ## save figures
    ofn_pfx = sprintf('stats2_%s_N1_%d', c_acf_mode, N1);
    ofp_fig1 = fullfile(p_ps.rpath, sprintf('%s.ofig', ofn_pfx));
    ofp_png1 = fullfile(p_ps.rpath, sprintf('%s.png', ofn_pfx));
    hgsave(fh1, ofp_fig1);
    saveas(fh1, ofp_png1, 'png');
  endfor
  
endfunction


function test_acfrn_stats2_detail(p_fh, p_y1, p_y2, p_gi, p_ps)
  ## Plot distribution comparison, details
  ## 
  ## p_fh ... figure handle, <uint>
  ## p_y1 ... method 1 stats matrix, [[<dbl>]]
  ## p_y1 ... method 2 stats matrix, [[<dbl>]]
  ## p_gi ... group index [N_group x N_member], [[<uint>]]
  ## p_ps ... plot settings structure, <struct>
  
  ## y max
  ymax = max([p_y1(:, 5); p_y2(:, 5)]);
  
  ## group size
  [Ngrp1, Ngrp2] = size(p_gi);
  
  ## errorbar x coordinates
  x1 = p_ps.boxsep(1) + [0 : 1 : (Ngrp2 - 1)] * (2 + p_ps.boxsep(2));
  x2 = x1 + 1;
  
  ## x tick coordinates and labels
  xtx = mean([x1; x2]);
  xty = -ones(size(xtx)) * ymax * 0.04;
  xtl = num2cell(p_ps.v_grp2);
  
  ah = [];
  for j = 1 : Ngrp1
    ## select group, sub-group index
    gidx = p_gi(j, :);
    ## subplot, axes
    ah(j) = axes(p_fh);
    sph = subplot(1, 3, j, ah(j));
    sp_pos = get(sph, 'position');
    sp_pos(2) = 0.09;
    sp_pos(4) = 0.8;
    set(sph, 'position', sp_pos);
    ## start plot
    hold(ah(j), 'on');
    ## plot errorbars, boxplot
    le1 = [];
    le2 = [];
    if (j == 2)
      le1 = p_ps.le1l;
      le2 = p_ps.le2l;
    endif
    tool_plot_errorbar_extended(ah(j), x1, p_y1(gidx, :), p_ps.boxshp, p_ps.boxlw, p_ps.lc1, [], p_ps.boxwid, le1, true);
    tool_plot_errorbar_extended(ah(j), x2, p_y2(gidx, :), p_ps.boxshp, p_ps.boxlw, p_ps.lc2, [], p_ps.boxwid, le2, true);
    ## plot limit lines
    if (ymax >= p_ps.errlim(1))
      plot(ah(j), [0, x2(end) + p_ps.boxsep(1)], [1, 1] * p_ps.errlim(1), '--k', 'handlevisibility', 'off');
      text(ah(j), x2(end) + p_ps.boxsep(1), p_ps.errlim(1) + ymax * 0.01, sprintf('%d %% limit', p_ps.errlim(1)), 'horizontalalignment', 'right', 'verticalalignment', 'bottom');
    endif
    ## plot errorbar legend
    if (j == 3)
      eleg_dy = ymax * 0.1;
      if ((ymax - p_ps.errlim(1)) > 1)
        eleg_y1 = ymax - eleg_dy;
      else
        eleg_y1 = p_ps.errlim(1) * 0.9 - eleg_dy;
      endif
      eleg_x0 = xtx(end) - p_ps.boxsep(1);
      eleg_x1 = eleg_x0 + p_ps.boxsep(1) * 0.75;
      eleg_y2 = eleg_y1 - 0.5 * eleg_dy;
      eleg_y3 = eleg_y1 + 0.5 * eleg_dy;
      eleg_y4 = eleg_y1 - eleg_dy;
      eleg_y5 = eleg_y1 + eleg_dy;
      tool_plot_errorbar_extended(ah(j), eleg_x0, [eleg_y1, eleg_y2, eleg_y3, eleg_y4, eleg_y5], p_ps.boxshp, p_ps.boxlw, 'k', [], p_ps.boxwid, []);
      text(ah(j), eleg_x1, eleg_y1, 'median', 'horizontalalignment', 'left');
      text(ah(j), eleg_x1, eleg_y2, 'Q1', 'horizontalalignment', 'left');
      text(ah(j), eleg_x1, eleg_y3, 'Q3', 'horizontalalignment', 'left');
      text(ah(j), eleg_x1, eleg_y4, 'min', 'horizontalalignment', 'left');
      text(ah(j), eleg_x1, eleg_y5, 'max', 'horizontalalignment', 'left');
    endif
    ## end plot
    hold(ah(j), 'off');
    ## title
    title(ah(j), sprintf('DF = %d', p_ps.v_grp1(j)));
    ## legend
    if (j == 2)
      #[lh, lhp] = legend(ah(j), 'location', 'north', 'orientation', 'horizontal', 'box', 'off', 'color', 'none');
      [lh, lhp] = legend(ah(j), 'location', 'north', 'box', 'off', 'color', 'none');
    endif
    ## axes limits
    xlim(ah(j), [0, x2(end) + p_ps.boxsep(1)]);
    ylim(ah(j), [0, ymax * 1.05]);
    ## tick mark direction, outwards
    set(ah(j), 'tickdir', 'out');
    ## setup x axis labels
    set(ah(j), 'xtick', []); # remove automatic labels
    text(ah(j), xtx, xty, xtl, 'horizontalalignment', 'center', 'verticalalignment', 'baseline');
    if (j == 1)
      ## x axis legend
      text(ah(j), 0, xty(1), 'SNR [dB]', 'horizontalalignment', 'right', 'verticalalignment', 'baseline');
      ## setup y axis labels
      ylabel(ah(j), sprintf('%s [%s]', p_ps.ylbl, p_ps.yunit));
    endif
  endfor
  
  ## main axes
  ahm = axes(p_fh);
  set(ahm, 'visible', 'off', 'title', p_ps.tit);
  
endfunction


function test_acfrn_stats3(p_ads, p_ps, p_vt, p_vl)
  ## Plot performance assessment matrix
  ##
  ## p_ads ... analysis result data stricture, <struct>
  ## p_ps  ... plot settings structure, <struct>
  ## p_vt  ... value type ('med', 'min', 'max', 'q1', 'q3', 'q05', 'q95'), <dbl>
  ## p_vl  ... value limit(s), <dbl> or [<dbl>]
  
  ## const_par = {c_acf_mode, c_nrm_mode, c_A0, vv_mat}
  c_acf_mode = p_ads.cpar{1};
  
  ## var_par = [v_N1, v_DF, v_SNR, v_NCY, v_idxMC]
  v_N1 = p_ads.vpar{1};
  v_DF = p_ads.vpar{2};
  v_SNR = p_ads.vpar{3};
  v_NCY = p_ads.vpar{4};
  v_idxMC = p_ads.vpar{5};
  
  ## switch value type, select column of stats matrix
  scol = 0;
  switch (p_vt)
    case {'MED', 'med'}
      ## median
      scol = 1;
    case {'MIN', 'min'}
      ## min
      scol = 2;
    case {'MAX', 'max'}
      ## max
      scol = 3;
    case {'Q1', 'q1'}
      ## 25 % quantile
      scol = 6;
    case {'Q3', 'q3'}
      ## 75 % quantile
      scol = 8;
    case {'Q05', 'q05'}
      ## 5 % quantile
      scol = 5;
    case {'Q95', 'q95'}
      ## 95 % quantile
      scol = 9;
  endswitch
  
  ## init group-wise stats
  Ngrp = p_ads.Nvar(1) * p_ads.Nvar(2) * p_ads.Nvar(3);
  gst_ep1 = zeros(Ngrp, 1);
  gst_ep2 = zeros(Ngrp, 1);
  
  ## loop over period N1
  gcnt = 1;
  for i1 = 1 : p_ads.Nvar(1)
    idx1 = find(p_ads.resIM(:, 1) == i1);
    ## loop over DF
    for i2 = 1 : p_ads.Nvar(2)
      idx2 = find(p_ads.resIM(idx1, 2) == i2) + idx1(1) - 1;
      ## loop over SNR
      for i3 = 1 : p_ads.Nvar(3)
        idx3 = find(p_ads.resIM(idx2, 3) == i3) + idx2(1) - 1;
        ## compute stats
        gst_ep1(gcnt) = transpose(tool_stats_dmat(p_ads.resRM(idx3, 3), 'col', scol) * 100);
        gst_ep2(gcnt) = transpose(tool_stats_dmat(p_ads.resRM(idx3, 4), 'col', scol) * 100);
        gcnt += 1;
      endfor
    endfor
  endfor
  
  ## print status message
  printf('Performance assessment: Ncy = %d,...,%d, Nmc = %d\n', v_NCY(1), v_NCY(end), v_idxMC(end));
  
  ## setup statistics matrix
  smat1 = reshape(gst_ep1, p_ads.Nvar(3), p_ads.Nvar(1) * p_ads.Nvar(2)); # method 1
  smat2 = reshape(gst_ep2, p_ads.Nvar(3), p_ads.Nvar(1) * p_ads.Nvar(2)); # method 2
  
  ## update plot settings
  p_ps.pa_vt = p_vt;
  p_ps.pa_vl = p_vl;
  
  ## create figure, method 1
  p_ps.pa_rtp = 1;
  fh = figure('name', 'Stats3, perf, M1', 'position', [100, 100, 800, 500]);
  test_acfrn_stats3_detail(fh, p_ads, p_ps, smat1);
  
  ## save figure
  ofn_pfx = sprintf('stats3_%s_m%d_%s_%d_%d', c_acf_mode, p_ps.pa_rtp, p_vt, p_vl);
  ofp_fig = fullfile(p_ps.rpath, sprintf('%s.ofig', ofn_pfx));
  ofp_png = fullfile(p_ps.rpath, sprintf('%s.png', ofn_pfx));
  hgsave(fh, ofp_fig);
  saveas(fh, ofp_png, 'png');
  close(fh);
  
  ## create figure, method 2
  p_ps.pa_rtp = 2;
  fh = figure('name', 'Stats3, perf, M2', 'position', [100, 100, 800, 500]);
  test_acfrn_stats3_detail(fh, p_ads, p_ps, smat2);
  
  ## save figure
  ofn_pfx = sprintf('stats3_%s_m%d_%s_%d_%d', c_acf_mode, p_ps.pa_rtp, p_vt, p_vl);
  ofp_fig = fullfile(p_ps.rpath, sprintf('%s.ofig', ofn_pfx));
  ofp_png = fullfile(p_ps.rpath, sprintf('%s.png', ofn_pfx));
  hgsave(fh, ofp_fig);
  saveas(fh, ofp_png, 'png');
  close(fh);
  
endfunction


function test_acfrn_stats3_detail(p_fh, p_ads, p_ps, p_sm)
  ## Plot performance assessment matrix, details
  ## 
  ## p_fh  ... figure handle, <uint>
  ## p_ads ... analysis result data structure, <struct>
  ## p_ps  ... plot settings structure, <struct>
  ## p_sm  ... stats matrix, [[<dbl>]]
  
  ## constant parameters
  c_acf_mode = p_ads.cpar{1};
  
  ## variation parameter arrays
  v_N1 = p_ads.vpar{1};
  v_DF = p_ads.vpar{2};
  v_SNR = p_ads.vpar{3};
  
  ## geometry parameters
  dx = p_ps.pa_boxsz(1); dx2 = dx / 2; dx4 = dx / 4;
  dy = p_ps.pa_boxsz(2); dy2 = dy / 2; dy4 = dy / 4;
  legw = p_ps.pa_legsz(1);
  legh = p_ps.pa_legsz(2);
  legy0 = 1;
  legy1 = legy0 + legh * 0.5;
  legxm = p_ads.Nvar(1) * p_ads.Nvar(2) * 0.5;
  legx1 = [-legw - dx4, 0, legw + dx4] + legxm;
  legx0 = legx1 - legw * 0.5;
  
  ## create axes
  ah = axes(p_fh, 'clipping', 'off');
  
  ## adjust axis appearance
  axis(ah, 'off', 'equal');
  
  ## begin plot
  hold(ah, 'on');
  
  ## plot performace assessment matrix
  tool_plot_perfassmat(ah, p_sm, p_ps.errlim, p_ps.pa_bcols, p_ps.pa_fcols, p_ps.pa_boxsz, 'val');
  
  ## x axis labels, headline 1
  Nxlbl1 = p_ads.Nvar(1); # number of x axis labels, headline 1
  Nxlbl2 = p_ads.Nvar(1) * p_ads.Nvar(2); # number of x axis labels, headline 2
  tool_plot_labelgroups(ah, 'horizontal', [1 - dy, 1 - dy - dy4], [1 : Nxlbl1] * p_ads.Nvar(2) - 1, v_N1, ...
    p_ads.Nvar(2) - dx2, 12, [], 0, 'center', 'baseline', '-', 2, p_ps.pa_scol);
  text(ah, Nxlbl2 + dx2, 1 - dy, 'N1 [#]', 'horizontalalignment', 'left', 'verticalalignment', 'baseline', 'fontsize', 12);
  
  ## legend, above matrix
  rectangle(ah, 'position', [legx0(1), legy0, legw, legh], 'linestyle', 'none', 'facecolor', p_ps.pa_bcols(1, :), 'handlevisibility', 'off');
  rectangle(ah, 'position', [legx0(2), legy0, legw, legh], 'linestyle', 'none', 'facecolor', p_ps.pa_bcols(2, :), 'handlevisibility', 'off');
  rectangle(ah, 'position', [legx0(3), legy0, legw, legh], 'linestyle', 'none', 'facecolor', p_ps.pa_bcols(3, :), 'handlevisibility', 'off');
  text(ah, legx1(1), legy1, '0 - 5', 'horizontalalignment', 'center', 'verticalalignment', 'middle');
  text(ah, legx1(2), legy1, '5 - 10', 'horizontalalignment', 'center', 'verticalalignment', 'middle');
  text(ah, legx1(3), legy1, '> 10', 'horizontalalignment', 'center', 'verticalalignment', 'middle');
  text(ah, legx0(1) - dx4, legy1, 'Range', 'horizontalalignment', 'right', 'verticalalignment', 'middle');
  text(ah, legx0(3) + legw + dx4, legy1, '[%]', 'horizontalalignment', 'left', 'verticalalignment', 'middle');
  
  ## end plot
  hold(ah, 'off');
  
  ## x axis labels, headline 2
  tool_plot_labelseries(ah, 'horizontal', -dy2, [], repmat(v_DF, 1, p_ads.Nvar(1)), [], [], 0, 'center', 'baseline');
  text(ah, Nxlbl2 + dx2, -dy2, 'DF [1]', 'horizontalalignment', 'left', 'verticalalignment', 'baseline');
  
  ## y axis labels
  tool_plot_labelseries(ah, 'vertical', 1 - dy, [-1; -p_ads.Nvar(3)], flip(v_SNR), [], [], 0, 'right', 'middle');
  text(ah, 1 - dx, 1 - dy - dy4, 'SNR [dB]', 'horizontalalignment', 'right', 'verticalalignment', 'middle');
  
  ## title
  title(ah, sprintf('Performance assessment - Method %d (%s)\n%s(err), lim_1 = %.1f [%%], lim_2 = %.1f [%%]', ...
    p_ps.pa_rtp, c_acf_mode, p_ps.pa_vt, p_ps.pa_vl(1), p_ps.pa_vl(2)));
  
endfunction


function test_acfrn_nat(p_ps, p_dfp, p_cid, p_sid, p_lim)
  ## Plot application examples, naural signals
  ##
  ## p_ps  ... plot settings structure, <struct>
  ## p_dfp ... dataset file path, <str>
  ## p_cid ... channel id (1 = P-wave, 2 = S-wave), <uint>
  ## p_sid ... signal id, <uint>
  ## p_lim ... window limits [n_start, n_end], [<uint>]
  
  ## load dataset structure
  ds = load(p_dfp, 'dataset').dataset;
  
  ## select signal data
  switch (p_cid)
    case 1
      ## P-wave, 1
      r_xx = ds.tst.s06.d13.v(:, p_sid); # signal amplitude array/matrix
      r_nt = ds.tst.s06.d09.v; # trigger-point index
      r_fs = ds.tst.s06.d07.v; # sample rate, Hz
      r_ms = ds.tst.s06.d02.v + ds.tst.s06.d11.v(p_sid); # maturity, Sec
      wavetp = 'P-wave';
    otherwise
      ## S-wave, 2
      r_xx = ds.tst.s07.d13.v(:, p_sid); # signal amplitude array/matrix
      r_nt = ds.tst.s07.d09.v; # trigger-point index
      r_fs = ds.tst.s07.d07.v; # sample rate, Hz
      r_ms = ds.tst.s07.d02.v + ds.tst.s07.d11.v(p_sid); # maturity, Sec
      wavetp = 'S-wave';
  endswitch
  dscode = ds.meta_set.a01.v;
  dscode_tex = strrep(dscode, '_', '\_');
  
  ## noise, pre-trigger section
  vvp = r_xx(1 : r_nt);
  vvp_pow = meansq(vvp);
  
  ## signal
  xx = r_xx([p_lim(1) : p_lim(2)]);
  xx_pow = meansq(xx);
  
  ## signal power, direct estimate
  ss_pow1 = xx_pow - vvp_pow;
  
  ## signal power, ACF with noise reduction
  [r_acf, r_lag, r_nrm, r_mli, r_m0] = tool_est_acfrn(xx, 'unbiased', 'mx2');
  ss_pow2 = r_acf(r_m0);
  
  ## power difference and relative error compared to method 1
  pow_diff = ss_pow1 - ss_pow2;
  pow_err = pow_diff / ss_pow1 * 100;
  
  ## signal to noise ratio
  snr1 = 10 * log10(ss_pow1 / vvp_pow); # method 1
  snr2 = 10 * log10(ss_pow2 / vvp_pow); # method 2
  
  ## geometry parameters
  xx_min = min(xx); xx_max = max(xx); xx_rng = xx_max - xx_min;
  xx_min1 = xx_min - 0.05 * xx_rng;
  xx_max1 = xx_max + 0.05 * xx_rng;
  n_rng = p_lim(2) - p_lim(1);
  n_min1 = p_lim(1) - 0.25 * n_rng;
  n_max1 = p_lim(2) + 0.25 * n_rng;
  
  ## create figure
  fh = figure('name', 'Application examples', 'position', [100, 100 640, floor(640 / 1.62)]);
  
  ## create axes
  ah = axes(fh, 'tickdir', 'out');
  
  ## begin plot
  hold(ah, 'on');
  ## plot fill, background
  fill(ah, [p_lim(1), p_lim(2), p_lim(2), p_lim(1)], [xx_min1, xx_min1, xx_max1, xx_max1], [1, 1, 1] * 0.9, 'linestyle', 'none', 'handlevisibility', 'off');
  ## plot x axis
  plot([1, length(r_xx)], [0, 0], '-', 'linewidth', 0.5, 'color', [0, 0, 0],'handlevisibility', 'off');
  ## plot signal
  plot(ah, [1 : length(r_xx)], r_xx, '-', 'linewidth', 1, 'color', 'b', 'displayname', 'x[n]');
  ## plot window limits
  plot(ah, [1, 1] * p_lim(1), [xx_min1, xx_max1], '--', 'linewidth', 0.5, 'color', [1, 1, 1] * 0.5, 'handlevisibility', 'off');
  plot(ah, [1, 1] * p_lim(2), [xx_min1, xx_max1], '--', 'linewidth', 0.5, 'color', [1, 1, 1] * 0.5, 'handlevisibility', 'off');
  ## end plot
  hold(ah, 'off');
  
  ## labels, title
  text(ah, p_lim(1), xx_min1 + 0.01 * xx_rng, sprintf(' n_1 = %d', p_lim(1)), 'horizontalalignment', 'left', 'verticalalignment', 'bottom');
  text(ah, p_lim(2), xx_min1 + 0.01 * xx_rng, sprintf(' n_2 = %d', p_lim(2)), 'horizontalalignment', 'left', 'verticalalignment', 'bottom');
  xlim(ah, [n_min1, n_max1]);
  ylim(ah, [xx_min1, xx_max1]);
  xlabel(ah, 'Sample index [n]');
  ylabel(ah, 'Amplitude [V]');
  title(ah, sprintf('Cement paste test\n%s, %s, SID = %d', dscode_tex, wavetp, p_sid));
  legend(ah, 'location', 'northeast', 'box', 'off');
  
  ## license information
  annotation(fh, 'textbox', [0, 0, 100, 10], 'string', 'CC BY-4.0 Jakob Harden (Graz University of Technology), 2024', ...
    'linestyle', 'none', 'fontsize', 8);
  
  ## save figure
  ofn_pfx = sprintf('nat_ds_%s_cid_%d_sid_%d', dscode, p_cid, p_sid);
  ofp_fig = fullfile(p_ps.rpath, sprintf('%s.ofig', ofn_pfx));
  ofp_png = fullfile(p_ps.rpath, sprintf('%s.png', ofn_pfx));
  hgsave(fh, ofp_fig);
  saveas(fh, ofp_png, 'png');
  close(fh);
  
  ## print results on screen
  printf('Signal power (ds = %s, %s, sid = %d):\n', dscode, wavetp, p_sid);
  printf('  Ps,1 = %.4e [V^2] (method 1)\n', ss_pow1);
  printf('  Ps,2 = %.4e [V^2] (method 2)\n', ss_pow2);
  printf('  delta Ps = Ps,1 - Ps,2 = %.4e [V^2]\n', pow_diff);
  printf('  delta Ps / Ps,1 * 100 = %.2f [%%]\n', pow_err);
  printf('  SNR,1 = %.2f [dB]\n', snr1);
  printf('  SNR,2 = %.2f [dB]\n', snr2);
  
  ## export results to TeX file
  ofp = fullfile(p_ps.rpath, ofn_pfx);
  dsn = sprintf('nat.%s.%d.%d', dscode, p_cid, p_sid);
  ads.dscode = struct_objattrib('dscode', dscode, 'dataset code');
  ads.tsn = struct_objattrib('tsn', 'Cement paste tests', 'test series name');
  ads.chn = struct_objattrib('chn', wavetp, 'channel name');
  ads.sid = struct_objdata('sid', 'uint', p_sid, '#', 'signal id');
  ads.mat = struct_objdata('mat', 'dbl', r_ms / 60, 'Min', 'specimen maturity in Minutes');
  ads.wn1 = struct_objdata('wn1', 'uint', p_lim(1), 'n', 'lower window limit');
  ads.wn2 = struct_objdata('wn2', 'uint', p_lim(2), 'n', 'upper window limit');
  ads.pv = struct_objdata('pv', 'dbl', vvp_pow, 'V^2', 'noise power estimate');
  ads.px = struct_objdata('px', 'dbl', xx_pow, 'V^2', 'signal in noise power estimate');
  ads.ps1 = struct_objdata('ps1', 'dbl', ss_pow1, 'V^2', 'signal power estimate, method 1');
  ads.ps2 = struct_objdata('ps2', 'dbl', ss_pow2, 'V^2', 'signal power estimate, method 2');
  ads.dps = struct_objdata('dps', 'dbl', pow_diff, 'V^2', 'power difference');
  ads.perr = struct_objdata('perr', 'dbl', pow_err, '%', 'power error, (ps1 - ps2) / ps1 * 100');
  ads.snr1 = struct_objdata('snr1', 'dbl', snr1, 'dB', 'signal-to-noise ration, method 1');
  ads.snr2 = struct_objdata('snr2', 'dbl', snr2, 'dB', 'signal-to-noise ration, method 2');
  
  ## write TeX file
  [r_ec] = tex_struct_export(ads, dsn, ofp);
  
endfunction


function test_acfrn_sig(p_ps, p_n1, p_ncy, p_am, p_df, p_snr, p_vm)
  ## Plot test signal examples
  ##
  ## p_ps  ... plot settings structure, <struct>
  ## p_n1  ... signal period, number of samples, <uint>
  ## p_ncy ... cycles, number of periods, <dbl>
  ## p_am  ... signal amplitude, V, <dbl>
  ## p_df  ... exponential decay factors, [<dbl>]
  ## p_snr ... signal-to-noise ratios, dB, [<dbl>]
  ## p_vm  ... standard noise data matrix, [[<dbl>]]
  
  for SNR = p_snr
    for DF = p_df
      ## signal information
      sinfo = sprintf('N_1 = %d, N_{cy} = %d, DF = %d, SNR = %d dB', p_n1, p_ncy, DF, SNR);
      ## generate signal in noise
      [ss, nn, Ntot] = tool_gen_sinusoidal1(p_am, p_n1, p_ncy, DF);
      ss = transpose(ss);
      vv = p_vm(1 : Ntot, 1);
      [vvs, sf, ps, pv] = tool_scale_noise2snr(ss, vv, SNR);
      xx = ss + vvs;
      ## create figure
      fh = figure('name', 'test_acfrn, signal', 'position', [100, 100, 800, 800 / 1.62]);
      ah = axes(fh, 'tickdir', 'out');
      ylim(ah, [min(ss) * 1.25, max(ss) * 1.25]);
      xlim(ah, [nn(1), nn(end)]);
      ## begin plot
      hold(ah, 'on');
      ## plot signals
      plot(ah, nn([1, end]), [0, 0], 'linewidth', 0.5, 'color', [1, 1, 1] * 0.2, 'handlevisibility', 'off');
      plot(ah, nn, xx, ';x[n];', 'linewidth', p_ps.lw_x, 'color', p_ps.lc_x);
      plot(ah, nn, ss, ';s[n];', 'linewidth', p_ps.lw_s, 'color', p_ps.lc_s);
      ## end plot
      hold(ah, 'off');
      ## title, labels
      xlabel(ah, 'Sample index [1]');
      ylabel(ah, 'Amplitude [V]');
      title(ah, sprintf('Sinusoidal signal\n%s', sinfo));
      legend(ah, 'box', 'off');
      ## license information
      annotation(fh, 'textbox', [0, 0, 100, 10], 'string', 'CC BY-4.0 Jakob Harden (Graz University of Technology), 2024', ...
        'linestyle', 'none', 'fontsize', 8);
      ## save figure
      ofn_pfx = sprintf('sig_N1_%d_Ncy_%d_DF_%d_SNR_%d', p_n1, p_ncy, DF, SNR);
      ofp_fig = fullfile(p_ps.rpath, sprintf('%s.ofig', ofn_pfx));
      ofp_png = fullfile(p_ps.rpath, sprintf('%s.png', ofn_pfx));
      hgsave(fh, ofp_fig);
      saveas(fh, ofp_png, 'png');
      close(fh);
    endfor
  endfor
  
endfunction


function test_acfrn_acf(p_ps, p_n1, p_ncy, p_am, p_df, p_snr, p_vm, p_acm, p_nrm)
  ## Plot ACF with reduced impact of noise, method comparison
  ##
  ## p_ps  ... plot settings structure, <struct>
  ## p_n1  ... signal period, number of samples, <uint>
  ## p_ncy ... cycles, number of periods, <dbl>
  ## p_am  ... signal amplitude, V, <dbl>
  ## p_df  ... exponential decay factors, [<dbl>]
  ## p_snr ... signal-to-noise ratios, dB, [<dbl>]
  ## p_vm  ... standard noise data matrix, [[<dbl>]]
  ## p_acm ... auto-correlation function (ACF) scaling mode, <str>
  ## p_nrm ... ACF noise reduction mode, <str>
  
  for SNR = p_snr
    for DF = p_df
      ## signal information
      sinfo = sprintf('%s, N_1 = %d, N_{cy} = %d, DF = %d, SNR = %d dB', p_acm, p_n1, p_ncy, DF, SNR);
      ## generate signal
      [ss, nn, Ntot] = tool_gen_sinusoidal1(p_am, p_n1, p_ncy, DF);
      ss = transpose(ss);
      vv = p_vm(1 : Ntot, 1);
      [vvs, sf, ps_sig, pv] = tool_scale_noise2snr(ss, vv, SNR);
      xx = ss + vvs;
      ## estimate ACF with reduced impact of noise
      acf_ss = xcorr(ss, ss, p_acm);
      acf_xx = xcorr(xx, xx, p_acm);
      acf_sx = xcorr(ss, xx, p_acm);
      [acf_rn, lag_rn, ~, ~, m0_rn] = tool_est_acfrn(xx, p_acm, p_nrm);
      ## y limits
      idxrng = m0_rn - 10 : m0_rn + 10;
      ymin = min([min(acf_xx(idxrng)), min(acf_ss(idxrng))]);
      ymax = max([max(acf_xx(idxrng)), max(acf_ss(idxrng))]);
      yrng = range(acf_xx(idxrng));
      ymin1 = ymin - 0.05 * yrng;
      ymax1 = ymax + 0.05 * yrng;
      ## plot ACF comparison
      fh = figure('name', 'ACF', 'position', [100, 100, 480, floor(480 * 1.62)]);
      ah = axes(fh, 'tickdir', 'out');
      xlim([-10, 10]);
      ylim([ymin1, ymax1]);
      ## begin plot
      hold on;
      ## plot ACF curves
      plot(lag_rn, acf_xx, '-;R_{xx};', 'linewidth', 1, 'color', p_ps.lc1);
      plot(lag_rn, acf_ss, '-;R_{ss};', 'linewidth', 1, 'color', 'r');
      plot(lag_rn, acf_sx, '-;R_{sx};', 'linewidth', 1, 'color', 'g');
      plot(lag_rn, acf_rn, ';R_{xx}, ACF-RN;', 'linewidth', 2, 'color', p_ps.lc2);
      ## end plot
      hold off;
      ## title, labels
      xlabel(ah, 'Lag [m]');
      ylabel(ah, 'Magnitude [V^2]');
      title(ah, sprintf('ACF - (damped) sinusoidal signal\n%s', sinfo));
      legend(ah, 'box', 'off');
      ## license information
      annotation(fh, 'textbox', [0, 0, 100, 10], 'string', 'CC BY-4.0 Jakob Harden (Graz University of Technology), 2024', ...
        'linestyle', 'none', 'fontsize', 8);
      ## save figure
      ofn_pfx = sprintf('acf_%s_N1_%d_Ncy_%d_DF_%d_SNR_%d', p_acm, p_n1, p_ncy, DF, SNR);
      ofp_fig = fullfile(p_ps.rpath, sprintf('%s.ofig', ofn_pfx));
      ofp_png = fullfile(p_ps.rpath, sprintf('%s.png', ofn_pfx));
      hgsave(fh, ofp_fig);
      saveas(fh, ofp_png, 'png');
      close(fh);
    endfor
  endfor
  
endfunction
