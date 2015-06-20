# 1. Merges the training and the test sets to create one data set.

# set working directory and read in the data
setwd('C:/Users/zhuha_000/Desktop/clean_data_project_1/UCI HAR Dataset')

subject_train = read.table('./train/subject_train.txt',header=F)
x_train = read.table('./train/x_train.txt',header=F)
y_train = read.table('./train/y_train.txt',header=F)

subject_test = read.table('./test/subject_test.txt',header=F)
x_test = read.table('./test/x_test.txt',header=F)
y_test = read.table('./test/y_test.txt',header=F)

# merge the two data sets
x = rbind(x_train, x_test)
y = rbind(y_train, y_test)
subject = rbind(subject_train, subject_test)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features = read.table('./features.txt', header=F)

# filter_variable selects the indices for mean and standard deviations. 
filter_variable = grep("-(mean|std)\\(\\)", features[, 2])
x = x[, filter_variable]
names(x) = features[filter_variable, 2]


# 3. Uses descriptive activity names to name the activities in the data set

activities = read.table('./activity_labels.txt', header=F)
y[, 1] <- activities[y[, 1], 2]
names(y) <- "activity"

# 4. Appropriately label the data set with descriptive variable names

names(subject) = 'subject'
final = cbind(x, y, subject)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data = ddply(final, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidy_data, './tidy_data.txt',row.names=TRUE,sep='\t')
