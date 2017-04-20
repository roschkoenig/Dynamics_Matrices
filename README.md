# Network Dynamics Measures for EEG
_Code accompanying Rosch et al (2017): Network dynamics in the healthy and epileptic developing brain_

This repository contains code that can be used to reproduce analyses to identify differences in network dynamics between different resting state EEG patterns. This code was used for the above manuscript to describe abnormalities in network dynamics that characterise two severe epilepsy syndromes of early infancy, Ohtahara syndrome and West syndrome / Infantile Spasms. 

The code runs on Matlab (tested with 2016b) and requires a number of toolboxes to run:
* The [chaotic systems toolbox](https://uk.mathworks.com/matlabcentral/fileexchange/1597-chaotic-systems-toolbox) - to generate synthetic time series based on an existing fourier spectrum (included in this repo)
* The [k-Wave toolbox](http://www.k-wave.org/) - to estimate the sharpness in a two-dimensional image (included in this repo)
* [cbrewer](https://uk.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab) - to provide different colour palettes (included in this repo)
* [textprogressbar](https://uk.mathworks.com/matlabcentral/fileexchange/28067-text-progress-bar) - to easily visualise progress during slow computational steps (included in this repo)
* [Statistic Parametric Mapping](http://www.fil.ion.ucl.ac.uk/spm/) - For the filtering of EEG signals, this code relies on fieldtrip provided as part of the standard SPM distribution; this can be easily replaced by another filter method of your choice (_SPM is not included here_)

