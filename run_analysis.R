library(dplyr)

#set working directory
if (getwd() != "D:/Program Files/R/RCoursera Quizes/Curso 4/finalAssignment/C4finalAssignment")
{
  setwd("./finalAssignment/C4finalAssignment")
}
filename = "data.zip"

#download data
if (!file.exists(filename))
{
  url <-
    'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(url, destfile = './data.zip')
}

#unizp data
if (!file.exists('UCI HAR Dataset'))
{
  unzip(filename)
}

#Make tables
features <-
  read.table("UCI HAR Dataset/features.txt", col.names = c("num", "variables"))
activity_labels <-
  read.table("UCI HAR Dataset/activity_labels.txt",
             col.names = c("num", "activity"))
subject_test <-
  read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <-
  read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$variables)
y_test <-
  read.table("UCI HAR Dataset/test/y_test.txt", col.names = "num")
subject_train <-
  read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <-
  read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$variables)
y_train <-
  read.table("UCI HAR Dataset/train/y_train.txt", col.names = "num")

#join data
subject <- rbind(subject_test, subject_train)
y <- rbind(y_test, y_train)
x <- rbind(x_test, x_train)
join_data <- cbind(subject, x, y)

#get means and standard deviations
clean_data <-
  select(join_data, subject, num, contains('mean'), contains('std'))

#changing nums for activities
clean_data$num <- activity_labels[clean_data$num, 2]

#label data variables
names(clean_data)[1] = "Person"
names(clean_data)[2] = "Activity"
names(clean_data) <- gsub("Acc", " Accelerometer ", names(clean_data))
names(clean_data) <- gsub("gravity", "Gravity ", names(clean_data))
names(clean_data) <- gsub("Gyro", " Gyroscope ", names(clean_data))
names(clean_data) <- gsub("BodyBody", "Body", names(clean_data))
names(clean_data) <- gsub("Mag", "Magnitude ", names(clean_data))
names(clean_data) <- gsub("^t", "Time ", names(clean_data))
names(clean_data) <- gsub("^f", "Frequency ", names(clean_data))
names(clean_data) <- gsub("angle", "Angle ", names(clean_data))

#create new dataset with average grouped by person and activity
new_data <- group_by(clean_data, Person, Activity)
new_data <- summarise_all(new_data, list(mean = mean))
write.table(new_data, "NewDataset.txt", row.name = FALSE)