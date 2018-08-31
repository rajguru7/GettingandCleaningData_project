
## Download and unzip the dataset:
if (!file.exists("getdata_dataset.zip")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, "getdata_dataset.zip", method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip("getdata_dataset.zip") 
}
# loading the test,train and labels datasets
y_train <-read.table("./UCI HAR Dataset/train/y_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
y_test <-read.table("./UCI HAR Dataset/test/y_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

# Extracting only the variables containg mean or std
names.x_train <- as.character(read.table("./UCI HAR Dataset/features.txt")[,2])
wantedfeatures <- c(grep("mean",names.x_train),grep("std",names.x_train))
names.x_train <- names.x_train[wantedfeatures]
x_train <- x_train[,wantedfeatures]
x_test <- x_test[,wantedfeatures]
names.x_train <- gsub('-mean', 'Mean', names.x_train)
names.x_train <- gsub('-std', 'Std', names.x_train)
names.x_train <- gsub('[-()]', '', names.x_train)
names(x_train) <- names.x_train
names(x_test) <- names.x_train
# Combining the datasets
data <- rbind(cbind(x_train,y_train,subject_train),cbind(x_test,y_test,subject_test))
names(data) <- c(names.x_train,'activity','subject')
data$activity <- factor(data$activity,levels = activity_labels[,1],labels = activity_labels[,2])
data$subject <- as.factor(data$subject)

#Taking mean of each feild and storing result in tidy.txt
splitdata<-split(data,list(data$activity,data$subject))
final <-as.data.frame(sapply(splitdata,function(x) { colMeans(x[,names.x_train])}))
write.table(final, "tidy.txt", row.names = FALSE, quote = FALSE)
