%% Encephalopthy Synth Generation
%==========================================================================
% This routine generates random variations of time series based the
% empirical EEG fourier spectra. These are then analysed like the empirical
% data to extract statistical measures of the correlation and powerband
% dynamics expected to occur by chance. The routine will save the
% statistics over 50 repetition, as well as an example dynamics matrix.
% This uses the choatic systems toolbox, and specifically the inverse IAFFT
% function

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

%% Run through all blocks in all subjects to generate synthetic data
%==========================================================================
clear P
allcount = 0;
filter   = {'all', 'delta', 'theta', 'alpha', 'beta', 'gamma'};

for s = 1:length(sub)
clearvars -except Fanalysis Fscripts p c sub filter allcount s fs

for b = 1:5
for f = 1:length(filter)
    % Load and Filter data
    %----------------------------------------------------------------------
    clear head data
    start = sub(s).blocks(b);
    [head data] = ee_read(sub(s), 0.2, start);
    
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
    reps    = 50;

    clear ivft
    for r = 1:reps
        ivft(:,:,r) = [generate_iAAFTn(d')]';
    end

    win     = 2 * head.Fs;
    seq     = 10 * head.Fs;

    % Slide window across the synthetic time series to estimate dynamics
    %----------------------------------------------------------------------
    textprogressbar(['Subject ' num2str(s) ', block ' num2str(b) ' ' filter{f} ': Repeating Measurements  ']);
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
 
        Pglmcs  = graycomatrix(cpow); 
        Pstats  = graycoprops(Pglmcs);    
        Dyn(f,b,r).Psharp   = sharpness(cpow);
        Dyn(f,b,r).Pmean    = mean(mean(cpow));
        Dyn(f,b,r).Pcont    = Pstats.Contrast;
        Dyn(f,b,r).Pener    = Pstats.Energy;
    
        Cglmcs  = graycomatrix(ccor); 
        Cstats  = graycoprops(Cglmcs);    
        Dyn(f,b,r).Csharp   = sharpness(ccor);
        Dyn(f,b,r).Cmean    = mean(mean(ccor));
        Dyn(f,b,r).Ccont    = Cstats.Contrast;
        Dyn(f,b,r).Cener    = Cstats.Energy;   
    end
    ccors(f,:,:) = ccor;
    cpows(f,:,:) = cpow;
    textprogressbar(' Done');
end
    subname = [sub(s).cond(1) '_' num2str(sub(s).age) '_' sub(s).name(1)];
    save([Fanalysis fs subname '_' num2str(b) '_synth_ccors.mat'], 'ccors');
    save([Fanalysis fs subname '_' num2str(b) '_synth_cpows.mat'], 'cpows');
    
end

save([Fanalysis fs subname '_synthstats'], 'Dyn');
clear Dyn
end
