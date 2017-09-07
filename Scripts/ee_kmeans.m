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

%%
orig_sort_i = sort_i;
clear sort_i;
i = 0;
for o = 1:length(orig_sort_i)
    if cnames{orig_sort_i(o)}(1) ~= 'Z' 
        i       = i + 1;
        sort_i(i) = orig_sort_i(o);
    end
end

% Repeat clustering for increasing numbers of parameters
%--------------------------------------------------------------------------
textprogressbar('Clustering ');
count = 1;
for v = 1:20
    
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
subplot(3,1,1), plot(bestpur); ylim([0 1]);
subplot(3,1,2), plot(bestsens); ylim([0 1]);
subplot(3,1,3), plot(bestspec); ylim([0 1]);

%% Illustrate a single two dimensional solution
%--------------------------------------------------------------------------

[idx centroids] = kmeans(C(:,sort_i(1:2)),3);
c1 = linspace(min(C(:,sort_i(1))), max(C(:,sort_i(1))), 500);
c2 = linspace(min(C(:,sort_i(2))), max(C(:,sort_i(2))), 500);
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
    scatter(C(pl,sort_i(1)),C(pl,sort_i(2)),50,cols(p,:), 'filled');
end


%% Identify maximum purity cluster 
%--------------------------------------------------------------------------
for r = 1:25
    [val loc] = max(max(purity'));
    [idx centroids] = kmeans(C(:,sort_i(1:2)),3);
    
    cattypes = unique(cat);
    catcombs = perms(cattypes);
    newcat   = idx';

    for p = 1:size(catcombs,1)
        for i = 1:length(cat)
            numcat(i) = find(cat(i) == catcombs(p,:));
        end
        pur(p) = sum(numcat == newcat) / length(numcat);
    end
    [val loc] = max(pur);
    for i = 1:length(idx)
        ncat(i) = catcombs(loc,idx(i));
    end
    abn_known = cat ~= 'C';
    abn_estim = ncat ~= 'C';
    nml_known = cat == 'C';
    nml_estim = ncat == 'C';
    
    sens(r) = sum(abn_estim(find(abn_known)))/sum(abn_known);
    spec(r) = sum(nml_estim(find(nml_known)))/sum(nml_known);
end

[val loc] = max(sens+spec)
disp(['Sens: ' num2str(sens(loc)) ', Spec: ' num2str(spec(loc))])
