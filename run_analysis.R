# Load the dplyr package
library(dplyr)

#Define file name to save and target url
zipfilename<-"Dataset.zip"
zipfileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#check if already downloaded and un-ziped  before, otherwise download and unzip the data
if (!file.exists(zipfilename)){
  download.file(url=zipfileurl, destfile=zipfilename)
  unzip(zipfilename) 
}

# Step 1: Merges the training and the test sets to create one data set.

#read headers files
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

#read all files needed
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#merge the data train test

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)

#merge subject
subject_data <- rbind(subject_train, subject_test)

#  name the variables
names(x_data)<- features$V2
names (y_data)[1]<- "activity"
names(subject_data)[1]<- "subject"

# combine all data
all_data<-cbind(subject_data, y_data, x_data)

# Step 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
tidy_data<- all_data %>% select(subject, activity, contains("mean"), contains("std"))

#  Step 3. Uses descriptive activity names to name the activities in the data set
tidy_data$activity<- activities[tidy_data$activity,2]

# Step 4. Appropriately labels the data set with descriptive variable names. 
names(tidy_data)<-gsub("^t", "time",  names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency",  names(tidy_data))
names(tidy_data)<-gsub("Acc", "Accelerometer",  names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope",  names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body",  names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude",  names(tidy_data))

str(tidy_data)

#Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
f_data <-tidy_data %>% 
  group_by(subject, activity) %>% 
  summarise_all(mean)
str(f_data)
# write the final data
write.table(f_data, "finaldata.txt", row.name=FALSE)


