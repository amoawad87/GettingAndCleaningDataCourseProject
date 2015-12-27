library(data.table)
library(reshape2)

# Loading activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Loading data column names
features <- read.table("./UCI HAR Dataset/features.txt")

# Loading X_test and y_test
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(X_test) = features[,2]

y_test[,2] = activity_labels[y_test[,1],2]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Loading X_train and y_train
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(X_train) = features[,2]

y_train[,2] = activity_labels[y_train[,1],2]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features[,2])
X_test = X_test[,extract_features]
X_train = X_train[,extract_features]

# Bind test and train data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

#Merging 
alldata <- rbind(test_data, train_data)
wnt_data<- melt(alldata, id = c("subject", "Activity_ID", "Activity_Label"), measure.vars = setdiff(colnames(data), id_labels))

#Apply mean fun 
tidy_data   = dcast(wnt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")
