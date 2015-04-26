# Getting and Cleaning Data Project ReadMe

This ReadMe describes the steps taken in "run_analysis.R" script (uploaded with this file) to download, analyze and modify the raw data provided into a "tidy" data set.
Note that more detailed annotations are in the script, along with delineation of steps taken.

Note that the package "dplyr" needs to be installed as it is used in stage 5. 

## Step 1
Assuming the data is downloaded into your working directory, the commands in step 1 load up the original train and test sets provided (a preprocessed random 70%/30% split of the original dataset). 
The train and test datasets are merged with their respective activity (denoted as "y" in the raw data) and subject ("subj" in the raw data) labels, then merged together as "combined.data".
There should be a 10299 * 563 dataset at the end of this step, with no column names apart from "y" and "subj" in columns 562 and 563 respectively. This dataset is called "combined.data.2". 

## Step 2
We wish to extract the most simple summary measurements of the raw data - the mean and standard deviation. This is done by loading in the names of the variables "features.txt" and finding only those variables whose names contain either "mean" or "std". We select only those columns in "combined.data" and discard the rest.
There should be a 10299 * 88 dataset at the end of this step, with still no column names apart from "y" and "subj" in columns 87 and 88 respectively. This dataset is called "combined.data.2".

## Step 3
We replace the activity labels given (currently in integer form of 1-6) with more descriptive labelling; key from "activity_labels.txt" as follows:

1. walking
2. walkingupstairs
3. walkingdownstairs
4. sitting
5. standing
6. laying

The original text has had punctuation removed and all text changed to lower case. This is to "clean" and standardize written text in the dataset, as can be seen later in the transformation of column names.

There should be a 10299 * 88 dataset at the end of this step, with still no column names apart from "y" and "subj" in columns 87 and 88 respectively. The dataset is called "combined.data.2".

## Step 4
The column labels are loaded as "features.txt" with only the mean and standard deviation columns selected; what follows is 18 commands to replace the original opaque and cryptic variable names into something more descriptive.
Below is a brief summary of what was systematically changed and replaced:

* Removed all punctuation such as "(",")",",","-".
* All text to lower case
* Prefix "t" replaced with "timedomain"
* Prefix "f" replaced with "frequencydomain"
* "acc" replaced with "accelerometer"
* "mag" replaced with "magnitude"
* "gyro" replaced with "gyroscope"
* Column label "y" replaced with "activitylabels"
* Column label "subj" replaced with "subjectlabels"

There were also some specific manual changes made to variables 80-86 (angle(tBodyAccMean,gravity)...angle(Z,gravityMean)) to reflect the description of being an angle between the two enclosed vectors.
For more information on the exact variables please consult the codebook supplied.

There should be a 10299 * 88 dataset at the end of this step, with descriptive column titles, called "combined.data.2".

## Step 5
A new, independent dataset was generated from the one in step 4 by taking the average of each present variable by each activity and subject.
There should be a 180 * 88 dataset at the end of this step called "groupedmean". The dataset should be arranged by "activitylabels" followed by "subjectlabels" such that rows 1-30 cover the average subject data per "laying" activity, then rows 31-60 cover the average subject data per "sitting" activity etc. Columns "activitylabels" and "subjectlabels" should be the first two columns seen.

## Export data
The final dataset "groupedmean" is exported to your working directory as a txt file.

## Notes

The dataset generated at the end of step 5 should be considered "tidy" because (taken from Wickham [2]):
* Each variable forms a column
Each variable in "groupedmean" is in a column and are non-identical to each other. 

* Each observation forms a row
A row in "groupedmean" is the average of one subject's signal data for a particular activity; it is distinct from each and every other row and furthermore there are 180 rows, exactly matching the observations of 30 subjects doing 6 activities

* Each type of observational unit forms a table
All units in this dataset have been normalized such that they range from [-1 to 1] only, and can therefore be in the same table. 

The finalized dataset "groupedmean" can be easily read into R; just copy and paste the following code into R, careful to replace the file path with your own:
    groupedmean<-read.table(file_path,header=TRUE)
    View(groupedmean)
