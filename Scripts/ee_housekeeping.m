function D = ee_housekeeping
% This function returns a single structure containing filepaths to the
% relevant analysis folder used by this example code

% Housekeeping
%==========================================================================
fs          = filesep;
Fbase       = '/Users/roschkoenig/Desktop/GitCode/Dynamics_Matrices';  


Fscripts    = [Fbase fs 'Scripts'];
Fanalysis   = [Fbase fs 'Analysis'];
addpath(Fscripts);

% Pack for Exporting
%--------------------------------------------------------------------------
D.Fbase       = Fbase;
D.Fscripts    = Fscripts;
D.Fanalysis   = Fanalysis;