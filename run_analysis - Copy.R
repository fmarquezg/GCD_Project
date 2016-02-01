#This script MUST be in the UCI HAR Dataset unzipped folder!
setwd('C:/Users/Lenovo/Documents/JHU/Cleaning/Project/UCI HAR Dataset')
library(dplyr)

#Load Train & Test data sets
X_train <-read.table('train/X_train.txt',quote="\"")
X_test<-read.table('test/X_test.txt',quote="\"")
y_train<-read.table('train/y_train.txt',quote="\"")
y_test<-read.table('test/y_test.txt',quote="\"")

#Ids of subject
subject_train<-read.table('train/subject_train.txt',quote="\"")
subject_test<-read.table('test/subject_test.txt',quote="\"")

#Feature AKA Column Names
feat<-read.table('features.txt',quote="\"")
#Load Activity Label Data Frame (1-6;activity types)
activityLab<-read.table("activity_labels.txt",quote="\"")
colnames(activityLab)<-c('Label','Activity')

#Rename V1 TO Label
colnames(y_train)<-c('Label')
colnames(y_test)<-c('Label')

#In the following steps do a procedure for Train dataset and will repeat then will apply the same procedure to Test
# dataset

###Begin Train Dataset process
#TRAIN Dataset
#Merge y_train & Activity Label
subject<-subject_train
colnames(subject)<-c('subject')
train<-cbind(y_train,subject)
train1<-merge(train,activityLab,by=("Label"))

#Name Features
#Assign Proper name to X_train dataset column
colnames(X_train)<-feat[,2]
#Join y_train, activityLab, X_train
train2<-cbind(train1,X_train)
#Remove column 1 ('Label') as it it irrelevant
train3<-train2[,-1]

#Filter only means and std columns
train4<- select(train3,contains("subject"), contains("Activity"), contains("mean"), contains("std"))
###End Train Dataset process

#We repeat the previous procedure now for Test Data
##Begin Test dataset process
#TEST DATA
subject_test<-subject_test
colnames(subject_test)<-c('subject')
test<-cbind(y_test,subject_test)
test1<-merge(test,activityLab,by=("Label"))

colnames(X_test)<-feat[,2]

#Join y_test,activityLab,X_test
test2<-cbind(test1,X_test)
test3<-test2[,-1]
test4<- select(test3,contains("subject"), contains("Activity"), contains("mean"), contains("std"))
###End Test Dataset process


#Comb TEST & TRAIN datasets into one (1) dataframe
comb<-rbind(train4,test4)


#Produce Summary Dataframe Grouping and calculating the MEAN by Subject AND Activity
end_summary<-comb%>%group_by(subject,Activity)%>%summarise_each(funs(mean))
#Export
write.table(end_summary,"./tidy_summary.txt",sep=" ",row.name=FALSE)

