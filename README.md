# STA 521: Project 2

This project is a case study of constructing cloud detection algorithms employed on satellite images. 

We split the data by blocks, employ a number of classfication methods and assess their performance by loss functions. 
The primary work of model fitting and cross validation (CV) is done via the `CVmaster` function. 
For any future users who want to reproduce our analysis or train classification methods based on new image data, please refer to the following. 

## Data Splitting 

Considering the non-independent nature of the image pixels, users should be careful when splitting the data for training and testing purposes. 
There are two non-trivial ways of data splitting used in this project. 

A. Horizontal Cut
The first method cuts each image horizontally in order to ensure that every resulting block has a reasonable portion of clouds and clear surfaces. Basically, each image is cut into five blocks by evenly dividing Y coordinates, and three of them would be used as training data, the rest two blocks are used as validation and testing respectively.
[split 1-1.pdf](https://github.com/sheny2/STA521-Project-2/files/10129049/split.1-1.pdf)

B. K-Means Clusters
The second method of blocked data splitting is to use the K-means algorithm. By selecting a cluster size of five, we can divide each image’s datapoints into five distinct groups (according to X-Y coordinates). Again, three of these are used for training data, one is for validation and the last one is for testing.
[split 2-1.pdf](https://github.com/sheny2/STA521-Project-2/files/10129051/split.2-1.pdf)

We recommend users to fit classification methods after both ways of data processing and verify that the CV results should be roughly similiar. 


## Usage of `CVmaster.R`:

The data used as input of the algorithm should be image pixels. For each pixel, it contains the following information:

-- Coordinates of the pixel: `Y-coord` and `X-coord`;

-- Expert labels of cloud or non-cloud: `Cloud` = `-1` or `1`;

-- Potential covaraites include `NDAI`, `logSD`, `CORR`, `DF`, `CF`, `BF`, `AF`, and `AN`.



## Usage of `ROC.R` 


