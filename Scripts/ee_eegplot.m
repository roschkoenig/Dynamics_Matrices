%% Plot example EEG
%==========================================================================
% This function plots a ten second EEG section as average montage.

% Housekeeping
%--------------------------------------------------------------------------
D           = ee_housekeeping;
Fanalysis   = D.Fanalysis;

% Plot EEG trace across all channels
%--------------------------------------------------------------------------
lbl	= head.label;

for c = 1:size(data,1)
    if any(c==head.left), cl = [0.7 0 0]; end
    if any(c==head.centre), cl = [0 0 0]; end
    if any(c==head.right), cl = [0.4 0 0.7]; end
    timeaxis = linspace(0,10,10*head.Fs);
	plot(timeaxis, data(c, 1 + (1:10*head.Fs)) - 100*c, 'Color', cl); hold on 
end

title(['Control - aged: 6 months. Filter: ' head.filter]);
eeg = gca;
set(eeg, 'YTick', flip([-100*((1:length(head.label)))]));
set(eeg, 'YTickLabel', flip(head.label));
ylim([-Inf 100]);
xlabel('time in seconds');
set(gcf, 'Color', 'white');

