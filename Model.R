library(tidyverse)
library(randomForest)
library(e1071)

load("E:/PM579_hw/PM579FinalProject/data/final.rdata")

#separate data
set.seed(666)
train_id = sample(nrow(dat),54)
dat = mutate(dat,cancer = as.factor(cancer))
dat_tree = dat[,-1]
train = dat_tree[train_id,]
test = dat_tree[-train_id,]

#random Forest

rf = randomForest(cancer~. ,data = dat_tree,subset = train_id,importance = TRUE)
importance(rf)
varImpPlot(rf)

yhat_rf = predict(rf,newdata = test)
table(yhat_rf,test$cancer)

#SVM
#Linear Boundary
#the smaller the cost,the wider the margin and therefore more sv
svm_lin = svm(cancer~.,data = train,kernel = "linear",cost = 100)
#support vectors
svm_lin$index

summary(svm_lin)
#10 folf cv in svm, results are the same
tune_out = tune(svm,cancer~.,data = train,kernel = "linear", ranges = list(cost = c(0.001,0.01,0.1,1,5,10,100)))
summary(tune_out)
bestmod = tune_out$best.model
summary(bestmod)
#predict results
yhat_svm_linear = predict(bestmod,test)
table(predict = yhat_svm_linear, truth = test$cancer)

#svm with non-linear boundary
svm_non_lin = svm(cancer~.,data = train,kernel = "radial",cost = 1)
summary(svm_non_lin)
#predict results
yhat_svm_non = predict(svm_non_lin,test)
table(predict = yhat_svm_non, truth = test$cancer)
