# See from the Sky: Examining Cloud Detection Algorithms on Arctic MISR Data

This project is a case study of constructing cloud detection algorithms employed on satellite images. 

We split the data by blocks, employ a number of classfication methods and assess their performance by loss functions. 
The primary work of model fitting and cross validation (CV) is done via the `CVmaster` function. 
For any future users who want to reproduce our analysis or train classification methods based on new image data, please refer to the following. 

## Data Splitting 

Considering the non-independent nature of the image pixels, users should be careful when splitting the data for training and testing purposes. 
There are two non-trivial ways of data splitting used in this project. 

A. Horizontal Cut
The first method cuts each image horizontally in order to ensure that every resulting block has a reasonable portion of clouds and clear surfaces. Basically, each image is cut into five blocks by evenly dividing Y coordinates, and three of them would be used as training data, the rest two blocks are used as validation and testing respectively.
<img width="762" alt="Screenshot 2022-11-30 at 10 45 18 PM" src="https://user-images.githubusercontent.com/67173948/205300391-2b5ea1c4-1fe1-44a6-9291-842211f44101.png">


B. K-Means Clusters
The second method of blocked data splitting is to use the K-means algorithm. By selecting a cluster size of five, we can divide each image’s datapoints into five distinct groups (according to X-Y coordinates). Again, three of these are used for training data, one is for validation and the last one is for testing.
<img width="759" alt="Screenshot 2022-11-30 at 10 45 04 PM" src="https://user-images.githubusercontent.com/67173948/205300382-255e3809-82cc-481c-ae99-1bca18e16a33.png">


There are, of course, other ways of splitting blocked data. We recommend future users to try to fit classification methods on different ways of data processing and verify that the CV results should be roughly similar. 


## Usage of `CVmaster.R`:

The data used as input of the algorithm should be image pixels. For each pixel, it contains the following information:

-- Coordinates of the pixel: `Y-coord` and `X-coord`;

-- Expert labels of cloud or non-cloud: `Cloud` = `-1` or `1`;

-- Potential covaraites include `NDAI`, `logSD`, `CORR`, `DF`, `CF`, `BF`, `AF`, and `AN`.

Users have the option to give a generic classification method, for example Logistic Regression, LDA, QDA, Naive Bayes and Boosting Trees.

Since it is cross validation, users could also choose K, the number of folds, and a loss function, which currently only has default as accuracy (1-misclassification error). 

The `CVmaster` function takes the above input and would return the training accuracy at each fold as well as an overall CV average accuracy. The CV accuracy is thus a useful metric of evaluating the performance of the classification method on the training data.


## More Model Assessment:

In addition to the CV training accuracy, there are more metrics that can be used to assess models. In particularly, for models that yield predictions in the form of probabilities, users could plot ROC curves and find the best cut-off values for classifications. 

The ROC curve of the model's prediction of test data and true test data's label can reveal how the model perform on the test data via the Area under the Curve (AUC). Based on our current data and methods, boosting trees usually yield the best results. We recommend users to carefully examine more than one assessments when fitting the classification methods on new image data.

In addition, ROC curves are useful in determining the cut-off values, particuarly for logistic regression and boosting trees. We find the best cuf-off threshold based on the Youden statistics.

Other model assessment metrics we use include precision and F1 scores, both of which support the claim that the boosting trees yield better performance in predicting cloud pixels. 

## Prediction

Following our analysis and model fitting, users may use a well-trained classification model to predict cloud on image data. There are, of course, chances of missclassification in the prediction. 

<img width="715" alt="Screenshot 2022-12-05 at 3 17 13 PM" src="https://user-images.githubusercontent.com/67173948/205734813-cb647579-2aaa-4acd-95af-87ac8f2457a9.png">



