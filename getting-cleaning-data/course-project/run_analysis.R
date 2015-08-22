# run_analysis.R
# Coursera: getting/cleaning data course project


# all of the required file names here
featuresName = 'features.txt'
activityName = 'activity_labels.txt'

trainSetName = 'X_train.txt'
trainLabelsName = 'y_train.txt'
trainSubjectsName = 'subject_train.txt'

testSetName = 'X_test.txt'
testLabelsName = 'y_test.txt'
testSubjectsName = 'subject_test.txt'

featuresdf = read.table(featuresName)
# instructions are ambiguous, assume we keep only "...mean()" and "...std()" features
featureskeeplv = grepl('.*(std\\(\\)|mean\\(\\))', featuresdf$V2)

# load the activity code->name translation
activitydf = read.table(activityName)

# load the training set and add activity names (not codes) and subject codes
traindf = read.table(file = trainSetName, colClasses = 'numeric', 
                     col.names = featuresdf$V2)[featureskeeplv]
traindf$activity = activitydf$V2[read.table(trainLabelsName)$V1]  # add activities
traindf$subject = read.table(trainSubjectsName)$V1

# load the test set and add activity names (not codes) and subject codes
testdf = read.table(file = testSetName, colClasses = 'numeric', 
                     col.names = featuresdf$V2)[featureskeeplv]
testdf$activity = activitydf$V2[read.table(testLabelsName)$V1]  # add activities
testdf$subject = read.table(testSubjectsName)$V1

# merge train and test 
mergedf = rbind(traindf, testdf)

# create a separate data set with mean of each activity/subject combination
mergelongdf = melt(mergedf, id.vars = c('subject', 'activity'))
sameansdf = dcast(mergelongdf, subject + activity ~ variable, mean)

