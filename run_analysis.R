## A script to:
##Here are the data for the project: 
##  
##  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##
##You should create one R script called run_analysis.R that does the following. 
##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive activity names. 
##5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.features<-read.table("features.txt")
activitylabels<-read.table("activity_labels.txt")
meanVectorN<-grep("mean\\(\\)",features$V2)
meanVector<-grep("mean\\(\\)",features$V2,value=TRUE)
stdVectorN<-grep("std\\(\\)",features$V2)
stdVector<-grep("std\\(\\)",features$V2,value=TRUE)
extraColumns<-c("subject","activity")
xTrain<-read.table("train/X_train.txt")
yTrain<-read.table("train/y_train.txt")
colnames(xTrain)<-features$V2
subjectTrain<-read.table("train/subject_train.txt")
colnames(subjectTrain)<-"subject"
colnames(yTrain)<-"activity"
Train<-cbind(xTrain,subjectTrain,yTrain)
xTest<-read.table("test/X_test.txt")
yTest<-read.table("test/y_test.txt")
colnames(xTest)<-features$V2
subjectTest<-read.table("test/subject_test.txt")
colnames(subjectTest)<-"subject"
colnames(yTest)<-"activity"
Test<-cbind(xTest,subjectTest,yTest)
oneset<-rbind(Train,Test)
colnames(oneset)<-colnames(Train)
sc<-oneset[c(meanVector,stdVector,extraColumns)]
scnames<-colnames(sc)
scnames<-gsub("^f","fastfouriertransform",scnames)
scnames<-gsub("^t","total",scnames)
scnames<-gsub("Body","body",scnames)
scnames<-gsub("Gyro","gyroscope",scnames)
scnames<-gsub("Acc","accelerometer",scnames)
scnames<-gsub("Jerk","jerk",scnames)
scnames<-gsub("Mag","mag",scnames)
scnames<-gsub("Gravity","gravityaccelerometer",scnames)
scnames<-gsub("\\-X","\\-x",scnames)
scnames<-gsub("\\-Y","\\-y",scnames)
scnames<-gsub("\\-Z","\\-z",scnames)
scnames<-gsub("\\-","",scnames)
scnames<-gsub("std\\(\\)","standarddeviation",scnames)
scnames<-gsub("mean\\(\\)","mean",scnames)
colnames(sc)<-scnames
dfsc<-data.frame(sc)
key<-data.frame(activitylabels)
avgs<-aggregate(dfsc,list(dfsc$subject,dfsc$activity),mean,na.rm=TRUE)
colnames(key)<c("activity","activityvalue")
avgs<-merge(avgs,key,by="activity")
avgs$Group.1<-NULL
avgs$Group.2<-NULL
avgs$activity<-NULL
write.csv(avg,file="tidyHARData.csv")
write.table(avgs,file="tidyHARData.txt",row.name=FALSE)

