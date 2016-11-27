setwd("D:/Coursera/GettingnCleaningData/Proj")

#***********************************************************************************
# 1. Merge the training and the test sets to create one data set.
#***********************************************************************************


## 1.1: download data from website qnd unzip it
if(!file.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/DatangetClean_Data.zip")
unzip("./data/DatangetClean_Data.zip", exdir = "./data")

## 1.2: load data
train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

test.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

## 1.3: merge train and test
trainDat <- cbind(train.subject, train.y, train.x)
testDat <- cbind(test.subject, test.y, test.x)
fullDat <- rbind(trainData, testData)



#***********************************************************************************
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
#***********************************************************************************

## 2.1: load feature name into R
featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

## 2.2:  extract mean and standard deviation of each measurement
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
finalData <- fullData[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", featureName[featureIndex])



#***********************************************************************************
# 3. Uses descriptive activity names to name the activities in the data set
#***********************************************************************************

## 3.1: load activity
activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

##3.2: replace activity names
finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])

#***********************************************************************************
# 4. Appropriately labels the data set with descriptive variable names.
#***********************************************************************************

names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))

#***********************************************************************************
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#***********************************************************************************

library(dplyr)
groupData <- finalData %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean))

write.table(groupData, "./MeanData.txt", row.names = FALSE)
