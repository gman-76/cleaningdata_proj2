library(dplyr)
data_labels<-read.table("activity_labels.txt", header = FALSE)
features<-read.table("features.txt", header = FALSE)
x_train_subject <- read.table("./train/subject_train.txt", header = FALSE)
x_train <- read.table("./train/X_train.txt", header = FALSE)
colnames(x_train)<-make.names(names=features$V2, unique=TRUE, allow_ = TRUE)
y_train <- read.table("./train/y_train.txt", header = FALSE)
y_train$obs<-1:dim(y_train)[1]
x_test_subject <- read.table("./test/subject_test.txt", header = FALSE)
x_test <- read.table("./test/X_test.txt", header = FALSE)
colnames(x_test)<-make.names(names=features$V2, unique=TRUE, allow_ = TRUE)
y_test <- read.table("./test/y_test.txt", header = FALSE)
y_test$obs<-1:dim(y_test)[1]
x_train$subject<-x_train_subject$V1
x_test$subject<-x_test_subject$V1
train_labels<-merge(data_labels,y_train,by.x="V1",by.y="V1",all=TRUE,sort=FALSE)
train_labels<-arrange(train_labels,obs)
test_labels<-merge(data_labels,y_test,by.x="V1",by.y="V1",all=TRUE,sort=FALSE)
test_labels<-arrange(test_labels,obs)
x_train$activity<-train_labels$V2
x_test$activity<-test_labels$V2
merged<-merge(x_train,x_test,all.x=TRUE,all.y=TRUE)
tidy_data<-select(merged,matches("[.]std[.]|[.]mean[.]|activity|subject"))
tidy_group<-group_by(tidy_data,subject,activity,add=TRUE)
tidy_summary<-summarise_each(tidy_group,funs(mean))
write.table(tidy_data,file="TIDY_DATA.txt",row.names = FALSE)
write.table(tidy_summary,file="TIDY_DATA_AVG_SUMMARY.txt",row.names = FALSE)
