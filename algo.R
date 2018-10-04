load('data1')
set.seed(1)
dataset$ls_basin = factor(dataset$ls_basin, levels = c(0, 1))
dataset$soil=ordered(dataset$soil)
dataset$geology=ordered(dataset$geology)

# Feature Scaling
dataset[c(-4,-5,-6,-14)] = scale(dataset[c(-4,-5,-6,-14)])


dataset_pos<-subset(dataset, ls_basin==1)
dataset_neg<-subset(dataset, ls_basin==0)


#rm(dataset)
library(caTools)
set.seed(123)
no_ls_basin=length(dataset_pos$ls_basin)

split = sample.split(dataset_neg$ls_basin, SplitRatio = no_ls_basin/2)
split2 = sample.split(dataset_pos$ls_basin, SplitRatio = no_ls_basin/2)

library(dplyr)
training_set = rbind(subset(dataset_neg, split == TRUE),subset(dataset_pos, split2 == TRUE))
test_set = rbind(sample_n(subset(dataset_neg, split == FALSE),no_ls_basin/2),subset(dataset_pos, split2 == FALSE))

rm(split,split2)


# Fitting SVM to the Training set
# install.packages('e1071')
library(e1071)
classifier = svm(formula = ls_basin ~ .,
                 data = training_set,
                 type = 'C-classification',
                 kernel = 'linear',probability=TRUE)

# Predicting the Test set results
y_pred = predict(classifier, newdata = dataset[-6],probability=TRUE)

# Making the Confusion Matrix
cm = table(test_set[, 6], y_pred)

rm(classifier,dataset_pos,dataset_neg)
# Applying Grid Search to find the best parameters
# install.packages('caret')

library(doMC)
registerDoMC(cores = detectCores()-2)
print(Sys.time())
print('running caret')
library(caret)
# classifier = train(form = ls_basin ~ ., data = training_set, method = 'svmRadial')
classifier = train(form = ls_basin ~ ., data = training_set, method = 'rf')
classifier
classifier$bestTune
print(Sys.time())

y_true=dataset[6]
save(y_pred,y_true,classifier,file='svm_lin_full')
