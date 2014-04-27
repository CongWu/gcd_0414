#                     File: run_analysis.R
#                   Author: Sumit Bhardwaj
#              Description: R script to run analysis for peer assessment project
#              of Coursera course "Getting and Cleaning data" (Apr 2014)
#                 Created : Sat 04/26/14 20:22:07 -0700
#              Last Change: Sat 04/26/14 22:56:36 -0700
#

# Data:
# 1. UCI HAR dataset
# (https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip)
# is downloaded and unzipped in the folder "dataset" in the working directory
# Steps for this are in CodeBook.md

# Loading data from UCI HAR dataset
#
# Load the feature names from feature names
feature_names <- read.table('dataset/features.txt');

# Read Test data 
X_test <- read.table('dataset/test/X_test.txt');
y_test <- read.table('dataset/test/y_test.txt');
subject_test <- read.table('dataset/test/subject_test.txt');

# Read Training data 
X_train <- read.table('dataset/train/X_train.txt');
y_train <- read.table('dataset/train/y_train.txt');
subject_train <- read.table('dataset/train//subject_train.txt');

# Join Subject identification (subject), expriment data (X), and label (Y) to
# create the combined dataset
test_data <- cbind(subject_test, X_test, y_test);
train_data <- cbind(subject_train, X_train, y_train);

# For the combined dataset, create the combined variable names
var_names <- c("subject_id", as.character(feature_names[, 2]), "activity");
# Rename the names of the variables to descriptive names
names(test_data) <- var_names;
names(train_data) <- var_names;

#1. Merges the training and the test sets to create one data set.
full_data <- rbind(test_data, train_data)

#2. Extracts only the measurements on the mean and standard deviation for each
#measurement.
# 
# Mean variables are called "mean".
# Grep statement needs to exclude "meanFreq" variables
#
# This index will now have subject_id, activity, and meand and std variables.
mean_std_vars <- c(1, grep("mean[^F]", names(full_data)), grep("std", names(full_data)), 563);

#3. Uses descriptive activity names to name the activities in the data set.
activity_types <- factor(full_data[, 563]);
levels(activity_types) <- list(
	"Walking" = "1",
	"Walking upstairs" = "2",
	"Walking Downstairs" = "3",
	"Sitting" = "4",
	"Standing" = "5",
	"Laying" = "6"
);
#4. Appropriately labels the data set with descriptive activity names.
full_data[,563] <- activity_types;

# Keep only the mean and std variables
tidy_data <- full_data[, mean_std_vars];

#5. Creates a second, independent tidy data set with the average of each average
#for each activity and each subject. 
summary_data <- aggregate(full_data[,2:562], list(Subject_Id = full_data$subject_id, Activity = full_data$activity), mean);

write.table(tidy_data, "tidy_data.txt");
write.table(summary_data, "summary_data.txt");
