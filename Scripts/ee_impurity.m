function impurity = ee_impurity(thr, v, cat)

t(1) = min(thr);
t(2) = max(thr);

cattypes = unique(cat);
catcombs = perms(cattypes);

for i = 1:length(v)
    if v(i) < t(1)
        newcat(i) = 1;
    elseif v(i) < t(2)
        newcat(i) = 2;
    else
        newcat(i) = 3;
    end
end

for p = 1:size(catcombs,1)
for i = 1:length(cat)
    numcat(i) = find(cat(i) == catcombs(p,:));
end
pur(p) = sum(numcat == newcat) / length(numcat);
end
        
[val, loc]  = max(pur);
impurity    = 1-pur(loc(1));
        