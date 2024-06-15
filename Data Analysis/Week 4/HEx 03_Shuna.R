###########################################################
#                 Hands-On Exercise (HEx) 3               #
###########################################################
# This is what our HEx will look like                     #
# Write your R code here and submit this file on Canvas   #
# If you are asked to submit some screenshots/images,     #
#  paste them onto a word document and submit it too.     #
###########################################################

###########################################################
##Section A: Inspecting variables
###########################################################

library(readr)
library(tidyverse)
library(GGally)

#(1) Let's import the "Data_Biodiversity.txt" dataset into R as a dataframe called <dBio>. [1 mark]
dBio <- read_table("Data_Biodiversity.txt")

#(2) Change <specType> to a factor and inspect the data types to make sure. [2 marks]
dBio$specType <- as.factor(dBio$specType)
str(dBio)

#(3) Let's check all the continuous variables for outliers using boxplots (drawn using Base R code). [4 marks]

par(mfrow = c(1,4))
boxplot(dBio$dVal)
boxplot(dBio$weight)
boxplot(dBio$height)
boxplot(dBio$lifeEx)
## there are no outliers observed in the boxplots. 


#(4) Try plotting the same boxplots again using ggplot. [4 marks]
dBio |>
  select(-specType, -trapped) |>
  pivot_longer(
    cols = c("dVal", "weight", "height", "lifeEx"),
    names_to = "continuous_variables"
  ) |>
  ggplot(aes(continuous_variables, value)) +
  geom_boxplot()
## no outliers too 


#(5) Which was easier to do? [no marks]
## base R is easier to use 

#(6) Is <lifeEx> normally distributed? Check both graphically and using the Shapiro-Wilk test. [2 marks]
par(mfrow = c(1,1))
qqnorm(dBio$lifeEx)
shapiro.test(dBio$lifeEx)
## p-value of 0.02 and thus accept the alternative hypothesis
## not normally distributed 

#(7) Is <weight> normally distributed? Check both graphically and using the Shapiro-Wilk test. [2 marks]
qqnorm(dBio$weight)
shapiro.test(dBio$weight)
## qq plot differs from a straight line.
## p-value < 0.05 and thus accept the alternative hypothesis 
## it is not normally distributed

#(8) Check whether the variances in <weight> for the two groups in <specType> are equal. [3 marks]

## as the height is not normally distributed, 
## it is not appripriate to use var.test 
## because it assumes normal distribution 
shapiro.test(dBio$weight[dBio$specType == 'A'])
shapiro.test(dBio$weight[dBio$specType == 'B'])

## instead, we can use Levene's test 
## which is less sensitive to deviation from normality
library(car)
leveneTest(weight ~ specType, dBio)
## p-value is 0.08 and thus fail to reject the null hypothesis 
## the variance is equal 


###########################################################
##Section B: Simple tests (Part 1)
###########################################################
#(9) Do a ggpairs plot for all the variables. [1 mark]
dBio |> 
  ggpairs()

#(10) Do you see any potential patterns? [no marks]
plot(weight ~ height, dBio)
## there seems to be a positive correlation between height and weight 
## the weight seems to be split into two groups


#(11) Let's check the counts in the different categories of the variables <specType> and <trapped> individually. [2 marks]
dBio |>
  group_by(specType) |>
  summarise(count = n())
dBio |>
  group_by(trapped) |>
  summarise(count = n())

#(12) What kind of variables are <specType> and <trapped>: continuous or categorical? What "plot" would you do to visualise the data? [2 marks]

## specType: categorical 
## trapped: categorical (logistical)

#(13) Create a 2-way contingency table of the two variables: <specType> is the explanatory variable, <trapped> is the response variable. [2 marks]
dBio |>
  group_by(specType, trapped) |>
  summarise(n = n()) |>
  pivot_wider(names_from = trapped, values_from = n) 

#(14) Do you see any pattern here? [1 mark]

## there seems to be association between type a and being trapped 
## as well as type b and being untrapped. 

#(15) What test should we use to check whether the 2 variables are associated? [1 mark]
## fishers exact test

#(16) Perform the test in (15). What is the p-value? Are the 2 variables associated? [3 marks]
dBio |>
  group_by(specType, trapped) |>
  summarise(n = n()) |>
  ungroup() |>
  pivot_wider(names_from = trapped, values_from = n) |>
  select(-specType) |>
  fisher.test()

## p-value of 0.016 indicates that the there is likely to be an association 
## between specType and trapped. 

###########################################################
##Section C: Simple tests (Part 2)
###########################################################
#(17) Let's compare <height> in the two categories (A and B) of <specType>. What type are these two variables: continuous or categorical? [1 mark]
## spec type: categorical 
## height: continuous 
  
#(18) Based on my stated aim in (17), which variable should be on the x-axis and which should be on the y-axis? [1 mark]
## specType as x axis 
## height as y axis 
  
#(19) Based on your answers in (17) and (18), what test(s) should we use for this purpose and how do we determine which is the right test to use? (Hint: state what tests could be done and describe your thought process on how to choose the right one) [3 marks]

## the explanatory variable is categorical and response variable is continous. 
## the specimen is not paired. 
## if height is normally distributed, 
## it's either student's t-test (for equal variances) and Welch's test (for unequal variances)
## otherwise, carry out mann-whitney u test

#(20) Check both graphically and using the Shapiro-Wilk test whether <height> normally distributed. [2 marks]
qqnorm(dBio$height)
shapiro.test(dBio$height)
## p-value is greater than 0.05 and thus we fail to reject the null hypothesis
## we conclude that it is normally distributed 

#(21) Check whether the variances in <height> for the two groups in <specType> are equal. [3 marks]
var.test(height ~ specType, dBio)
## variances are equal 

#(22) Based on your answers in (20) and (21), perform the appropriate test to see whether the heights of species A and B are different. [2 marks]

## as height is normally distributed and the vairances are equal 
## carry out student's t-test
t.test(height ~ specType, dBio)
## p-value < 0.05 and thus we accept the alternative hypothesis 
## heights of type A and B are different

#(23) From your results in (22), state your conclusion and, if A and B are different, which species has a greater mean height. [2 marks]

## as the mean is greater in group A, 
## A has a greater mean height. 

#(24) Do an appropriate plot to visualise this result. [1 mark]
dBio |>
  ggplot(
    aes(specType, height)
  ) + 
  geom_boxplot()

#(Bonus question) <dVal2> below is the same measurement on the same specimens as <dBio$dVal>, but taken 6 months later.
#dVal2=c(48.77,108.24,100.30,111.96,86.61,65.13,77.26,119.16,106.11,78.59,78.65,61.51,98.62,78.46,92.78,103.12,73.51,120.25,62.38,107.74,112.14,109.98,61.94,75.64,93.76)
#Perform an appropriate test to check whether <dBio$dVal> and <dVal2> are significantly different. [4 marks]

dVal2=c(48.77,108.24,100.30,111.96,86.61,65.13,77.26,119.16,106.11,78.59,78.65,61.51,98.62,78.46,92.78,103.12,73.51,120.25,62.38,107.74,112.14,109.98,61.94,75.64,93.76)
## first, test the normality
shapiro.test(dBio$dVal)
shapiro.test(dVal2)
## they are both normally distributed 
## as the specimens are paired, 
## we do not have to check for the equal variances 
## we carry out paired t-test
t.test(dBio$dVal, dVal2, paired = TRUE)
## p-value is small enough to reject the null hypothesis 
## we conclude that dVal and dVal2 is significantly different. 
