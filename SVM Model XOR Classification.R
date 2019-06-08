install.packages("e1071")
library("e1071")
?svm
# Create a 4,2 array with the input values
x <- array(data = c(0,0,1,1,1,0,0,1),dim=c(4,2))
# Shows array you created
x
# vector of factors (outputs for the input values)
y <- factor(c(0,1,1,0))
y
# Train e1071 on what the correct responses are
model <- svm(x,y,type="C-classification")
# Model summary
summary(model)
print(model)
# SVM model predictions for the input values
predict(model,x)