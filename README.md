# Getting and Cleaning Data Course Project


## Background

The Cousera topic 'Getting and Cleaning Data' requires the student to 
* read csv files
* interpret the data and develop a code book that describes the data
* create a clean data set that merges/joins disparate data
* removes excess columns, keeping only the columns that will be used for the final data summary, and
* stores the cleansed data in a csv file for later use or processing.

To assist with assessment, the deliverables specified in the assignment are __annotated.__
      
## Files submitted using git

`code book for activity labels.txt`  
`code book for activity to measurement.txt`  
`code book for feature labels.txt`  
`code book for measure data for x_train or x_test.txt`  
`code book for subject for train and test.txt`  
`code book for summarised data.txt`  

Calculated data set, for part 5 of the assignment  
`assignment_average_each_variable.csv`
  
`run_analysis.R`, code for getting and cleaning data  

# Steps for getting and cleaning the data

The dataset that was used for the assignment was downloaded as a zip file from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

with a summary being provided of the source data at
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The datasets were row ordered, meaning that row 1 of the X_train.txt corresponded to row 1 of the y_train.txt which gives the activity, 
and row 1 of the subject_train.txt which gives the subject who undertook the measurement. This was verified using the git-bash CLI of 
`wc -l` for each file.

The R script `run_analysis.R` gets and cleans the data by  
1.  Checks that all the files to be processes have been extracted to the data directory in the original hierarchy.
If any of the files are not 
found, then an error is returned immediately.
2.  Reads the activity_labels and feature_labels into data.tables. These tables use the first column as an identifier that is mapped to the measurements
through the `y_train.txt` or `y_test.txt` files.
3.  Reads the `X_train.txt`file into a data.table. The column names were assigned from the previously read feature_labes vector.
The data file has no idendifiers for subject or activity. Hence the sequence of the records must be preserved.
4.  Reads the activity (WALKING, SITTING etc) identifier, and adds this data as a futher column to the X_train data.table.  Assigns the appropriate column label.
5.  Reads the subject identifier, and adds this data as a further columnd to the X_trains data.table. 
Assigns the appropriate column label.
6.  Assigns a label identifing that this the 'train' data set. 

Repeat steps 3 to 6 for the 'test' data set.

7. The 'test' data set was appended to the 'train' data set. __1__
8. Keep only the columns that are 'mean' or 'std' within the features. The list of kept columns was specified using regular expressions, rather than 
explicilty listing the columns.__2__, __3__ & __4__
9. Merge the combined data set with the activity label identifiers from the measurment data set and the activity data set, to allow the clean data set to be presented.
10. Drop the column the activity identifier column, as it is redundent as the activity label is specified.
11. Melt the data.table to move the feature columns to a new column, thus moving from a wide data set to a tall data sat. Melting the data set
assisted with the calculation of the means in the next step.
12. Calculate the mean for each of subject/actiity/feature combinations.
13. Save the clean data set of the calculated means in the csv file `assignment_average_each_variable.csv` __5__

The returned value from the `run_analysis.R` function is the indepedant tidy data set with the average for each variable for each activity
and each subject.

# Discussion

This exercise highlighte several areas of Getting and Cleaning data. Specifically:
1. The organization of this data set was not documented, hence the participant need to review the data and determine the relationships 
(many to one, many to many, one to one, one to many) and process the data accoringly.
2. The brevity of the data sets, stored without record numbers and without column headings, added a constraint on the sequence the data sets
were cleansed. My experience is that I try to store column names and recored identifers in any data set. Trap for new players in Excel is to sort data
and find that you are unable to revert back to the original sequence if there is no identifier for each record.
3. If I was to re-do this assignment, I would only read the required columns, thus decreasing the memory foot-print for the analysis. Not 
critical for this assignment, but may be important for large data sets.

