%% K-means clustering
%==========================================================================
% This routine applies a k-means clustering algorithm on the dynamics
% measures produced from the initial analysis, to evaluate whether they can
% be used to separate groups into distinct categories, and assess the
% sensitivity and specificity of differentiating healthy controls from
% abnormal EEG patterns

% Housekeeping
%==========================================================================
clear all
fs          = filesep;
D           = ee_housekeeping;
Fanalysis   = D.Fanalysis;
Fscripts    = D.Fscripts;

% Load stats matrix
%--------------------------------------------------------------------------

load([Fanalysis fs 'Allstats_matrix']);
load([Fanalysis fs 'Allstats_purity_sorting']);
C       = M.C;
cnames  = M.cnames;
rnames  = M.rnames;

for r = 1:length(rnames)
    cat(r) = rnames{r}(1);
end

%% Repeat clustering for increasing numbers of parameters
%==========================================================================
% Several repetitions are run to identify the cluster assignments with 
% the highest purity, to illustrate the maximally achievable purity

textprogressbar('Clustering ');
count = 1;
for v = 1:30
for r = 1:50 
textprogressbar((count * 100) / (30*50))

[idx centroids] = kmeans(C(:,sort_i(1:v)),3);

cattypes = unique(cat);
catcombs = perms(cattypes);
newcat   = idx';

for p = 1:size(catcombs,1)
    for i = 1:length(cat)
        numcat(i) = find(cat(i) == catcombs(p,:));
    end
    pur(p) = sum(numcat == newcat) / length(numcat);
end
[bestfit_val bestfit_loc] = max(pur);
purity(v, r) = bestfit_val;

for i = 1:length(idx)
    ncat(i) = catcombs(bestfit_loc,idx(i));
end
abn_known = cat ~= 'C';
abn_estim = ncat ~= 'C';
nml_known = cat == 'C';
nml_estim = ncat == 'C';

sens(v,r) = sum(abn_estim(find(abn_known)))/sum(abn_known);
spec(v,r) = sum(nml_estim(find(nml_known)))/sum(nml_known);

count = count + 1;
end
end

textprogressbar(' Done');

bestpur = max(purity');
for s = 1:size(sens,1)
   [val loc]    = max(sens(s,:) + spec(s,:))
   bestsens(s)  = sens(s,loc);
   bestspec(s)  = spec(s,loc);
end

subplot(3,1,1), plot(bestpur); ylim([0 1]); title('Purity');
subplot(3,1,2), plot(bestsens); ylim([0 1]); title('Sensitivity');
subplot(3,1,3), plot(bestspec); ylim([0 1]); title('Specificity');

%% Illustrate a single two dimensional solution
%==========================================================================
% This produces the figure used in figure 8 of the manuscript, but the
% clustering at the level of just 2 variables is not very robust, so the
% figure may look dissimilar from the one in the manuscript

ranklist = csv2cell([Fanalysis fs 'Allstats_cluster_purity.csv'], 'fromfile');

v1 = find(strcmp(cnames, ranklist{2,1}));
v2 = find(strcmp(cnames, ranklist{3,1}));

[idx centroids] = kmeans(C(:,[v1 v2]),3);
c1 = linspace(min(C(:,v1)), max(C(:,v1)), 500);
c2 = linspace(min(C(:,v2)), max(C(:,v2)), 500);
[c1G,c2G] = meshgrid(c1,c2);
CGrid = [c1G(:),c2G(:)];
idx2Region = kmeans(CGrid,3,'MaxIter',1,'Start',centroids);

figure;
gscatter(CGrid(:,1),CGrid(:,2),idx2Region,...
    [0,0.75,0.75;0.75,0,0.75;0.75,0.75,0],'..');
hold on;

oh = find(cat == 'O');
ws = find(cat == 'W');
co = find(cat == 'C');
plids   = {oh, ws, co};
cols    = cbrewer('qual', 'Dark2', 3);

for p = 1:length(plids)
    pl = plids{p};
    scatter(C(pl,v1),C(pl,v2),50,cols(p,:), 'filled');
end

