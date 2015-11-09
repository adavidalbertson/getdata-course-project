## load packages
library(data.table) # 1.9.6
library(dplyr) #0.4.3

## download original dataset
download.file(
    'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
    'UCI_HAR_dataset.zip',
    method='curl',
    quiet = TRUE)
unzip('UCI_HAR_dataset.zip')

## import data
# labels
activity_labels <- fread('UCI HAR Dataset/activity_labels.txt')
feature_labels <- fread('UCI HAR Dataset/features.txt')
# train data
subject_train <- fread('UCI HAR Dataset/train/subject_train.txt')
activity_train <- fread('UCI HAR Dataset/train/y_train.txt')
HAR_data_train <- fread('UCI HAR Dataset/train/X_train.txt')
# test data
subject_test <- fread('UCI HAR Dataset/test/subject_test.txt')
activity_test <- fread('UCI HAR Dataset/test/y_test.txt')
HAR_data_test <- fread('UCI HAR Dataset/test/X_test.txt')

## consolidate and name columns
names(activity_labels) <- c('activity_id', 'activity_name')
names(feature_labels) <- c('feature_id', 'feature_name')
feature_labels <- feature_labels[grep('mean\\(\\)|std\\(\\)', feature_labels$feature_name),]
feature_labels$feature_name <- make.names(feature_labels$feature_name, unique = TRUE)
feature_labels <- mutate(feature_labels, feature_name = sub('[.]+$', '', feature_name))
feature_labels <- mutate(feature_labels, feature_name = sub('[.]{2,}', '.', feature_name))
feature_labels <- mutate(feature_labels, feature_name = sub('BodyBody', 'Body', feature_name))
# train
names(subject_train) <- c('subject')
names(activity_train) <- c('activity')
HAR_data_train <- select(HAR_data_train, feature_labels$feature_id)
names(HAR_data_train) <- feature_labels$feature_name
HAR_data_train <- bind_cols(subject_train, activity_train, HAR_data_train) %>%
    group_by(subject, activity)
HAR_data_train$activity <- activity_labels$activity_name[HAR_data_train$activity]
# test
names(subject_test) <- c('subject')
names(activity_test) <- c('activity')
HAR_data_test <- select(HAR_data_test, feature_labels$feature_id)
names(HAR_data_test) <- feature_labels$feature_name
HAR_data_test <- bind_cols(subject_test, activity_test, HAR_data_test) %>%
    group_by(subject, activity)
HAR_data_test$activity <- activity_labels$activity_name[HAR_data_test$activity]

## merge, summarize, and write datasets
HAR_data_full <- bind_rows(HAR_data_train, HAR_data_test) %>%
    group_by(subject, activity)
HAR_data_means <- summarize_each(HAR_data_full, funs(mean))
write.table(HAR_data_means, 'HAR_data_means.txt', row.names = FALSE)
    write.table(names(HAR_data_means),
        'features.txt',
        col.names = FALSE,
        quote = FALSE)

## clean up variables we don't need anymore
rm(activity_labels)
rm(feature_labels)
rm(activity_train)
rm(activity_test)
rm(subject_train)
rm(subject_test)