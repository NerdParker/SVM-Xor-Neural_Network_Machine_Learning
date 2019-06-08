install.packages("neuralnet")
install.packages("ggplot2")

# Sample multivariate Gaussian distributions 
library(MASS)
# R neural networks package
library(neuralnet)

covariance_matrix <- matrix(c(0.05, 0, 0, 0.05), 2, 2)
covariance_matrix

# Number of points in each row
points_row <- 4000
# Rows 1-4
one <- mvrnorm(points_row, c(0, 0), covariance_matrix)
two <- mvrnorm(points_row, c(0, 1), covariance_matrix)
three <- mvrnorm(points_row, c(1, 0), covariance_matrix)
four <- mvrnorm(points_row, c(1, 1), covariance_matrix)

# Stacks points
all_rows <- rbind(one, two, three, four)
plot(all_rows)
values <- rep(c(0, 1, 1, 0), each = points_row)
plot(values)

# Combine points and values
xor_data <- as.data.frame(cbind(values, all_rows))
colnames(xor_data) <- c("values", "a", "b")
plot(xor_data)

# Number of rows we want to look at
number_rows <- 20
# Views rows
visualize_rows <- sample(1:nrow(xor_data), number_rows)
xor_data[visualize_rows, ]

library(ggplot2)
# Creates a nice visual of our data
ggplot(xor_data, aes(x = a, y = b, color = factor(values))) + geom_point() +
  scale_color_manual(name = "Values", values = c("gold", "maroon"), 
                     labels = c("False", "True")) +
  ggtitle("XOR Data") + xlab("A") + ylab("B")

# Creates a neural net
xor_neurel_net <- neuralnet("values ~ a + b", data = xor_data, threshold = 1,
                      # Number of units containing one hidden layer
                      hidden = c(20),
                      # Classification
                      linear.output = F, 
                      # Error Function
                      err.fct = "ce", 
                      # Activation Function
                      act.fct = "logistic") 
# Error reached so far
cat(sprintf("Error minimized to: %f", xor_neurel_net$result.matrix[c('error'), ]))

# Run a test on data, displays it and our prediction
initial_test <- data.frame(x = c(0, 0, 1, 1),
                        y = c(0, 1, 0, 1),
                        true_value = c(0, 1, 1, 0))
prediction <- compute(xor_neurel_net, initial_test[, c("x", "y")])$net.result
cbind(initial_test, prediction)

# Running a larger set of test data
larger_test <- data.frame(x = runif(10), y = runif(10))
larger_prediction <- compute(xor_neurel_net, larger_test)$net.result
cbind(larger_test, larger_prediction )

# Number of interpolating points
interpolating_points <- 100
a_values <- seq(0, 1, len = interpolating_points)
b_values <- seq(0, 1, len = interpolating_points)
test_points <- as.data.frame(expand.grid(a_values, b_values))
colnames(test_points) <- c("a", "b")
predictions <- compute(xor_neurel_net, test_points)$net.result
ggplot() + geom_point(aes(x = test_points$a, y = test_points$b, color = predictions)) +
  scale_color_gradient("Prediction", low = "purple", high = "gold") +
  ggtitle("Neural Network Decision Pattern") + xlab("A") + ylab("B")