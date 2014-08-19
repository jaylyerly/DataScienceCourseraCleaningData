#!/usr/bin/env Rscript

library(plyr)
library(reshape2)

# voodoo to get the current directory
frame_files <- lapply(sys.frames(), function(x) x$ofile)
frame_files <- Filter(Negate(is.null), frame_files)
if (length(frame_files) > 0) {
    # sourced by RStudio
    PATH <- dirname(frame_files[[length(frame_files)]])
} else {
    # run directly from the command line
    PATH <- "."
}
print (c("Setting the working directory to:",PATH))
setwd(PATH)

# data set independent stuff -- applies to both
features_file <- "UCI_HAR_Dataset/features.txt"
features <- read.table(features_file, header=FALSE)
names(features) <- c("feature_id", "feature_factor")
features$feature_names <- as.character(features$feature_factor) 
# strip out the names of the measurements to keep (mean and standard deviation)
meanNames <- features[(grep("mean", features$feature_names)),][['feature_names']]
stdNames <- features[(grep("std", features$feature_names)),][['feature_names']]
keepNames <- c(meanNames, stdNames)

activities_file <- "UCI_HAR_Dataset/activity_labels.txt"
activities <- read.table(activities_file, header=FALSE)
names(activities)<-c("activity_id", "activity_label")

#data set dependent stuff 
X_test_file <- "UCI_HAR_Dataset/test/X_test.txt"
Xtest <- read.table(X_test_file, header=FALSE, colClasses = c("numeric"))

y_test_file <- "UCI_HAR_Dataset/test/y_test.txt"
ytest <- read.table(y_test_file, header=FALSE, colClasses = c("integer"))
names(ytest)<-c("activity_id")

subject_test_file <- "UCI_HAR_Dataset/test/subject_test.txt"
subjectTest <- read.table(subject_test_file, header=FALSE, colClasses = c("integer"))

X_train_file <- "UCI_HAR_Dataset/train/X_train.txt"
Xtrain <- read.table(X_train_file, header=FALSE, colClasses = c("numeric"))

y_train_file <- "UCI_HAR_Dataset/train/y_train.txt"
ytrain <- read.table(y_train_file, header=FALSE, colClasses = c("integer"))
names(ytrain)<-c("activity_id")

subject_train_file <- "UCI_HAR_Dataset/train/subject_train.txt"
subjectTrain <- read.table(subject_train_file, header=FALSE, colClasses = c("integer"))

# merge the raw datasets
Xtest <- rbind(Xtest, Xtrain)
ytest <- rbind(ytest, ytrain)
subjectTest <- rbind(subjectTest, subjectTrain)

# use the names in features to name the Xtest data
names(Xtest) <- features[['feature_factor']]

# reduce Xtest to the ones we want to keep
Xtest <- Xtest[,keepNames]

# add the subject ids to the data frame
Xtest$subject <- as.factor(subjectTest[[1]])

# map the activity ids to text labels and add to data frame
Xtest$activity <- join(ytest, activities,"activity_id")[['activity_label']]

melted <- melt(Xtest,  id.vars = c("activity","subject"))
avgData <- dcast(melted, subject ~ activity, mean, na.rm=TRUE)
print(avgData)
write.table(avgData, file = "avgData.txt", row.name=FALSE)
