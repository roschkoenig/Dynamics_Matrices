%% Housekeeping
%==========================================================================
clear all
fs          = filesep;
D           = ee_housekeeping;
Fanalysis   = D.Fanalysis;
Fscripts    = D.Fscripts;

addpath(Fscripts);
[p, c]      = ee_definefiles;
sub         = [p{:}, c{:}];  

%% Load stats matrix
%--------------------------------------------------------------------------

load([Fanalysis fs 'Allstats_matrix']);
% load([Fanalysis fs 'Allstats_purity_sorting']);
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

for v = 1:length(plvar);
cid = find(strcmp(plvar{v}, cnames));

for p = 1:length(plids)
    d{p} = C(plids{p},cid)';
end
subplot(3,2,v)
ee_dotplot(d, pllab, 1);
plot([0 10], [-2 -2], 'k');
plot([0 10], [2 2], 'k');
ys = get(gca, 'YLim');
yl = ys(1); yh = ys(2);
if yl > -2.5; yl = -2.5; end
if yh < 2.5; yh = 2.5; end
ylim([yl, yh]);
axis square
end

%%
emp1 = load([Fanalysis fs 'C_6_G_5_ccors']);
emp2 = load([Fanalysis fs 'C_6_G_5_cpows']);

pre1 = load([Fanalysis fs 'W_6_A_2_ccors']);
pre2 = load([Fanalysis fs 'W_6_A_2_cpows']);

% emp1 = load([Fanalysis fs 'C_6_G_2_ccors']);
% emp2 = load([Fanalysis fs 'C_6_G_2_cpows']);
% 
% pre1 = load([Fanalysis fs 'C_6_G_2_synth_ccors']);
% pre2 = load([Fanalysis fs 'C_6_G_2_synth_cpows']);

emp.ccor = squeeze(emp1.ccors(1,:,:));
emp.cpow = squeeze(emp2.cpows(1,:,:));

pre.ccor = squeeze(pre1.ccors(1,:,:));
pre.cpow = squeeze(pre2.cpows(1,:,:));

subplot(2,2,1), imagesc(pre.ccor, [0 1]); axis square
subplot(2,2,2), imagesc(pre.cpow, [0 1]); axis square
subplot(2,2,3), imagesc(emp.ccor, [0 1]); axis square
subplot(2,2,4), imagesc(emp.cpow, [0 1]); axis square

%%
Fold = '/Users/roschkoenig/Dropbox/Research/Baldeweg Lab/1512 EE Transitions Data/1703 Clustering Scripts/Analysis';
sublist = {'O_1_D', 'O_2_A', 'O_2_C', 'W_5_H', 'W_6_A', 'W_8_M', 'C_2_C', 'C_6_G'};
count = 0;

textprogressbar('Calculating: ');
for s = 1:length(sublist)
for b = 1:5
    count = count + 1;
    textprogressbar(count * 100 / (length(sublist)*5));
    cor = load([Fold fs sublist{s} '_' num2str(b) '_ccors']);
    pow = load([Fold fs sublist{s} '_' num2str(b) '_cpows']);
    dif{count} = cor.ccors - pow.cpows;
end      
end
textprogressbar(' Done');


filt = 1;
textprogressbar('Calculating Mean Differences ');
for p = 1:length(plids)
    ids = plids{p};
    for pp = 1:length(ids)
        textprogressbar(ids(pp) * 100 / 40);
        d{p}(pp) = mean(mean(squeeze(dif{ids(pp)}(filt,:,:))));
        dab{p}(pp) = mean(mean(squeeze(abs(dif{ids(pp)}(filt,:,:)))));
    end     
end
textprogressbar('Done')
%%
ee_dotplot(d, pllab, 1)
axis square
ylim([-0.6 0.8]);

