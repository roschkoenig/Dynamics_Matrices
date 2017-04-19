%% Encephalopthy Synth Generation
%==========================================================================
% This routine illustrates the synthetic data generation used for
% statistical analysis in the manuscript

% Housekeeping
%==========================================================================
clear all
fs          = filesep;
D           = ee_housekeeping;
Fanalysis   = D.Fanalysis;
Fscripts    = D.Fscripts;
addpath(Fscripts);


%% Generate synthetic data based on specified signal
%==========================================================================
clear P
load([Fanalysis fs 'Example_Segment']);
allcount = 0;
filter   = {'all', 'delta', 'theta', 'alpha', 'beta', 'gamma'};

clearvars -except Fanalysis Fscripts filter allcount s fs C

% Load and Filter data
%----------------------------------------------------------------------
f = 1;
clear head data
head = C.head;
data = C.data; 

% Choose and apply band pass filter
%----------------------------------------------------------------------
switch filter{f}
    case 'all', Fbp = [0.5 60];   
    case 'delta', Fbp = [1 4];
    case 'theta', Fbp = [4 8];
    case 'alpha', Fbp = [8 13];
    case 'beta', Fbp = [13 30];
    case 'gamma', Fbp = [30 60];
end
data = ft_preproc_bandpassfilter(data, head.Fs, Fbp);
head.filter = filter{f};
data = ft_preproc_bandstopfilter(data, head.Fs, [49 51]);

% Generate synthetic time courses (based on empirical fft)
%----------------------------------------------------------------------
Fs      = head.Fs;
d       = data;
reps    = 5;

clear ivft
for c = 1:size(d,1) 
   ivft(c,:,:) = IAAFT(d(c,:), reps, 8);
end

win     = 2 * head.Fs;
seq     = 10 * head.Fs;

% Slide window across the synthetic time series to estimate dynamics
%----------------------------------------------------------------------
textprogressbar(['Repeating Measurements  ']);
count   = 0;
max     = (seq-win)*reps;

for r = 1:reps
    d   = squeeze(ivft(:,:,r));
    for w = 1:seq-win
        count       = count + 1;
        textprogressbar(fix(count*100/max));

        tcor        = (corr(d(:,w:w+win)'));
        n           = size(tcor,1);
        cor(w,:)    = tcor(find(tril(ones(n,n), -1)));
        for c = 1:size(data,1)
            pow(w,c)    = bandpower(data(c,w:w+win), head.Fs, Fbp);
        end
    end
    allcount = allcount+1;
    clear ccor cpow

    ccor(:,:) = corr(cor');
    cpow(:,:) = corr(pow'); 
end

ccors(f,:,:) = ccor;
cpows(f,:,:) = cpow;

textprogressbar(' Done');

%% Plotting routines
%==========================================================================
subplot(2,2,[1:2]), plot(data(2,:), 'k'); hold on
for i = 1:5
    plot(ivft(2,:,i) - 200*i, 'color', [0.6 0.6 0.6]);
end
ylim([-Inf Inf]);
xlim([-Inf Inf]);
axis off
legend({'Original', 'Substitutes'});
set(gcf, 'color', 'w')
xlabel('Time');
title('Synthetic Time Series Dynamics');

subplot(2,2,3), imagesc(squeeze(ccors)); axis square;
    title('Correlation Dynamics Matrix');
    set(gca, 'Xtick', [], 'YTick', []);
    xlabel('Time'); ylabel('Time');
    
subplot(2,2,4), imagesc(squeeze(cpows)); axis square; 
    title('Power Dynamics Matrix');
    set(gca, 'Xtick', [], 'YTick', []);
	xlabel('Time'); ylabel('Time');


