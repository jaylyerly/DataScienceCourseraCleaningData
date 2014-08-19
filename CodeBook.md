CodeBook
====


The Data
---
This data set includes data captured from the motion sensors in a Samsung Galaxy S smartphone from a number of subjects engaging in different physical activites.

A full description of the data is available at [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The data is included in this repository, but was originally retrieved from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)



The Variables
---
The final 'tidy' data set includes data indexed by the subject id and the activity.  The subject id ranges from 1 to 30.  Each person participating in the study was assinged a random id.  The activities include 

   * walking
   * walking up stairs
   * walking down stairs
   * sitting
   * standing
   * laying
   
Each piece of data in the 'tidy' data set is the average of the observed data for each subject and each activity.

The Transformations
---
The data set was transformed to meet these criteria:

  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement.
  3. Uses descriptive activity names to name the activities in the data set.
  4. Appropriately labels the data set with descriptive variable names.
  5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

To those ends, these steps were taken by the `run_analysis.R` script:

   * The data set independent input files were read from disk.  This included the names of the variables (features.txt) and the names of the activities (activity_labels.txt).
   * The variables contain the mean and standard deviation names were extracted from the list of variables.
   * The two data sets, 'test' and 'train', were read from disk.  
      * For each data set, the sensor data (X\_\*.txt), the activity data (y\_\*.txt)), and the subject ids (subject\_\*.txt) were loaded.
   * The train data set was appeneded to the test data set in order to merge the two into one data set used for the rest of the procedure.  This data set is a data frame called Xtest.
   * The variable names read from features.txt were used to set appropriate names in the Xtest data frame.
   * The subject ids were added to the Xtest data frame.
   * The activity names were added to the Xtest data frame.
      * The activity lables from activity_labels.txt were used to map the integer values to their proper text labels.
   * To derive the final 'tidy' data set, the Xtest data frame was melted and then recast with dcast using the mean() function to calculate the mean of the observed data per subject per activity.