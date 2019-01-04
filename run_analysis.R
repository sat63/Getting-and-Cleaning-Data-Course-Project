
## Add Library

library(reshape2)
library(dplyr)

## Unzip

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

zipfile <- "UCI HAR Dataset.zip"


if(!file.exists(zipfile)){
  download.file(zipUrl, zipfile, mode = "wb")
}

data <- "UCI HAR Dataset"
if (!file.exists(data)){
  unzip(zipfile)
}

## Load names of features and names of activities

activitylab <- read.table("UCI HAR Dataset/activity_labels.txt")
featurelab <- read.table("UCI HAR Dataset/features.txt")

## Read training data and read test data

# Training data

subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)

# Test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
xTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)


## Merge training and testing datasets 

sub <- rbind(subjectTrain, subjectTest)
act <- rbind(yTrain, yTest)
feature <- rbind(xTrain, xTest)

## Name and Merge columns

colnames(feature) <- t(featurelab[2])
colnames(sub) <- "Subject"
colnames(act) <- "Activity"
finaldata <- cbind(feature, sub, act)

##Extract measurements on mean and stdv for each measurement

colMeansandStdv <- grep(".*Mean.*|.*Stdv.*", names(finaldata), ignore.case = TRUE)

reqCol <- c(colMeansandStdv, 562, 563)
dim(finaldata) # Retrieve dimension of an object

exctractdata <- finaldata[,reqCol]
dim(exctractdata)

## Name activities in the data set
exctractdata$Activity <- as.character(exctractdata$Activity) # Change type from numeric to character
for (i in 1:6) {
  exctractdata$Activity[exctractdata$Activity == i] <- as.character(activitylab[i,2]) #assign activity label to activity variable
}

exctractdata$Activity <- as.factor(exctractdata$Activity)

## Names of variables
names(exctractdata)

## Replace acronyms in variable names
names(exctractdata) <- gsub("BodyBody", "Body", names(exctractdata))

names(exctractdata)

## Dataset with avg of each variable for activity and subject

exctractdata$Subject <- as.factor(exctractdata$Subject)

## Create Tidy.txt

tidy <- aggregate(.~Subject + Activity, exctractdata, mean)
tidy <- tidy[order(tidy$Subject, tidy$Activity),]
write.table(tidy, file = "Tidy.txt", row.names = FALSE)