%% Visualise Dynamics Matrix Features
%==========================================================================
% This function uses a simple 2*2 block matrix to illustrate contrasting
% effects of transition smoothness and amplitude/scaling on the sharpenss
% and contrast measures used for the analysis (Figure 3 in the manuscript)

%% Plot example matrices to compate contrast and sharpness measures
%==========================================================================
matr    = zeros(4096);
matr(1:2048, 1:2048)        = ones(2048, 2048);
matr(2049:end, 2049:end)    = ones(2048, 2048);
matr                        = matr + randn(size(matr))/30;

combs = [0 0; 1 0; 0 1; 1 1];

for c = 1:size(combs,1)
    cb = combs(c,:);
    bl = (100 + 100 * (cb(1) * 18)) / 20;
    sc = 1 / (1 + cb(2)*4);
    
    matblur = imgaussfilt(matr, bl);
    matblur = matblur * sc / max(max(matblur));
    
    subplot(2,2,c), imagesc(matblur, [0 1]); axis square; colormap gray
    
    glmcs       = graycomatrix(matblur); 
    stats       = graycoprops(glmcs);    
    sharp(c)       = sharpness(matblur);
    cont(c)        = stats.Contrast;
    title(['Sharpness: ' num2str(sharp(c)) ', Contrast: ' num2str(cont(c))]);
    
end  

%% Modelling effects of variable smoothing
%==========================================================================
steps = 20;
textprogressbar('Calculating ');
for s = 1:steps
textprogressbar(s*100 / steps);
    
matblur = imgaussfilt(matr, s * (200/steps));
matblur = matblur / max(max(matblur));

glmcs       = graycomatrix(matblur); 
stats       = graycoprops(glmcs);    
SMsharp(s)    = sharpness(matblur);
meanz       = mean(mean(matblur));
SMcont(s)     = stats.Contrast;
ener        = stats.Energy; 
end
textprogressbar('Done');

% Modeling effects of variable scaling
%==========================================================================
factors = linspace(0,10,steps);
textprogressbar('Calculating ');
for s = 1:steps
textprogressbar(s*100 / steps);
    
matblur = imgaussfilt(matr, 100);
matblur = matblur * factors(s) / max(max(matblur));

glmcs       = graycomatrix(matblur); 
stats       = graycoprops(glmcs);    
SCsharp(s)  = sharpness(matblur);
meanz       = mean(mean(matblur));
SCcont(s)   = stats.Contrast;
ener        = stats.Energy; 
end
textprogressbar('Done');

% Modeling effects of noise
%==========================================================================
factors = linspace(0,30,steps);
textprogressbar('Calculating ');
for s = 1:steps
textprogressbar(s*100 / steps);
mtnoise = matr + randn(size(matr))/(30 - factors(s));
matblur = imgaussfilt(mtnoise, 100);
matblur = matblur * factors(s) / max(max(matblur));

glmcs       = graycomatrix(matblur); 
stats       = graycoprops(glmcs);    
NOsharp(s)  = sharpness(matblur);
meanz       = mean(mean(matblur));
NOcont(s)   = stats.Contrast;
ener        = stats.Energy; 
end
textprogressbar('Done');

%% Plotting results
%==========================================================================
subplot(3,1,1)
plot(SMsharp/max(SMsharp), 'r'); hold on;
plot(SMcont/max(SMcont), 'k');
title('Effect of smoothing');

subplot(3,1,2)
plot(SCsharp/max(SCsharp), 'r'); hold on;
plot(SCcont/max(SCcont), 'k');
title('Effect of scaling');

subplot(3,1,3)
plot(NOsharp/max(NOsharp), 'r'); hold on;
plot(NOcont/max(NOcont), 'k');
title('Effect of Noise');
legend('Sharpness', 'Contrast');
xlabel('Multiplication factor');
set(gcf, 'color', 'w');

