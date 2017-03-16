run_analysis <- function() {
      library(data.table)
      library(dplyr)
      # Check that the source files are present.
      # if not found, then return to the user an error message
      result <- ""
      if (!(
            file.exists("data/UCI HAR Dataset/activity_labels.txt")
            &&
            file.exists("data/UCI HAR Dataset/features.txt")
            &&
            file.exists("data/UCI HAR Dataset/train/subject_train.txt")
            &&
            file.exists("data/UCI HAR Dataset/train/X_train.txt")
            &&
            file.exists("data/UCI HAR Dataset/train/y_train.txt")
            &&
            file.exists("data/UCI HAR Dataset/test/subject_test.txt")
            &&
            file.exists("data/UCI HAR Dataset/test/X_test.txt")
            &&
            file.exists("data/UCI HAR Dataset/test/y_test.txt")
      )) {
            result <-
                  "File(s) not found. Please extract zip file to ./data directory"
      }
      ## read the files into data.tables to allow the manipulation of the data
      activity_labels <- fread("data/UCI HAR Dataset/activity_labels.txt",col.names = c("activity_id","activity"))
      feature_labels <- fread("data/UCI HAR Dataset/features.txt",col.names = c("feature_id","feature"))
      ## read the training data into a table
      x_train <- fread("data/UCI HAR Dataset/train/X_train.txt", col.names = feature_labels$feature)
      x_train_activity_id <- fread("data/UCI HAR Dataset/train/y_train.txt",col.names="activity_id")
      x_train$activity_id <- x_train_activity_id$activity_id
      x_train_subject <- fread("data/UCI HAR Dataset/train/subject_train.txt",col.names="subject")
      x_train$subject <- x_train_subject$subject
      x_train$set <- "train"
      ## read the test data into a table
      x_test <- fread("data/UCI HAR Dataset/test/X_test.txt", col.names = feature_labels$feature)
      x_test_activity_id <- fread("data/UCI HAR Dataset/test/y_test.txt",col.names="activity_id")
      x_test$activity_id <- x_test_activity_id$activity_id
      x_test_subject <- fread("data/UCI HAR Dataset/test/subject_test.txt",col.names="subject")
      x_test$subject <- x_test_subject$subject
      x_test$set <- "test"
      # join both data sets
      x_train_and_test <- rbind(x_train,x_test)
      ## get a vector of the
      ## mean - columns that end in mean()-X, mean()-X or mean()-Z or Mean)
      ## std - columns that end in std()-X, std()-X or std()-Z 
      ## 
      ## columns that end in activity_id, subject and set - define the sample
      required_columns <- grep(".*mean\\(\\)-.*|.*std\\(\\)-.*|set|activity_id|subject|Mean\\)|Mean,gravity\\)",colnames(x_train_and_test),value=TRUE)
      
      
      x_train_and_test <- x_train_and_test[,required_columns,with=FALSE]
      x_train_and_test <- merge(x=x_train_and_test, y=activity_labels, by="activity_id" )
      ## drop the activity_id column as the information is contained in the literal activity coluumn
      x_train_and_test<- subset(x_train_and_test, select = -activity_id)
      ## reorder the columns for convenience, putting the subject, set and activity in the first three columns
      x_train_and_test<-x_train_and_test[,c(56:58,1:55)]
      temp <- melt(x_train_and_test ,id.vars=c("subject","set","activity"),measure.vars = 4:58)
      temp <- aggregate(value ~ subject + activity + variable, data=temp, FUN = mean)
      select(temp, subject, activity_label = activity, feature_label = variable, feature_mean = value )

      
}
