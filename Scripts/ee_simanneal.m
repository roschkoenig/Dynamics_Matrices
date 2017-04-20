%% Simulated annealing to find optimal thresholds
%==========================================================================
% This routine uses simulated annealing to optimise thresholds to sort
% dynamics measures into different patient categories. 

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
C       = M.C;
cnames  = M.cnames;
rnames  = M.rnames;

for r = 1:length(rnames)
    cat(r) = rnames{r}(1);
end

%% Run Simulated Annealing for the different variables
%==========================================================================
for cid = 1:size(C,2)
disp(['Number ' num2str(cid) ' of ' num2str(size(C,2)')]);
m = C(:,cid);

mrange = [min(m) max(m)];
third  = (mrange(2) - mrange(1))/3;

ObjFun  = @(thr) ee_impurity(thr, m, cat);
X0      = [mrange(1) + third, mrange(2) + 2*third];

% Run 5 iterations for robustness
%--------------------------------------------------------------------------
for i = 1:5
    [x, fval] = simulannealbnd(ObjFun, X0);
    temp(i,:) = [fval, x(1), x(2)];
end

% Identify most common return
%--------------------------------------------------------------------------
vals = unique(temp(:,2));   
for v = 1:length(vals)
    count(v) = sum(vals(v) == temp(:,2));
end
[v, l]       = max(count);
common_ids  = find(vals(l) == temp(:,2));

% Store most frequently returned value in output
%--------------------------------------------------------------------------
imp(cid, :) = temp(common_ids(1),:);

end

%% Plot clusters from the top three variables
%==========================================================================
% This reproduces the figure 8 in the manuscript, but may select a
% different set of three variables, depending on slight variations in the
% solutions found from the simulated annealing above

[sorted sort_i]     = sort(imp(:,1));
oh = find(cat == 'O');
ws = find(cat == 'W');
co = find(cat == 'C');

plids   = {oh, ws, co};
cols    = cbrewer('qual', 'Dark2', 3);
for p = 1:length(plids)
    pl = plids{p};
    scatter3(C(pl,sort_i(1)), C(pl,sort_i(2)), C(pl,sort_i(3)), 50, cols(p,:), 'filled'); hold on;
    xlabel(cnames{sort_i(1)});
    ylabel(cnames{sort_i(2)});
    zlabel(cnames{sort_i(3)});
end
legend({'Ohtahara', 'West', 'Control'});

%% Run Annealing over random variable to verify chance impurity
%==========================================================================
for i = 1:10
    m       = rand(size(C,3), 1);
    mrange  = [min(m) max(m)];
    third   = (mrange(2) - mrange(1))/3;

    ObjFun  = @(thr) ee_impurity(thr, m, cat);
    X0      = [mrange(1) + third, mrange(2) + 2*third];

    [x, fval] = simulannealbnd(ObjFun, X0);

    rimp(i)	= fval;
end

cutoff = mean(rimp);

%% Export list of ranked variables
%==========================================================================
names       = {cnames{sort_i}};
varnames    = {'Names', 'Purity', 'Matrix Type', 'Measure', 'Filter band', 'Normalisation'};
for v = 1:length(varnames)
    Exp{1,v} = varnames{v};
end

for i = 1:length(sort_i)
    si         = sort_i(i);
    Exp{i+1,1} = cnames{si};        % Names
    Exp{i+1,2} = 1-sorted(i);       % Purity
    
    sep = find(cnames{si} == '_');
    if cnames{si}(1) ~= 'Z'
        Exp{i+1,3}  = cnames{si}(1);
        Exp{i+1,4}  = cnames{si}(2:sep-1);
        Exp{i+1,5}  = cnames{si}(sep+1:end);
        Exp{i+1,6}  = 'N';
    else
        Exp{i+1,3}  = cnames{si}(2);
        Exp{i+1,4}  = cnames{si}(3:sep-1);
        Exp{i+1,5}  = cnames{si}(sep+1:end);
        Exp{i+1,6}  = 'Y';        
    end
        
end

% cell2csv([Fanalysis fs 'Allstats_cluster_purity.csv'], Exp);

