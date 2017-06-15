
###################################################
#This script
#
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names.
# 5) From the data set in step 4, creates a second, independent tidy data set
#   with the average of each variable for each activity and each subject.
###################################################


## Download and unzip the dataset:

file_name <- "accelerator_data.zip"
if (!file.exists(file_name)){
  file_URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(file_URL, file_name)
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}

#################################################################
# 1) Merges the training and the test sets to create one data set.  
#################################################################

  # Read the data from the files with features and activity labels
features      <- read.table('UCI HAR Dataset/features.txt',header=FALSE)  
activity_name <-  read.table('UCI HAR Dataset/activity_labels.txt',header=FALSE)

# Read the data from the train set
subject_train <-  read.table('UCI HAR Dataset/train/subject_train.txt',header=FALSE)
x_train       <-  read.table('UCI HAR Dataset/train/x_train.txt',header=FALSE)
y_train       <-  read.table('UCI HAR Dataset/train/y_train.txt',header=FALSE)

# Read the data from the test set
subject_test <-  read.table('UCI HAR Dataset//test/subject_test.txt',header=FALSE)
x_test       <-  read.table('UCI HAR Dataset//test/x_test.txt',header=FALSE)
y_test       <-  read.table('UCI HAR Dataset//test/y_test.txt',header=FALSE)


# Assigin column names to the data imported above
colnames(activity_name)  <- c('ActivityId','ActivityName')
colnames(subject_train)  <- "SubjectId"
colnames(x_train)        <- features[,2]
colnames(y_train)        <- "ActivityId"
colnames(subject_test) <- "SubjectId"
colnames(x_test)       <- features[,2]
colnames(y_test)       <- "ActivityId"

# Create the training data set by merging y_train, subject_train, and x_train
training_data <- cbind(y_train,subject_train,x_train)

# Create the test data set by merging y_test, subject_test, and x_test
test_data <- cbind(y_test,subject_test,x_test)


# Combine training and test data to create a combined data set
combined_data <- rbind(training_data,test_data)

#################################################################
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
################################################################

# Create a vector for the column names from the combined data, which will 
# allow us to select the mean() & stddev() columns
col_names  = colnames(combined_data)

# Create a vector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
mean_std_vector = (grepl("Activity..",col_names) | grepl("Subject..",col_names) | grepl("-mean..",col_names) &
!grepl("-meanFreq..",col_names)  | grepl("-std..",col_names))

# Subset combined_data table based on mean_std_vector to keep only the needed columns

combined_data = combined_data[mean_std_vector==TRUE]

#################################################################
# 3) Uses descriptive activity names to name the activities in the data set 
################################################################


# Merge the combined data  set with the acitivity_name table to include descriptive activity names
combined_data <- merge(combined_data,activity_name,by='ActivityId',all.x=TRUE)

# remove the activity ID
combined_data  <- combined_data[,names(combined_data) != 'ActivityId']

# Updating the col_names vector to include the new column names after merge
col_names  <- colnames(combined_data)

#################################################################
# 4) Appropriately labels the data set with descriptive variable names.
################################################################

# Cleaning up the variable names
for (i in 1:length(col_names)) 
{
  col_names[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",col_names[i])
  col_names[i] <- gsub("[Gg]yro","Gyro",col_names[i])
  col_names[i] <- gsub("AccMag","AccMagnitude",col_names[i])
  col_names[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",col_names[i])
  col_names[i] <- gsub("JerkMag","JerkMagnitude",col_names[i])
  col_names[i] <- gsub("GyroMag","GyroMagnitude",col_names[i])
  col_names[i] <- gsub("\\()","",col_names[i])
  col_names[i] <- gsub("-std$","StdDev",col_names[i])
  col_names[i] <- gsub("-mean","Mean",col_names[i])
  col_names[i] <- gsub("^(t)","Time",col_names[i])
  col_names[i] <- gsub("^(f)","Frequency",col_names[i])
  col_names[i] <- gsub("([Gg]ravity)","Gravity",col_names[i])

}
# Reassigning the new descriptive column names to the finalData set
 colnames(combined_data) <-col_names

#################################################################
# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
#################################################################



# Summarizing the combined_data table to include just the average of each variable for each activity and each subject
 tidy_data    <- aggregate(subset( combined_data, select = -c(SubjectId, ActivityName) ),      
  by=list(activityName=combined_data$ActivityName,SubjectId = combined_data$SubjectId),mean) 
 
 #writing to file
write.table(tidy_data, './TidyData.txt',row.names=FALSE,sep='\t')
