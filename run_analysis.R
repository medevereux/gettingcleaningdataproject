#Getting and Cleaning Data Course Project

##Steps required:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set.
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set
#   with the average of each variable for each activity and each subject.

#Note that the package "dplyr" is used at stage 5, and therefore needs to be installed in order
# to be loaded.

#1
#Merges the training and the test sets to create one data set.

#Load and combine X_train, y_train and subject_train
#Load
setwd("~/Documents/Machine Learning/Data Science/Getting and Cleaning Data/Project/UCI HAR Dataset/train")
train<-read.table("X_train.txt")
train.y<-as.numeric(data.matrix(read.table("y_train.txt",col.names="train.y")))
train.subj<-as.numeric(data.matrix(read.table("subject_train.txt",col.names="train.subj")))

#Combine train datasets together
train$y<-train.y
train$subj<-train.subj

#Load and combine X_test, y_test and subject_test
#Load
setwd("~/Documents/Machine Learning/Data Science/Getting and Cleaning Data/Project/UCI HAR Dataset/test")
test<-read.table("X_test.txt")
test.y<-as.numeric(data.matrix(read.table("y_test.txt",col.names="test.y")))
test.subj<-as.numeric(data.matrix(read.table("subject_test.txt",col.names="test.subj")))

#Combine test datasets together
test$y<-test.y
test$subj<-test.subj

#Combine train and test datasets
combined.data<-rbind(train,test)

#2
#Extracts only the measurements on the mean and standard deviation for each measurement.

#Load features.txt
setwd("~/Documents/Machine Learning/Data Science/Getting and Cleaning Data/Project/UCI HAR Dataset")
features<-read.table("features.txt",colClasses=c("NULL","character"))

#Find column names in features containing strings "mean" and "std"
mean.and.std.loc<-grep("mean|std",features[,1],ignore.case=TRUE)

#Select columns with "mean" and "std" only and discard the rest (except for y and subject)
combined.data.2<-combined.data[,c(mean.and.std.loc,562:563)]

#3
#Uses descriptive activity names to name the activities in the data set.

#Load activity_labels.txt
activity_labels<-read.table("activity_labels.txt")

#Get rid of symbols, all text to lower case, expand opaque words for activity labels
activity_labels[,2]<-tolower(activity_labels[,2])
activity_labels[,2]<-sub("_","",activity_labels[,2],fixed=TRUE)

#Replace column values of "y" with activity labels
combined.data.2[["y"]]<-activity_labels[match(combined.data.2[['y']],activity_labels[['V1']])
                                        ,'V2']

#4
#Appropriately labels the data set with descriptive variable names.
features<-features[mean.and.std.loc,]

#Get rid of symbols, all text to lower case, expand opaque words for variables
features<-gsub("()","",features,fixed=TRUE)
features<-gsub("-","",features,fixed=TRUE)
features<-gsub("(","",features,fixed=TRUE)
features<-gsub(")","",features,fixed=TRUE)
features<-gsub(",","",features,fixed=TRUE)
features<-tolower(features)
features<-sub("bodybody","body",features,fixed=TRUE)
features[1:40]<-sub("t","timedomain",features[1:40],fixed=TRUE)
features[80:83]<-sub("t","timedomain",features[80:83],fixed=TRUE)
features[41:79]<-sub("f","frequencydomain",features[41:79],fixed=TRUE)
features<-sub("acc","accelerometer",features,fixed=TRUE)
features<-sub("mag","magnitude",features,fixed=TRUE)
features<-sub("gyro","gyroscope",features,fixed=TRUE)
features[80]<-"anglebetweentimedomainbodyaccelerometermeanandgravity"
features[81]<-"anglebetweentimedomainbodyaccelerometerjerkmeanandgravitymean"
features[82]<-"anglebetweentimedomainbodygyroscopemeanandgravitymean"
features[83]<-"anglebetweentimedomainbodygyroscopejerkmeanandgravitymean"
features[84]<-"anglebetweenxandgravitymean"
features[85]<-"anglebetweenyandgravitymean"
features[86]<-"anglebetweenzandgravitymean"
features<-sub("accelerometerjerk","linearacceleration",features,fixed=TRUE)
features<-sub("gyroscopejerk","gyroscopeangularvelocity",features,fixed=TRUE)
colnames(combined.data.2)<-c(features,"activitylabels","subjectlabels")

#5 
#From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.

#Calculate averages by activity and by subject
library(dplyr)
grouped<-group_by(combined.data.2,activitylabels,subjectlabels)
groupedmean<-summarise_each(grouped,funs(mean))

#Export finalized dataset as "groupedmean.txt" in your working directory
write.table(groupedmean,"groupedmean.txt",row.name=FALSE)
