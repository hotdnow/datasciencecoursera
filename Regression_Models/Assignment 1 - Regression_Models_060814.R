
# Regression Models
# June 2014


# Assignment 1


# An Analysis of the Relationship Between Miles per Gallon and Vehicle Transmission 
# ===================================================================================
     
# Executive Summary
#     
# The goal of the analysis was to explore Motor Trend Magazine's 1974 dataset, which
# comprises fuel consumption and 10 aspects of automobile design and performance for 
# 32 automobiles. The analysis seek answers to a couple of questions related to the 
# impact of the automobile's type of transmission and its impact on miles per gallon (MPG). 
# Specifically, the analysis sought to determine which type of transmission is better 
# for MPG and to quantify the difference in MPG when comparing automatic versus manual
# automobile transmissions.
#
# Our overall hypothesis is that while a manual transmission when considered in isolation 
# may serve to increase an automobile's resulting MPG, there are other factors such as weight
# and the number of cylinders, for example, that may have a larger impact on the final observed
# MPG figures.
#
# Read in the dataset and rename some of the column headings so they are more easily interpreted.
# Further, we create a new column in the dataset to contain a more descriptive entry
# for the transmission type. 

library(ggplot2)
data(mtcars)
wm <- as.data.frame(mtcars)

colnames(wm)[2] <- "cylinders"
colnames(wm)[6] <- "weight"
colnames(wm)[9] <- "trans.type"


for (i in 1:(nrow(wm))) {
     if (wm$trans.type[i] == 0) {
          wm$trans_descr[i] <- 'Automatic'
     }
     if (wm$trans.type[i] == 1) {
          wm$trans_descr[i] <- 'Manual'
     }
}

# The field "trans.type" indicates the type of transmission (0 = automatic, 1 = manual).
# We first do some initial exploratory analysis of our dataset by producing a 'pairs'
# plot to look for relationships between a few variables. We are especially interested 
# in relationships of variables to MPG.

pairs(~ mpg + trans.type + weight + cylinders, 
      data=wm, 
      panel = panel.smooth,
      main = "Scatterplot Matrices - Motor Trend Magazine's 'mtcars' Dataset",
      pch = 19, 
      col=rgb(0, 0, 1, 0.5))

# The first row of the scatterplots shows that MPG increases as a change is made from 
# an automatic transmission (trans.type = 0) to a car with a manual transmission 
# (trans.type = 1). Continuing along that row, one can see that MPG falls as the weight
# of the automobile increases and as the number of cylinders present in the vehicle
# increases. 
#
# We will now investigate the relative significance of these observations by running
# several statistical regressions. 
#
# The first regression is MPG versus transmission type. Note: Since we are using 'trans.type'
# as a factor variable in a model without the intercept term, the resulting estimated 
# coefficients will be the estimated average values for MPG for each type of transmission.

fit1 <- lm(mpg ~ factor(trans_descr) - 1, data = wm)
summary(fit1)
#confint(fit1, level = 0.95)

# Based on a review of the model's summary statistics, the type of transmission is statistically
# significant in terms of predicting the vehicle's MPG. As mentioned above, the resulting estimated coefficients are the estimated average values for MPG for each type of transmission.
#
# The estimated mean figure for automatic transmission vehicles is **`r summary(fit1)$coef[1]` 
# miles per gallon** and for manual transmission vehicles it is **`r summary(fit1)$coef[2]` miles
# per gallon**. 
#
# **Therefore, this model would predict a manual transmission is generally better for improved 
# miles per gallon. More specifically, the estimated increase in miles per gallon when using a 
# vehicle with a manual transmission (versus one with an automatic transmission) is
# `r summary(fit1)$coef[2] - summary(fit1)$coef[1]`.**
#
# We now plot the results of the first regression:
#

stat_sum_df <- function(fun, geom="crossbar", ...) {
               stat_summary(fun.data=fun, colour="red", geom=geom, width=0.2, ...) }

plot_fit1 <- qplot(factor(trans_descr), mpg, data=wm,
                   main = 'Miles per Gallon versus Transmission Type',
                   xlab = 'Type of Transmission',
                   ylab = 'Miles per Gallon'
                   ) +
               theme_bw() +
               annotate("text", x = 1.5, y = 9, label = "Means are shown in blue", col = "blue") +
               annotate("text", x = 1.5, y = 8, label = "95% confidence intervals are shown in red", col = "red") +
               stat_sum_df("mean_cl_normal", geom = "errorbar") +
               stat_summary(fun.y="mean", geom="point", shape=23, size=3, fill="blue", col = "blue")
                     
plot_fit1


#
# We now will plot the residuals resulting from this regression:
#

plot(resid(fit1), ylab="Residuals", main="Residuals - Transmission Type Predicting MPG", col = "blue")
abline(0, 0)

# It is reassuring to see there does not seem to be a pattern in the residuals.
#
# As a further diagnostic check we will review variance influence measures by running the
# 'influence.measures' suite of functions in R and looking to see if any entries are "*" 
# in the output's "inf" column.
#
influence.measures(fit1)$infmat
#
# Due to the absence of any asterisks, we have greater confidence there are no values in our
# dataset that are highly leveraging and/or influencing our results.
#
#
#
# As we saw above in the panel plots, other variables, such as weight, seem to influence a vehicle's
# final MPG to a larger extent than transmission type. We now run another regression to test
# that supposition by including the vehicle's weight as a confounder.
#

fit2 <- lm(mpg ~ weight + factor(trans_descr), data = wm)
summary(fit2)

# By looking at the summary statistics of the second regression model, we see the presence of the 
# "weight" variable in the regression model renders the transmission type no longer statistically 
# significant. This suggests when holding vehicle weight constant the transmission type on its own
# does not significantly influence a vehicle's MPG.
#
# In conclusion, our overall hypothesis was correct: A manual transmission may serve to increase an 
# automobile's resulting MPG when we do not control for other possible confounders. After holding 
# other variables constant, such as the vehicle's weight, the transmission type's impact on MPG 
# is no longer statistically significant.




