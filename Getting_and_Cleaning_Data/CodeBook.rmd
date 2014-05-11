# CodeBook.md


## Assignment 1 - Getting and Cleaning Data

Purpose: This CodeBook file will describe the variables and the data used in the analysis.
This file should be read in conjunction with the accompanying Readme.md file.
 
### The source of data is as follows:
 
   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
 
The variables contained in the analysis are as follows (Note: some of the excerpts below are directly taken from the informational files accompanying the source data.)

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


### Feature Selection and Variables

Description of variables and variable names:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc and tGyro. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBody.Acc and tGravity.Acc) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBody.AccJerk) and (tBody.GyroJerk). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBody.AccMag, tGravity.AccMag, tBody.AccJerkMag, tBody.GyroMag, tBody.GyroJerkMag). 

These signals were used to estimate variables of the feature vector for each pattern in the X, Y and Z directions.



The variable names reflect the naming conventions described in the above paragraphs. In addition, please note that in the variable names below, 'mean' refers to 'mean value' and 'std' refers to 'standard deviation'

Accelerometer measurements of body signals:

tBody.Acc.mean.X,   
tBody.Acc.mean.Y,   
tBody.Acc.mean.Z   
tBody.Acc.stddev.X   
tBody.Acc.stddev.Y   
tBody.Acc.stddev.Z   

Accelerometer measurements of gravity signals:

tGravity.Acc.mean.X   
tGravity.Acc.mean.Y   
tGravity.Acc.mean.Z   
tGravity.Acc.stddev.X   
tGravity.Acc.stddev.Y   
tGravity.Acc.stddev.Z 

Accelerometer measurements of body Jerk signals:

tBody.AccJerk.mean.X   
tBody.AccJerk.mean.Y   
tBody.AccJerk.mean.Z   
tBody.AccJerk.stddev.X   
tBody.AccJerk.stddev.Y   
tBody.AccJerk.stddev.Z   

Gyroscope measurements of body signals:

tBody.Gyro.mean.X   
tBody.Gyro.mean.Y   
tBody.Gyro.mean.Z   
tBody.Gyro.stddev.X   
tBody.Gyro.stddev.Y   
tBody.Gyro.stddev.Z   

Gyroscope measurements of body Jerk signals:

tBody.GyroJerk.mean.X   
tBody.GyroJerk.mean.Y   
tBody.GyroJerk.mean.Z   
tBody.GyroJerk.stddev.X   
tBody.GyroJerk.stddev.Y   
tBody.GyroJerk.stddev.Z   

Magnitude of the accelerometer and gyroscope three-dimensional signals:

tBody.AccMag.mean   
tBody.AccMag.stddev   
tGravity.AccMag.mean   
tGravity.AccMag.stddev   
tBody.AccJerkMag.mean   
tBody.AccJerkMag.stddev   
tBody.GyroMag.mean   
tBody.GyroMag.stddev   
tBody.GyroJerkMag.mean   
tBody.GyroJerkMag.stddev   

In this analysis, means were calculated across all participants in the study for each of the above 40 variables. These means were provided by each of the six activities for which information was available (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING).


.
 
