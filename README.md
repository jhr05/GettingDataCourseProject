# GettingDataCourseProject

he script “run_analysis.R” combines data collected from the accelerometers from the Samsung Galaxy S smartphone.  To run the script, change the working directory to the “UCI HAR Dataset” directory and enter the command: source(“run_analysis.R”) at the command prompt in the R console.

There are several basic kinds of data needed for the analysis.  First, there is “test” data collected from a subset of volunteers.  The “test” data consists of three files: subject_test.txt, which is a list of subject ids in integer form; y_text.txt, which is a list of activity ids in integer form; and X_test.txt, which is a list of measurements collected from the accelerometers.  When combined, the three files together give subject ids, activity ids, and accelerometer measurements.
  
“Train” data follows the same format as “test” data but is for a different group of subjects.  The files, subject_train.txt, y_train.txt, and X_train.txt, can be combined in the same way.
  
Finally, there is descriptive data that is useful for labeling the activities and the measurements.  activity_labels.txt provides descriptions for each activity id while features.txt provides descriptions for each measurement.

The script takes the following approach to combining the files, calculating means for all accelerometer measurements labelled “mean” or “std”, and producing a tidy data set:
  
1.	 Starting first with the TEST data
a.	Read in the subjects file (subjects_test.txt)
i.	Associate a column name with the file
ii.	Add an index field to the file for later ease in combining with other data
b.	Read in the activity file (y_text.txt)
i.	Associate a column name with the file
ii.	Read in activity descriptions from the activity_labels file
1.	Assign column names
iii.	Merge the activity data with the activity descriptions (y_test_with_descriptions)
c.	Read in the measurement data (X_test.txt)
i.	Read in the measurement descriptions from the features.txt file
1.	Add column names
ii.	Apply the column names to the measurement data
iii.	Add an index field for later ease in combining data
d.	Assemble the test data
i.	Merge the subject_test data with the activity_data
ii.	Merge the results of the previous step with the measurements data
2.	Repeat the process with the TRAIN data
a.	Read in the subjects file (subjects_train.txt)
i.	Associate a column name with the file
ii.	Add an index field to the file for later ease in combining with other data
b.	Read in the activity file (y_rain.txt)
i.	Associate a column name with the file
ii.	Read in activity descriptions from the activity_labels file
1.	Assign column names
iii.	Merge the activity data with the activity descriptions (y_train_with_descriptions)
c.	Read in the measurement data (X_train.txt)
i.	Read in the measurement descriptions from the features.txt file
1.	Add column names
ii.	Apply the column names to the measurement data
iii.	Add an index field for later ease in combining data
d.	Assemble the train data
i.	Merge the subject_train data with the activity_data
ii.	Merge the results of the previous step with the measurements data
3.	Merge the “test” data and the “train” data together
4.	Extract into a new data frame only those measurements containing the words “mean” or “std”
5.	Transform the data so that means may be calculated
a.	Use the “melt” function to transform the data from “wide” format to “long” format, keeping as id’s the subject_id, activity_id and activity_description and using all the measurement data as variables
b.	Use the “dcast” function to calculate the means for all the variables by subject_id, activity_id and activity_description
6.	Write the resulting data frame out to a text file for uploading
