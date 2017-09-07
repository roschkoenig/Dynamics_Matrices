function D = ee_housekeeping

% Housekeeping
%==========================================================================
fs  	= filesep;

if      strcmp(computer, 'PCWIN64')
    Fbase       = 'C:\Users\rrosch\Dropbox\Research\Baldeweg Lab\1512 EE Transitions Data\1707 Multivariate';
    Fspm        = 'C:\Users\rrosch\Dropbox\Research\tools\spm';
    addpath('C:\Users\rrosch\Dropbox\Research\tools\Tools\k-Wave');
elseif  strcmp(computer, 'MACI64')
    Fbase       = '/Users/roschkoenig/Dropbox/Research/Baldeweg Lab/1512 EE Transitions Data/1707 Multivariate';  
    Fspm        = '/Users/roschkoenig/Dropbox/Research/tools/spm';
    addpath('/Users/roschkoenig/Dropbox/Research/tools/Tools/k-Wave');
end

Fscripts    = [Fbase fs 'Scripts'];
Fdata       = [Fbase fs 'Data'];
Fpatients   = [Fdata fs 'Patients'];
Fcontrols   = [Fdata fs 'Controls'];
Fanalysis   = [Fbase fs 'Analysis'];


addpath(Fspm);
addpath(Fscripts);

spm('defaults', 'eeg');

D.Fbase       = Fbase;
D.Fscripts    = Fscripts;
D.Fspm        = Fspm;
D.Fdata       = Fdata;
D.Fpatients   = Fpatients;
D.Fcontrols   = Fcontrols;
D.Fanalysis   = Fanalysis;