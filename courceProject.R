library(reshape2)

fn <- "sgs.zip"  #samsung galaxy s

#check and download file - use http intead https
if (!file.exists(fn)){
  fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, fn, method="curl")
}  
# unzip the file if previously not done already - check the folder
if (!file.exists("UCI HAR Dataset")) { 
  #into the defualt locations
  unzip(fn) 
}

# read text the data into a table
activityLabelData <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabelData[,2] <- as.character(activityLabelData[,2])
featureData <- read.table("UCI HAR Dataset/features.txt")
featureData[,2] <- as.character(featureData[,2])

# Extract interesting data from the data freatures :mean,stddev
featureShortList <- grep(".*mean.*|.*std.*", featureData[,2])
j9<- grep(".*mean.*|.*std.*", featureData[,2])
featureShortList.names <- featureData[featureShortList,2]
featureShortList.names = gsub('-mean', 'Mean', featureShortList.names)
featureShortList.names = gsub('-std', 'Std', featureShortList.names)
featureShortList.names <- gsub('[-()]', '', featureShortList.names)


# Load the datasets
trX <- read.table("UCI HAR Dataset/train/X_train.txt")[featureShortList]
trY <- read.table("UCI HAR Dataset/train/Y_train.txt")
trSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
trAll <- cbind(trX, trY, trSub)

tstX <- read.table("UCI HAR Dataset/test/X_test.txt")[featureShortList]
tstY <- read.table("UCI HAR Dataset/test/Y_test.txt")
tstSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
tstAll <- cbind(tstX, tstY, tstSub)

# merge datasets and add labels
allData <- rbind(trAll, tstAll)
colnames(allData) <- c(featureShortList.names,"activity", "subject" )

# factors for activity and subject
allData$activity <- factor(allData$activity, levels = activityLabelData[,1], labels = activityLabelData[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
write.csv(allData.mean, "tidy.csv", row.names = FALSE, quote = FALSE) #easier to look at using xls
#END
