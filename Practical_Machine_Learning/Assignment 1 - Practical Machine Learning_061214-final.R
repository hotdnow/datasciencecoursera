
# Practical Machine Learning
# June 2014


# Assignment 1


# Load required libraries

library(caret)
library(corrplot)

# Read in the training dataset and assign missing values to entries that are currently
# 'NA' or blank.

wm <- read.csv("Assignment_1-pml-training.csv", header = TRUE, na.strings = c("NA",""))
wm_test <- read.csv("Assignment_1-pml-testing.csv", header = TRUE, na.strings = c("NA",""))

# Columns in the orignal training and testing datasets that are mostly filled with missing
# values are then removed. To do this, count the number of missing values in each column of 
# the full training dataset. We use those sums to create a logical variable for each column 
# of the dataset. The logical variable's value is 'TRUE' if a column has no missing values 
# (i.e. if the colSums = 0). If there are missing values in the column, the logical variable's 
# value corresponding to that column will be 'FALSE'.
#
# Applying the logical variable to the columns of the training and testing datasets will only
# keep those columns that are complete. (Note: This is a way of applying 'complete.cases' 
# function to the columns of a dataset).
#
# Our updated training dataset now has fewer variables to review in our analysis. Further, our 
# final testing dataset has consistent columns in it (when compared with those in our slimmed-down 
# training dataset). This will allow the fitted model (based on our training data) to be applied to 
# the testing dataset.

csums <- colSums(is.na(wm))
csums_log <- (csums == 0)
training_fewer_cols <- wm[ , (colSums(is.na(wm)) == 0)]
wm_test <- wm_test[ , (colSums(is.na(wm)) == 0)]

# Create another logical vector in order to delete additional unnecessary columns from the pared-down
# training and testing datasets.. Column names in the dataset containing the entries shown in the 'grepl'
# function will have a value of 'TRUE' in the logical vector. Since these are the columns we want 
# to remove, we apply the negation of the logical vector against the columns of our dataset.

del_cols_log <- grepl("X|user_name|timestamp|new_window",colnames(training_fewer_cols))
training_fewer_cols <- training_fewer_cols[,!del_cols_log]
wm_test_final <- wm_test[,!del_cols_log]

# We now split the updated training dataset into a training dataset (70% of the observations) and a 
# validation dataset (30% of the observations). This validation dataset will allow us to perform cross
# validation when developing our model.

inTrain = createDataPartition(y=training_fewer_cols$classe, p = 0.70, list=FALSE)
small_train = training_fewer_cols[ inTrain, ]
small_valid = training_fewer_cols[-inTrain, ]

# At this point, our dataset contains 54 variables, with the last column containing 
# the 'classe' variable we are trying to predict. We begin by looking at the correlations
# between the variables in our dataset. We may want to remove highly correlated predictors 
# from our analysis and replace them with weighted combinations of predictors. This may allow
# a more complete capture of the information available.

corMat <- cor(small_train[,-54])
corrplot(corMat, order = "FPC", method = "color", type = "lower", tl.cex = 0.6, tl.col = rgb(0,0,0))

# This grid shows the correlation between pairs of the predictors in our dataset. From a 
# high-level perspective darker blue and darker red squares indicate high positive and high negative
# correlations, respectively. Based on this observation, we choose to implement a principal
# components analysis to produce a set of linearly uncorrelated variables to use as our predictors.
#
# We pre-process our data using a principal component analysis, leaving out the last
# column (classe). After pre-processing, we use the predict function to apply the pre-processing
# to both the training and validation subsets of the original larger 'training' dataset.

preProc <- preProcess(small_train[,-54], method = 'pca', thresh = 0.99)
trainPC <- predict(preProc, small_train[,-54])
valid_testPC <- predict(preProc, small_valid[,-54])

# Next, we train a model using a random forest approach on the smaller training dataset. We chose to 
# specify the use of a cross validation method when applying the random forest routine in the 
# 'trainControl()' parameter. Without specifying this, the default method (bootstrapping) would have 
# been used. The bootstrapping method seemed to take a lot longer to complete, while essentially 
# producing the same level of 'accuracy'.

modelFit <- train(small_train$classe ~ ., method = 'rf', data=trainPC,  trControl = trainControl(method = "cv", number = 4), importance = TRUE)
modelFit$finalModel

# We now review the relative importance of the principal components of the resulting modelFit.

varImpPlot(modelFit$finalModel, sort = TRUE, type=1, 
           pch=19, col=1, cex=.5, 
           main="Importance of the Individual Principal Components")

# As you look from the top to the bottom on the y-axis, this plot shows each of the principal components
# in order from most important to least important. The degree of importance is shown on the x-axis from
# left to right. Therefore, points high and to the right on this graph correspond to those principal 
# components that are especially valuable in terms of being able to classify the observed training data. 
#
#
# Call the 'predict' function again so that our trained model can be applied to our cross validation
# test dataset. We can then view the resulting table in the 'confusionMatrix' function's output to see
# how well the model predicted/classified the values in the validation test set (i.e. the 'reference' 
# values)
# 

pred_valid_rf <- predict(modelFit, valid_testPC)
confus <- confusionMatrix(small_valid$classe, pred_valid_rf)
confus$table

# The estimated out-of-sample error is 1.000 minus the model's accuracy, the later of which is provided
# in the output of the confusionmatrix, or more directly via the 'postresample' function. 

accur <- postResample(small_valid$classe, pred_valid_rf)
model_accuracy <- round(accur[[1]],3)
out_of_sample_error <- 1 - model_accuracy

# Apply the pre-processing to the original testing dataset, after removing the extraneous column labeled
# 'problem_id' (column 54). We then run our model against the testing dataset and display the
# predicted results.

testPC <- predict(preProc, wm_test_final[,-54])
pred_final <- predict(modelFit, testPC)
pred_final

