%% Group differences after normalisation
%--------------------------------------------------------------------------
% This code will load the statistical measures and plot them using the
% dotplot function (produces Figure 6 from the manuscript)

%% Housekeeping
%==========================================================================
clear all
fs          = filesep;
D           = ee_housekeeping;
Fanalysis   = D.Fanalysis;
Fscripts    = D.Fscripts;

addpath(Fscripts);

% Plotting routines
%--------------------------------------------------------------------------

load([Fanalysis fs 'Allstats_matrix']);
C       = M.C;
cnames  = M.cnames;
rnames  = M.rnames;

for r = 1:length(rnames)
    cat(r) = rnames{r}(1);
end

oh = find(cat == 'O');
ws = find(cat == 'W');
co = find(cat == 'C');
pllab   = {'Ohtahara', 'West', 'Control'};
plids   = {oh, ws, co};

plvar = {'ZPmean_all', 'ZCmean_all', 'ZPcont_all', 'ZCcont_all', 'ZPsharp_all', 'ZCsharp_all'};

for v = 1:length(plvar)
cid = find(strcmp(plvar{v}, cnames));

for p = 1:length(plids)
    d{p} = C(plids{p},cid)';
end
subplot(3,2,v)
ee_dotplot(d, pllab)
plot([0 10], [-2 -2], 'k');
plot([0 10], [2 2], 'k');
axis square
end
