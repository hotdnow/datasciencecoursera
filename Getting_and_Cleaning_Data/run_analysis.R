
# Getting and Cleaning Data
# May 2014


# Assignment 1

# It is assumed the original zip file was unzipped as is into the 
# subdirectory called "UCI HAR Dataset" of the working directory

# Read in the original test and training datasets.
# Next, combine their content with rbind into a new dataframe called 'x_cmpl'

x_test = as.data.frame(read.table(file = "UCI HAR Dataset/test/X_test.txt", header = FALSE))
x_train = as.data.frame(read.table(file = "UCI HAR Dataset/train/X_train.txt", header = FALSE))
x_cmpl = rbind(x_test, x_train)

# Read in the original 'features" text file. Since it is read in as a column factor and I
# want to use this as the column headings for the test and training dataset created above, 
# one needs to transform this into a row vector. Only take the second row of the transformed
# vector (to get rid of the line numbers that appear in the first row).

features = as.data.frame(read.table(file = "UCI HAR Dataset/features.txt", header = FALSE))
features = (t(features))[2,]

# Use the entries as the column names in the combined test and training dataframe
colnames(x_cmpl) <- features

# This prelimanry review is based on those measures of mean and std deviation collected in the
# dataset for the time domain signals (prefixed with a 't') only. That is, prior to any 
# Fast Fourier Transforms having been  applied.
#
# In order to get eliminate the other columns, repeated use the 'grepl' function.
# The grepl function below is set up like this:  (A or B) and C
# A: keeps those column names with a string containing 'mean()'  (averages)
# B: keeps those column names with a string containing 'std()'   (std deviations)
# C: keeps those column names beginning with a lowercase 't'  (indicating time domain signals)
#
# The logical vector 'mean_and_sd' contains the resulting TRUEs and FALSEs indicating those
# rows that meet the (A or B) and C criteria

mean_and_sd <- ((grepl('mean()', colnames(x_cmpl))) | ((grepl('std()', colnames(x_cmpl))))) &
          (grepl('^t', colnames(x_cmpl)))

# Apply the mean_and_std logical vector against the columns of test and training dataframe (x_cmpl)
# only keeps the desired columns

x_mean_std <- x_cmpl[ ,mean_and_sd]

# These lines use the global substitution command to 'gsub' to programatically cleanup the
# original column names (as read in through the 'features' file above).
# The headings are spread out by inserting periods, removing parentheses, etc.

colnames(x_mean_std) <- gsub('Body', "Body.", colnames(x_mean_std))
colnames(x_mean_std) <- gsub('Gravity', "Gravity.", colnames(x_mean_std))
colnames(x_mean_std) <- gsub('-', "", colnames(x_mean_std))
colnames(x_mean_std) <- gsub('mean\\()', ".mean", colnames(x_mean_std))
colnames(x_mean_std) <- gsub('std\\()', ".stddev", colnames(x_mean_std))
colnames(x_mean_std) <- gsub('X', ".X", colnames(x_mean_std))
colnames(x_mean_std) <- gsub('Y', ".Y", colnames(x_mean_std))
colnames(x_mean_std) <- gsub('Z', ".Z", colnames(x_mean_std))

# Read in the activity codes for the test and training datasets.Then rbind the two separate files.
# I also labeled the column name for the single variable in the dataframe.

y_test = as.data.frame(read.table(file = "UCI HAR Dataset/test/y_test.txt", header = FALSE))
y_train = as.data.frame(read.table(file = "UCI HAR Dataset/train/y_train.txt", header = FALSE))
y_cmpl = rbind(y_test, y_train)
colnames(y_cmpl) <- "activ.number"

# Read in the participant identifiers in the study and then rbind the test and training datasets.
# I also labeled the column name for the single variable in the dataframe.

subj_test = as.data.frame(read.table(file = "UCI HAR Dataset/test/subject_test.txt", header = FALSE))
subj_train = as.data.frame(read.table(file = "UCI HAR Dataset/train/subject_train.txt", header = FALSE))
subj_cmpl = rbind(subj_test, subj_train)
colnames(subj_cmpl) <- "participant.number"

# Read in the activity number and label identifiers.  Label column names

activ_labels = as.data.frame(read.table(file = "UCI HAR Dataset/activity_labels.txt", header = FALSE))
colnames(activ_labels) <- c("activ.number", "activity")

# Merge the test and training activity code dataframe with the activity labels dataframe 
# in order to get the actual labels such as "walking', 'laying', etc. into the mix

y_cmpl <- (merge(activ_labels, y_cmpl, by = 'activ.number'))

# Create the final dataframe with activity labels, participant identifiers, readable column names,
# and the actual data for those chosen fields related to mean and standard deviation.

all_cmpl <- cbind(y_cmpl[2], subj_cmpl, x_mean_std)

# In order to calculate the mean in each column by the separate activities, first split the 
# large dataframe ('all_cmpl') into six pieces--corresponding to the six activities
#
# This was done by calculating a logical variable, for example, 
# 
#              [all_cmpl$activity == "WALKING",]
# 
# that tested whether the row in the large dataframe contained the activity label 'WALKING'.
# This results in TRUEs wherever the row had the 'WALKING' label and FALSE otherwise
# Applying this logical vector against the rows of the large dataframe, all_cmpl, serves
# to subset the 'all_cmpl' dataframe

all_cmpl_1 <- all_cmpl[all_cmpl$activity == "WALKING",]
all_cmpl_2 <- all_cmpl[all_cmpl$activity == "WALKING_UPSTAIRS",]
all_cmpl_3 <- all_cmpl[all_cmpl$activity == "WALKING_DOWNSTAIRS",]
all_cmpl_4 <- all_cmpl[all_cmpl$activity == "SITTING",]
all_cmpl_5 <- all_cmpl[all_cmpl$activity == "STANDING",]
all_cmpl_6 <- all_cmpl[all_cmpl$activity == "LAYING",]

# After the subsets are complete, calculate the means of the entries in each column only for
# those columns with numerical entries (3 through 42)

all_cmpl_1_mean <- colMeans(all_cmpl_1[3:42])
all_cmpl_2_mean <- colMeans(all_cmpl_2[3:42])
all_cmpl_3_mean <- colMeans(all_cmpl_3[3:42])
all_cmpl_4_mean <- colMeans(all_cmpl_4[3:42])
all_cmpl_5_mean <- colMeans(all_cmpl_5[3:42])
all_cmpl_6_mean <- colMeans(all_cmpl_6[3:42])

# Assemble the final single 'tidy' dataset by row binding the various means calculated on 
# the above lines of codes. The last step is the specify the row names in 'tidy'.

tidy <- rbind (all_cmpl_1_mean, all_cmpl_2_mean, all_cmpl_3_mean,
              all_cmpl_4_mean, all_cmpl_5_mean, all_cmpl_6_mean)
rownames(tidy) = c('WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS','SITTING','STANDING','LAYING')

# Create a comma-delimited file for uploading.

write.table(tidy, 'Assignment.1.Getting.and.Cleaning.Data.051014.txt', sep=',')

