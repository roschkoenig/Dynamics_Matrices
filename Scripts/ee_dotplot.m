function ee_dotplot(d, lab)
%==========================================================================
% This function takes data in a cell array and plots each dataset within a
% cell as individual dotplots. It then performs a 2 sided ttest on all
% variations and plots means and standard deviations, as well as the
% significance of the mean differences

for dd = 1:length(d)

o = ones(1,length(d{dd})) * dd + randn(1,length(d{dd}))/20;
c = ones(length(d{dd}), 3) * 0.5;
a = 25;

scatter(o, d{dd}, a, c, 'filled'); hold on;
xlim([0, length(d)+1]);

m   = mean(d{dd});
sem = std(d{dd}) / sqrt(length(d{dd}));
dev = std(d{dd});

plot([dd dd], [m-dev m+dev], 'Color', [0.7 0.3 0.3], 'Linewidth', 2);
plot([dd-0.25 dd+0.25], [m m], 'k', 'Linewidth', 2);

end

set(gca, 'XTick', 1:length(d));
set(gca, 'XTickLabel', lab, 'fontweight', 'bold');

l = combnk(1:length(d), 2);
i = 0;
t = max([d{:}]); st = 0.1 * t;

for ll = 1:size(l,1)
    [h p] = ttest2(d{l(ll,1)}, d{l(ll,2)});
    if h
       plot([l(ll,1) l(ll,2)], [t+st t+st], 'k'); 
       t = t+st;
       xloc = mean([l(ll,1) l(ll,2)]);
       yloc = t;
       if p < 0.01, text(xloc, yloc, '**');
       else, text(xloc, yloc, '*'); end
  end
end

if min([d{:}]) < -2; lower = min([d{:}]) + 0.1*min([d{:}]);
else    lower = -2.5; end

if t+st > 2; upper = t+st; else upper = 2.5; end
ylim([lower upper]);