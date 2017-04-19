%% Estimating CDM and PDM Matrices
%==========================================================================
% This routine estimates correlation and power dynamics on an example EEG
% using a sliding window approach. These matrices are the basis for all
% measurements taken subsequently for analysis. 

% Housekeeping
%==========================================================================
clear all
D           = ee_housekeeping;
Fscripts    = D.Fscripts;
Fanalysis   = D.Fanalysis;
addpath(Fscripts);
fs          = filesep;

% Manual definitions
%--------------------------------------------------------------------------
seg_sec     = 10;       % Segment to be evaluated in seconds
win_sec     = 2;        % Sliding window size in seconds

seg_min     = seg_sec / 60;

%% Estimating band specific delay-delay matrices 
%==========================================================================
load([Fanalysis fs 'Example_Segment']);
head            = C.head;
data            = C.data; 

filters         = {'all', 'delta', 'theta', 'alpha', 'beta'};
clear ccors cpows P

for f = 1:length(filters)
clear cor pow tcor ccor cpow

filter = filters{f};  

switch filter
    case 'all', Fbp = [0.1 60];   
    case 'delta', Fbp = [1 4];
    case 'theta', Fbp = [4 8];
    case 'alpha', Fbp = [8 13];
    case 'beta', Fbp = [13 30];
    case 'gamma', Fbp = [30 60];
end

% Apply selected bandpass filter
%--------------------------------------------------------------------------
data        = ft_preproc_bandpassfilter(data, head.Fs, Fbp);
head.filter = filter;
data        = ft_preproc_bandstopfilter(data, head.Fs, [49 51]);

% Sliding window - size 2s across 10s window
%--------------------------------------------------------------------------
win = win_sec * head.Fs;
seg = seg_sec * head.Fs;
textprogressbar(['Sliding Window Across (Filter: ' filter '):  ']);
for w = 1:seg-win
    textprogressbar(w*100/(seg-win));
    tcor        = (corr(data(:,w:w+win)'));
    n           = size(tcor,1);
    cor(w,:)    = tcor(find(tril(ones(n,n), -1)));
    for c = 1:size(data,1)
        pow(w,c)    = bandpower(data(c,w:w+win), head.Fs, Fbp);
    end
end
textprogressbar('Done');

ccor = corr(cor');
cpow = corr(pow');

cpows(f,:,:) = cpow;
ccors(f,:,:) = ccor;

P(f).name   = head.name;
P(f).Fs     = head.Fs;
P(f).filter = head.filter;

% Plotting routines
%==========================================================================

set(gcf, 'Position', [50 50 1800 1000])
colormap parula
r       = (f-1)*2;
l       = 2*length(filters);

% Plot Correlation Delay matrix (top row)
%--------------------------------------------------------------------------
subplot(5,l,[1 2 1+l 2+l]+r) 
    imagesc(ccor);
    axis square;
    mxc = max(max(ccor));
    title(['Example EEG ' filter]);
    ylabel('Correlation Delay Matrix');
    set(gca, 'YTicklabel', '');

% Plot Power Delay matrix (bottom row)
%--------------------------------------------------------------------------    
subplot(5,l,[1+3*l 2+3*l 1+4*l 2+4*l]+r), 
    imagesc(cpow); 
    set(gca, 'YTicklabel', '');
    axis square;
    ylabel('Power Delay Matrix');

% Plot example time traces
%--------------------------------------------------------------------------
subplot(5,l,[1+2*l 2+2*l]+r);
idx = head.centre(1:3);
for i = 1:length(idx)
    cols = bone(6);
    shift = max(max(data(idx,1+win:seg-win)));
    plot(data(idx(i), 1+win:seg-win)' + i*shift, 'Color', cols(i+2,:));
    ylim([0 (length(idx)+1)*shift]);
    xlim([-Inf Inf]);
    hold on
end

end


