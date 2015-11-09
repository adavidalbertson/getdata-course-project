#READ ME
##Analysis
To reproduce the tidy dataset, source the script 'run_analysis.R'. The script requires that the packages dplyr and data.table be installed. The specific versions used were R 3.2.0, dplyr 0.4.3, and data.table 1.9.6. Earlier versions of the packages may work, but success is not guaranteed.

The script 'run_analysis.R' performs the following steps:

  1. load packages
  2. download and unzip original dataset
  3. read the necessary files from the dataset into data tables
  4. prepare activity and feature labels (some text processing is necessary to ensure labels are unique and readable)
  5. extract mean and standard deviation measurements from each variable in train and test datasets
  6. apply column names to train and test datasets
  7. add subject and activity columns to train and test datasets
  8. replace activity ids with readable labels in train and test datasets
  9. group train and test datasets by test subject and activity
  10. merge train and test datasets and regroup by subject and activity
  11. summarize full dataset by calculating mean of each variable by subject and activity
  12. write summary and feature labels to files
  13. clean up intermediate variables

##Result
After the script is run, four tables will be available in the environment:

  - 'HAR_data_full': the tidied and merged dataset
  - 'HAR_data_train': the tidied training dataset
  - 'HAR_data_test': the tidied test dataset
  - 'HAR_data_means': the tidied and summarized dataset (mean of each variable by subject and activity)

Additionally, the original dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip will have been downloaded and unzipped. The summarized dataset will be written to 'HAR_data_means.txt'. 

