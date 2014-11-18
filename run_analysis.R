## Data Cleansing in Data Science
## Script name: run_analysis.R
## Date: Oct 26, 2014
## Author: Thomas Wong
## Assuming working directory starts at C:\user\documents\Data Science
## This script does the following. 
## 1.	Merges the training and the test sets to create one data set.
## 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.	Uses descriptive activity names to name the activities in the data set
## 4.	Appropriately labels the data set with descriptive variable names. 
## 5.	From the data set in step 4, creates a second, independent tidy data set with 
##    the average of each variable for each activity and each subject.
##
## 1.  Merges the training and the test sets to create one data set.
## 3.  Uses descriptive activity names to name the activities in the data set
## 4.  Appropriately labels the data set with descriptive variable names. 

library("plyr")
library("reshape2")
## Correlate activity description with activity ID
act_id <- as.factor(seq(1,6,by = 1))
act_name <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
              "SITTING","STANDING","LAYING");
activity <- data.frame(act_id,act_name); 
setwd("./data/UCI HAR Dataset/train")
train_subject <- readLines("subject_train.txt")
trSubject <- as.numeric(as.vector(train_subject))
trMeasure <- read.fwf("X_train.txt", width = 15)
train_activity <- read.fwf("y_train.txt", width = 15)
trActId <- as.vector(train_activity)
colnames(trActId) <- c("act_id")
trActivity <- merge(trActId,activity)
train <- cbind(trActivity$act_name, trSubject, trMeasure);
setwd("./Inertial Signals");
baxt <- read.fwf("body_acc_x_train.txt", width = 15);
bayt <- read.fwf("body_acc_y_train.txt", width = 15);
bazt <- read.fwf("body_acc_z_train.txt", width = 15);
bgxt <- read.fwf("body_gyro_x_train.txt", width = 15);
bgyt <- read.fwf("body_gyro_y_train.txt", width = 15);
bgzt <- read.fwf("body_gyro_z_train.txt", width = 15);
taxt <- read.fwf("total_acc_x_train.txt", width = 15);
tayt <- read.fwf("total_acc_y_train.txt", width = 15);
tazt <- read.fwf("total_acc_z_train.txt", width = 15);
train <- cbind(train,baxt,bayt,bazt,bgxt,bgyt,bgzt,taxt,tayt,tazt); 
colnames(train) <- c("Activity","Subject","TrainSet","body_acc_x","body_acc_y","body_acc_z","body_gyro_x","body_gyro_y","body_gyro_z","total_acc_x","total_acc_y","total_acc_z")
setwd("../../test");
test_subject <- readLines("subject_test.txt");
ttSubject <- as.numeric(as.vector(test_subject))
ttMeasure <- read.fwf("X_test.txt", width = 15);
test_activity <- read.fwf("y_test.txt", width = 15);
ttActId <- as.vector(test_activity)
colnames(ttActId) <- c("act_id")
ttActivity <- merge(ttActId,activity)
test <- cbind(ttActivity$act_name,ttSubject,ttMeasure);
setwd("./Inertial Signals");
baxtt <- read.fwf("body_acc_x_test.txt", width = 15);
baytt <- read.fwf("body_acc_y_test.txt", width = 15);
baztt <- read.fwf("body_acc_z_test.txt", width = 15);
bgxtt <- read.fwf("body_gyro_x_test.txt", width = 15);
bgytt <- read.fwf("body_gyro_y_test.txt", width = 15);
bgztt <- read.fwf("body_gyro_z_test.txt", width = 15);
taxtt <- read.fwf("total_acc_x_test.txt", width = 15);
taytt <- read.fwf("total_acc_y_test.txt", width = 15);
taztt <- read.fwf("total_acc_z_test.txt", width = 15);
test <- cbind(test,baxtt,baytt,baztt,bgxtt,bgytt,bgztt,taxtt,taytt,taztt); 
colnames(test) <- c("Activity","Subject","TrainSet","body_acc_x","body_acc_y","body_acc_z","body_gyro_x","body_gyro_y","body_gyro_z","total_acc_x","total_acc_y","total_acc_z")
combineData <- rbind(train,test)


## 2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
combineMelt <- melt(combineData, id = c("Activity","Subject"), measure.vars = c("TrainSet","body_acc_x","body_acc_y","body_acc_z","body_gyro_x","body_gyro_y","body_gyro_z","total_acc_x","total_acc_y","total_acc_z"))
sportDataMean <- dcast(combineMelt, Activity + Subject  ~ variable, mean)
sortedDataMean <- arrange(sportDataMean, Activity, Subject)
sportDataStdev <- dcast(combineMelt, Activity + Subject ~ variable, sd)
sortedDataStdev <- arrange(sportDataStdev, Activity, Subject)

print(sortedDataMean)
print(sortedDataStdev)

## 5.  From the data set in step 4, creates a second, independent tidy data set with 
##    the average of each variable for each activity and each subject.
sortedDataAverage <- arrange(sportDataMean, Activity, Subject)

## Display the results
print(sortedDataAverage)
