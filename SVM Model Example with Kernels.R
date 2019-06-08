install.packages("e1071")
# load library e1071
library("e1071")
# load desired data
data(iris)
attach(iris)
# create subset "i" which excludes the "Species" column here
i <- subset(iris, select=-Species)
# confirm column Species do not appear in i
head(i) 
# assign "j" to include only the Species column and convert it to factors
j <- factor(Species)
j
# create the SVM model
model <- svm(i, j, probability = T) 
summary(model)
# run the prediction using the new model
pred <- predict(model, i) 
# outputs the results of the prediction, can compare the results of SVM prediction and the class data in the y variable
table(pred, j) 
# To output, view and compare the results:
pred
# compare to mtcars set
z <- subset(iris, select=Species)
z
#kernel package to see better predictions
# load the kernlab package
library(kernlab)
# fit the model
fit <- ksvm(Species~., data=iris)
summary(fit) 
# output predictions for the model
predictions <- predict(fit, iris[,1:4], type="response")
# summarize the accuracy of the model
table(predictions, iris$Species)