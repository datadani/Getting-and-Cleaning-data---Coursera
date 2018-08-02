library(dplyr)

setwd("D:/Learning/Courses (Attended)/Coursera/R/Data Science Specialization/3_Getting and Cleaning Data/Assignments")
#*************************************************
# Step 1: Merge of training and test sets
#*************************************************

# get data
if (!file.exists("data.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "data.zip", mode = "wb")
}

# unzip data
if (!file.exists("UCI HAR Dataset")) {
    unzip("data.zip")
}

# read data sets
trainingSubjects <- read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"))
trainingValues <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"))
trainingActivity <- read.table(file.path("UCI HAR Dataset", "train", "y_train.txt"))

testSubjects <- read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"))
testValues <- read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"))
testActivity <- read.table(file.path("UCI HAR Dataset", "test", "y_test.txt"))

features <- read.table(file.path("UCI HAR Dataset", "features.txt"), as.is = TRUE)

activities <- read.table(file.path("UCI HAR Dataset", "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

# merge data
humanActivity <- rbind(
    cbind(trainingSubjects, trainingValues, trainingActivity),
    cbind(testSubjects, testValues, testActivity)
)
colnames(humanActivity) <- c("subject", features[, 2], "activity")
rm(trainingSubjects, trainingValues, trainingActivity,testSubjects, testValues, testActivity)

# Step 2: Extraction of mean and standard deviation for each measurement
humanActivity <- humanActivity[, grepl("subject|activity|mean|std", c("subject", features[, 2], "activity"))]

# Step 3: Descriptive activity names
humanActivity$activity <- factor(humanActivity$activity, levels = activities[, 1], labels = activities[, 2])

# Step 4: Descriptive variable names
humanActivity$subject <- as.factor(humanActivity$subject)
humanActivityCols <- colnames(humanActivity)
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)
humanActivityCols <- gsub("^f", "frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "Stdev", humanActivityCols)
humanActivityCols <- gsub("^t", "time", humanActivityCols)
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)
colnames(humanActivity) <- humanActivityCols

# Step 5: From step 4, independent tidy data set with the averages for each activity and each subject
humanActivityMeans <- humanActivity %>% 
    group_by(subject, activity) %>%
    summarise_all(mean)
write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, quote = FALSE)
