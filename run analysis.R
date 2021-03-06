project
# following code will downlaod the zip file from https


url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="\\\\USREPFIL01/U292859$/Documents/dataset.zip")

# then unzip the zip files
unzip ("dataset.zip", exdir = "\\\\USREPFIL01/U292859$/Documents/dataset")

# list the files that unziped
list.files(path="\\\\USREPFIL01/U292859$/Documents/dataset")
list.files(path="\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset", recursive = TRUE)

#read data from the files into the variables

# following read activity files
activitytest<-read.table ("\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset/test/y_test.txt" ,sep="", header = FALSE)
str(activitytest)

activitytrain<-read.table ("\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset/train/y_train.txt", sep="", header = FALSE)
str(activitytrain)

# read features files
featuretrain<-read.table ("\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset/train/X_train.txt" ,sep="", header = FALSE)
feacturetest<-read.table ("\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset/test/X_test.txt",sep="", header = FALSE)
str(featuretrain) 
str(feacturetest) 

# follwoing read the subject files
subjecttrain<-read.table ("\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset/train/subject_train.txt" ,sep="", header = FALSE)
subjecttest<-read.table ("\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset/test/subject_test.txt" ,sep="", header = FALSE)
str(subjecttrain)
str(subjecttest)

head(subjecttrain)
tail(subjecttrain)

head(subjecttest)
tail(subjecttest)
# concatenate the data by rows

subject<-rbind(subjecttrain,subjecttest)
head(subject)
tail(subject)
activity<-rbind(activitytrain,activitytest)
head(activity)
tail(activity)

feature<-rbind(featuretrain,feacturetest)
head(feature)
tail(feature)

#set names to variables
names(subject)<-c("subject")
names(activity)<-c("activity")
featurenames<-read.table ("\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset/features.txt", sep="", header = FALSE)  
head(featurenames)
names(feature)<-featurenames$V2

# merge colomns from the datatable to get all data
datasubac<-cbind(subject,activity)
data<-cbind(datasubac,feature)
head(data)
str(data)
#2. Extract only the measurements on the mean and standard deviation for each measurement
#subset feacture names by measurement cotain mean and std
subfeacturenames<-names(feature)[grep("mean\\(\\)|std\\(\\)",featurenames$V2)]
head(subfeacturenames)
# subset data frame data by selected names of features
selectnames<-c(as.character(subfeacturenames),"subject","activity")
data<-subset(data,select=selectnames)
str(data)

# use descriptive activity names to name the activity in the data set
#read the activity label file
activitylables<-read.table ("\\\\USREPFIL01/U292859$/Documents/dataset/UCI HAR Dataset/activity_labels.txt", sep="", header = FALSE)
activitylables

# following code merge the activity code with activity label.
newdata<-merge(data, activitylables, by.x = "activity", by.y = "V1")
library(data.table)
setnames(newdata, "V2", "activity")

head(newdata$"activity",30)

head(newdata$"activity")
str(newdata)

#4, lable the data set with descriptive variable names


names(newdata)
names(newdata)<-gsub("

names(newdata)<-gsub("^t", "time", names(newdata))
names(newdata)<-gsub("^f", "frequency", names(newdata))
names(newdata)<-gsub("Acc", "Accelerometer", names(newdata))
names(newdata)<-gsub("Gyro", "Gyroscope", names(newdata))
names(newdata)<-gsub("Mag", "Magnitude", names(newdata))
names(newdata)<-gsub("BodyBody", "Body", names(newdata))

# create a second, independent tidy data set with average of each variable for each activity and each subject
library(plyr)
data2<-aggregate(. ~subject + activity, newdata, mean)
data2<-data2[order(data2$subject,data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)
