# STA 521: Project 2

This project is a case study of constructing cloud detection algorithms employed on satellite images. 

We split the data by blocks, employ a number of classfication methods and assess their performance by loss functions. 
The primary work of model fitting and cross validation (CV) is done via the `CVmaster` function. 
For any future users who want to reproduce our analysis or train classification methods based on new image data, please refer to the following. 

## Data Splitting 

There are two non-trivial ways of data splitting used in this project. 




## Usage of `CVmaster.R`:

The data used as input of the algorithm should be image pixels. For each pixel, it contains the following information:

-- Coordinates of the pixel: `Y-coord` and `X-coord`;

-- Expert labels of cloud or non-cloud: `Cloud` = `-1` or `1`;

-- Potential covaraites include `NDAI`, `logSD`, `CORR`, `DF`, `CF`, `BF`, `AF`, and `AN`.



## Usage of `ROC.R` 


