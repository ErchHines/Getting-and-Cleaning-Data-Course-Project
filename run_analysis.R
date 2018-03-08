#### Dowload the data ####
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="UCI.zip")
unzip("UCI.zip")

#### Read the files from the zip into R####
use.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

use.train.x <- read.table("UCI HAR Dataset/train/X_train.txt")
use.test.x <- read.table("UCI HAR Dataset/test/X_test.txt")

use.train.y <- read.table("UCI HAR Dataset/train/y_train.txt")
use.test.y <- read.table("UCI HAR Dataset/test/y_test.txt")

subjectsTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjectsTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

#### merge the training files and give the variables names ####
use.train <- cbind(use.train.x, use.train.y)
colnames(use.train) <- features$V2
use.train <- cbind(subjectsTrain$V1, use.train)
colnames(use.train)[1] <- "subject" 

#### merge the test files and give the variables names ####
use.test <- cbind(use.test.x, use.test.y)
colnames(use.test) <- features$V2
use.test <- cbind(subjectsTest$V1, use.test)
colnames(use.test)[1] <- "subject" 

#### merge the training and the test files, name the activity column ####
HCI <- rbind(use.train, use.test)
colnames(HCI)[563] <- "activity"
# created to view table in RStudio
# HCIView <- HCI[1:10,]

#### get a table with only the means and standard deviations,
# keeping the subject and activity columns ####
ms.HCI <- HCI[,(grepl("(subject|activity|mean\\(\\)|std\\(\\))", names(HCI)))]

#### create labels for the variables in the activity column####
ms.HCI$activity <- factor(ms.HCI$activity, levels = use.labels$V1, labels = use.labels$V2)

### gets averages for each subject and activity####
avg.ms.HCI <- aggregate( . ~ subject + activity, data = ms.HCI, mean)

#### writes table to a second tidy data set ####
write.table(avg.ms.HCI, "dataset.txt", row.names = FALSE)

