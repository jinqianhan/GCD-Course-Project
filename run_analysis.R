## R script that 1. merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## create variables
library(dplyr)
alabel <- read.table("./activity_labels.txt")
feature <-read.table("./features.txt")
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subtest <- read.table("./test/subject_test.txt")
names(xtest) <- feature$V2

ytrain <- read.table("./train/y_train.txt")
xtrain <- read.table("./train/X_train.txt")
subtrain <- read.table("./train/subject_train.txt")
names(xtrain) <- feature$V2

## merge data
## first merge in subject and activity data columns into data
test <- cbind(subtest, ytest, xtest)
colnames(test)[1] <- "Subject"
colnames(test)[2] <- "Activity"

train <- cbind(subtrain, ytrain, xtrain)
colnames(train)[1] <- "Subject"
colnames(train)[2] <- "Activity"
## merge data from test and training data
merged <- rbind(train, test)

## extract names data from merged and determine if they include mean or std
datname <- names(merged)
meansd <- logical(length = length(datname))
for (i in 1:length(datname)) {
    if (i == 1 || i == 2) {
        meansd[i] <- TRUE
    } else {
        meansd[i] <- grepl("mean|std",datname[i])
    }
}
## subset out appropriate columns
newdat <- merged[, meansd]
## relabel Activity with corresponding label
joindat <- inner_join(newdat, alabel, by = c("Activity" = "V1"), copy = FALSE)
joindat <- rename(joindat, Activity = V2)
## bring the Activity label back to 2nd column
joindat <- joindat[,-2]
joindat <- joindat[, c(1,81,2:80)]

##get mean of the data by subject and activity via aggregate
tidydat <- aggregate(joindat, by=list(joindat$Activity, joindat$Subject), FUN = mean)
tidydat <- tidydat[,c(-2,-4)]
tidydat <- rename(tidydat, Activity = Group.1)
tidydat <- tidydat[, c(2,1, 3:81)]

write.table(tidydat, file = "tidydat.csv", row.names = FALSE)

