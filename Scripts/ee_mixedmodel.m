fs          = filesep;
D           = ee_housekeeping;
Fanalysis   = D.Fanalysis;
Fscripts    = D.Fscripts;
load([Fanalysis fs 'Allstats']);

addpath(Fscripts);
[p, c]      = ee_definefiles;
sub         = [p{:}, c{:}];   

filt = 1;

i   = 0;
clear Psharp Psharp Pcont Cmean Csharp Ccont group conds subID

for s = 1:length(sub)
for d = 1:size(S(s).Dyn, 2)
    i = i + 1;
    Pmean(i,1)      = S(s).Dyn(filt,d).Pmean;
    Psharp(i,1)     = S(s).Dyn(filt,d).Psharp;
    Pcont(i,1)      = S(s).Dyn(filt,d).Pcont;
    
    Cmean(i,1)      = S(s).Dyn(filt,d).Cmean;
    Csharp(i,1)     = S(s).Dyn(filt,d).Csharp;
    Ccont(i,1)      = S(s).Dyn(filt,d).Ccont;
    
    switch sub(s).cond(1)
        case 'O', group(i,1) = 1;
        case 'W', group(i,1) = 2;
        case 'C', group(i,1) = 3;
    end
    
    conds(i,1) = d;
    subID(i,1) = s;
    
end
end

factors = {Pmean, Psharp, Pcont, Cmean, Csharp, Ccont};
for f = 1:length(factors)
    [SSQs, DFs, MSQs, Fs, Ps{f}] = mixed_between_within_anova([factors{f}, group, conds, subID]);
end

glist = unique(group);
labels = {'Ohtahara', 'West', 'Control'};

clear d
for g = glist'
    d{g} = Cmean(find(group == g))';    
end
subplot(1,2,1),
ee_dotplot(d, labels)
ylim([0 1]);
title('Mean Correlation in CDM');
axis square
set(gcf, 'color', 'w');

for g = glist'
    d{g} = Pmean(find(group == g))';    
end
subplot(1,2,2)
ee_dotplot(d, labels)
ylim([0 1]);
title('Mean Correlation in PDM');
axis square




