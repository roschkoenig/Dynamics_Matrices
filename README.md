# Network Dynamics Measures for EEG
_Code accompanying Rosch et al (2017): Network dynamics in the healthy and epileptic developing brain_

This repository contains code that can be used to reproduce analyses to identify differences in network dynamics between different resting state EEG patterns. This code was used for the above manuscript to describe abnormalities in network dynamics that characterise two severe epilepsy syndromes of early infancy, Ohtahara syndrome and West syndrome / Infantile Spasms. 

![Network Dynamics](https://cloud.githubusercontent.com/assets/12950773/25225095/39dc524e-25b8-11e7-8e05-4ef5d3aaec8e.png)

The code runs on Matlab (tested with 2016b) and requires a number of toolboxes to run:
* The [chaotic systems toolbox](https://uk.mathworks.com/matlabcentral/fileexchange/1597-chaotic-systems-toolbox) - to generate synthetic time series based on an existing fourier spectrum (included in this repo)
* The [k-Wave toolbox](http://www.k-wave.org/) - to estimate the sharpness in a two-dimensional image (included in this repo)
* [cbrewer](https://uk.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab) - to provide different colour palettes (included in this repo)
* [textprogressbar](https://uk.mathworks.com/matlabcentral/fileexchange/28067-text-progress-bar) - to easily visualise progress during slow computational steps (included in this repo)
* [Statistic Parametric Mapping](http://www.fil.ion.ucl.ac.uk/spm/) - For the filtering of EEG signals, this code relies on fieldtrip provided as part of the standard SPM distribution; this can be easily replaced by another filter method of your choice (_SPM is not included here_)

## Custom rotuines included in this repository
The repository includes a number of different routines to be run manually to illustrate the different analysis steps performed for the manuscript above. Most of these will produce a visual output and are further explained below. 

### Plot an example EEG segment
```
ee_eegplot
```
For illustration purposes, we are providing a single 10s window of normal EEG from a 6 month-old infant, which can be visualised by running `ee_eegplot`, which will produce the figure below. 

![Example EEG](https://cloud.githubusercontent.com/assets/12950773/25225066/24efc7da-25b8-11e7-8de2-9ba94c4a0818.png)

### Estimate dynamics matrices using a sliding window approach
``` 
ee_estimate
```
Based on such 10s EEG windows, the `ee_estimate` function will use a sliding window approach to estimate network-correlation dynamics and scalp bandpower distribution dynamics. This example function will use the normal EEG segment provided, and plot the derived correlation-dynamics and power-dynamics matrices for each filter band, this produces the figure at the top of this page. 

### Visualise the dynamics measures used for analysis
```
ee_visualise_measures
```
In order to visualise the measures used for further analysis, running `ee_visualise_measures` will perform the same analysis on a simple selection of synthetically generated matrices that differe in the smoothness of transitions between different regions, and in the amplitude of the difference contained in the matrix. The code will produce the illustrative figure below that is the basis for __Fig 3__ in the manuscript. 

<img src="https://cloud.githubusercontent.com/assets/12950773/25225984/3ce16076-25bb-11e7-92e6-afd04ef549d0.png" width="650"> </img>


### Analyse synthetic EEG time series
```
ee_synthgen
```
As part of the statistical analysis, we generated surrogate time series with known frequency compositions based on the existing EEG windows. The routine `ee_synthgen` will generate a few such time series and illustrate the dynamics matrices that are derived from performing the equivalent analysis to that performed in `ee_estimate`. This will result in the figure shown below, showing example surrogate time series, as well as the dynamics matrices. 

![Surrogate time series](https://cloud.githubusercontent.com/assets/12950773/25225096/39f00b4a-25b8-11e7-8414-cc8da14db957.png)

### Reproduce dotplots from Manuscript 
``` 
ee_dotplotfigures 
```
This function loads the dynamics measures estimated from our EEG segments and plots them using the `ee_dotplot` function to reproduce the figures shown in the manuscript as __Fig 6__. 

<img src="https://cloud.githubusercontent.com/assets/12950773/25225099/39f80642-25b8-11e7-9f56-cd7ff9b09fa0.png" width="650"> </img>

### Optimise thresholds for categorisation for single measure
```
ee_simanneal
```

<img src="https://cloud.githubusercontent.com/assets/12950773/25225101/3a126064-25b8-11e7-90e6-80c1a01e86dd.png" width="450"> </img>

### Perform k-means clustering to evaluate combinations of different measures
``` 
ee_kmeans
```

<img src="https://cloud.githubusercontent.com/assets/12950773/25225100/39fa729c-25b8-11e7-99c7-f2fa34fa84d4.png" width="450"> </img>

<img src="https://cloud.githubusercontent.com/assets/12950773/25225098/39f369a2-25b8-11e7-9ac3-cdd0659b2160.png" width="450"> </img>
