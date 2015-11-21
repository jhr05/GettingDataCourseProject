
	
	## This program will combine test data and training data for wearable devices into one master file
	  
			## Start with the TEST data
	
	## The objective of this part of the code is to merge together three primary files:
	## subject_test.txt contains a list of subject ids that are associated with the activities
	##    and measurements found in the other two files
	## y_test.txt contains a list of activity codes that are associated with the measurements in the next file
	## X_test.txt contains detailed measurements for each subject/activity combination
	
	
	## Work with the subjects file first
	## Read in the file
	subject_test <- read.table("./test/subject_test.txt")
	## Associate column name with the file
	colnames(subject_test) <- c("subject_id")
	## Add an index field so that it will be easier to merge the data later
	subject_test$row_index <-seq.int(nrow(subject_test))
	
	## Now work with the activity data
	y_test <- read.table("./test/y_test.txt")
	## Associate column name with the file
	colnames(y_test) <- c("activity_id")
	
	## Add in the activity description from the activity_labels file
	activity_labels <- read.table("./activity_labels.txt")
	## Add some column names
	colnames(activity_labels) <- c("activity_id", "activity_description")
	y_test_with_descriptions = merge(y_test, activity_labels, all = TRUE)
	## Now add an index
	y_test_with_descriptions$row_index <- seq.int(nrow(y_test_with_descriptions))
	
	## X_test contains the actual measurement data; let's get it next
	x_test <- read.table("./test/X_test.txt")
	
	## The column names for this file are stored in the file features.txt
	features <- read.table("./features.txt")
	## Add some column names to this one
	colnames(features) <- c("feature_index", "feature_description")
	## Now apply them to the measurements file
	colnames(x_test) <- features$feature_description
	## And add an index
	x_test$row_index <- seq.int(nrow(x_test))
	
	## Now, start to assemble the test data
	first_phase_test_data <- merge(subject_test, y_test_with_descriptions, by.x = "row_index", by.y = "row_index")
	## Last, add in the measurements data
	combined_test_data <- merge(first_phase_test_data, x_test, by.x = "row_index", by.y = "row_index")
	
		## Now repeat with the TRAIN data
	
	## The objective of this part of the code is to merge together three primary files:
	## subject_train.txt contains a list of subject ids that are associated with the activities
	##    and measurements found in the other two files
	## y_train.txt contains a list of activity codes that are associated with the measurements in the next file
	## X_train.txt contains detailed measurements for each subject/activity combination
	
	
	## Work with the subjects file first
	## Read in the file
	subject_train <- read.table("./train/subject_train.txt")
	## Associate column name with the file
	colnames(subject_train) <- c("subject_id")
	## Add an index field so that it will be easier to merge the data later
	subject_train$row_index <-seq.int(nrow(subject_train))
	
	## Now work with the activity data
	y_train <- read.table("./train/y_train.txt")
	## Associate column name with the file
	colnames(y_train) <- c("activity_id")
	
	## We'll use the activity labels from before, so no need to read them in again
	y_train_with_descriptions = merge(y_train, activity_labels, all = TRUE)
	## Now add an index
	y_train_with_descriptions$row_index <- seq.int(nrow(y_train_with_descriptions))
	
	## X_train contains the actual measurement data; let's get it next
	x_train <- read.table("./train/X_train.txt")
	
	## The column names for this file are stored in the file features.txt, which we already have
	## Now apply them to the measurements file
	colnames(x_train) <- features$feature_description
	## And add an index
	x_train$row_index <- seq.int(nrow(x_train))
	
	## Now, start to assemble the training data
	first_phase_train_data <- merge(subject_train, y_train_with_descriptions, by.x = "row_index", by.y = "row_index")
	## Last, add in the measurements data
	combined_train_data <- merge(first_phase_train_data, x_train, by.x = "row_index", by.y = "row_index")
	
			## Ready to work with MERGED data
			
	## Now, merge the training data with the test data to get a combined master data set
	combined_master_data_set <- merge(combined_test_data, combined_train_data, all = TRUE)
	
	## Pull out only the columns containing the word "mean" or the word "std"
	
	subset_of_master_data <- combined_master_data_set[,c("subject_id","activity_id","activity_description",colnames(combined_master_data_set)[grep("mean",colnames(combined_master_data_set))], colnames(combined_master_data_set)[grep("std",colnames(combined_master_data_set))])]
	
	## Now we need to transform the data
	## First, change the subsetted data from "wide" form to "long" form
	library(reshape2)
	meltedData <- melt(subset_of_master_data, id=c("subject_id", "activity_id", "activity_description"))

	## Now, calculate the mean for each variable of interest
	tidyData <- dcast(meltedData, subject_id + activity_id + activity_description ~ variable, mean)

	## Write out a copy of the dataframe to a file for uploading to Coursera
	write.table(tidyData, file = "tidyData.txt", row.name=FALSE)
	
