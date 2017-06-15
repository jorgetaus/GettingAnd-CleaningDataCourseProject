Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

- Download the data from the web and unzips it if it does not already exist in the working directory
- Read the Files and merges the training and the test sets to create one data set.
- Extracts from that dataset only the measurements on the mean and standard deviation for each measurement.
- Replaces the activity Ids with the activity names
- Labels the data set with moredescriptive variable names.
- Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- Writes that dataset to a text file
