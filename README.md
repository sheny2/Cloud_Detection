# STA 521: Project 2

This project is a case study of constructing cloud detection algorithms employed on satellite images. 

We split the data by blocks, employ a number of classfication methods and assess their performance by loss functions. 
The primary work of model fitting and cross validation (CV) is done via the `CVmaster` function. 
For any future users who want to reproduce our analysis or train classification methods based on new image data, please refer to the following. 

## Data Splitting 

Considering the non-independent nature of the image pixels, users should be careful when splitting the data for training and testing purposes. 
There are two non-trivial ways of data splitting used in this project. 

A. Horizontal Cut


<img width="467" alt="Screenshot 2022-11-30 at 10 41 55 PM" src="https://user-images.githubusercontent.com/67173948/204960704-55c14581-c714-451c-8044-88c243a6f75b.png">

B. K-Means


We recommend users to fit classification methods after both ways of data processing and verify that the CV results should be roughly similiar. 


## Usage of `CVmaster.R`:

The data used as input of the algorithm should be image pixels. For each pixel, it contains the following information:

-- Coordinates of the pixel: `Y-coord` and `X-coord`;

-- Expert labels of cloud or non-cloud: `Cloud` = `-1` or `1`;

-- Potential covaraites include `NDAI`, `logSD`, `CORR`, `DF`, `CF`, `BF`, `AF`, and `AN`.



## Usage of `ROC.R` 


