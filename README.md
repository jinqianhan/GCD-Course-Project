To run the script, simply set the working directory to where the test and training folders are located, then utilize
source("run_analysis.R")

It will take a while and some warnings will show up because of attempts to find mean of char strings, but that information is processed out.

The script works by first creating dataframes by reading in the data files in activity labels, features, xtest, ytest, subjecttrain, subjecttest, xtrain, ytrain.
The resulting x train and test data then have the names changed to match that in features, describing what each column represents.
Then the data is merged by first column binding the subjects and activity data, followed by row binding the test and train data.

The data is then processed by mean and std columns via a logical vector that tests to see if the column names contain "mean" or "std". This ignores the subject and activity column.
The resulting merged data is then merged with activity labels data to make the Activity column more descriptive. The duplicate activity column is deleted.
Then the data is finalized by aggregating the merged data by summarizing the columns organized by Subject and Activity with the mean function.

Finally, a tidydat.txt file is produced, with row.names=FALSE.
To see the read the txt file, simply call:
r<-read.table("tidydat.txt", header= TRUE)
View(r)
