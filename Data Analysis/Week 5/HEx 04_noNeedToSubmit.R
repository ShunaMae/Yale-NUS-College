###########################################################
#                 Hands-On Exercise (HEx) 4               #
###########################################################
# No need to submit this file on Canvas, this is just     #
#  for you to practise.                                   #
###########################################################

###########################################################
## The Data_EnvImpact.xlsx Dataset 
###########################################################
# Overall Description: this dataset contains data on the level of environmental impact within 93 sites

# Description of individual variables:
#<site> is an index variable identifying each specific site
#<impact> is a measure of the environmental impact within the site and is the response variable
#<area> is the land area of the site
#<alt> is the average altitude within the site
#<popn> is the number of humans living in proximity to the site (in thousands)
#<protected> represents whether the site has been given some form of protection, e.g. as a protected area or nature reserve
#<country> is the country in which the site is located

library(tidyverse)
library(readr)
library(ggplot2)
library(readxl)
library(pwr)

###########################################################
##Section A: Linear Regression
###########################################################
#(1) Import the "Data_EnvImpact.xlsx" dataset into R as a dataframe called <dEI>. [1 mark]
dEi <- read_xlsx("Data_EnvImpact.xlsx") 

#(2) Check the variable types and change any variables that should be changed to factors. [2 marks]
str(dEi)
dEi <- dEi |>
  mutate(
  site = as.factor(site),
  protected = as.factor(protected),
  country = as.factor(country)
  )

#(3) Let's do a power analysis to see whether we have a sufficiently large sample size. We want to fit a linear model using <popn> to explain 50% of the variation in <impact>.
#(a) What is your u-value? [1 mark]

1

#(b) What is your f2-value? [1 mark]

0.5/(1-0.5)

#(c) Perform the power analysis, what is your minimum sample size, n? [4 marks]
pwr.f2.test(u=1, f2=0.5/(1-0.5), sig.level = 0.05, power = 0.8)
1 + 8.17 + 1 = 10.17 
## n = 11

#(d) Based on this, do you have enough observations in the dEI dataset? [1 mark]
## yes 

#(4) We now want to see whether <popn> can explain <impact>. What kind of analysis is this? [1 mark]
## linear regression 

#(5) Fit the model and view the results. Does <popn> explain <impact>? [4 marks]
mod1 <- lm(impact ~ popn, data = dEi)
summary(mod1)
## yes 

#(6) Check the model assumptions by plotting diagnostic plots. Do you see any potential problems? [3 marks]
#par(mfrow = c(2,2))
plot(mod1)
## heteroschedasticity 
## not normally distributed 

#(7) Which observation looks responsible for a lot of these problems? [1 mark]
## 13

#(8) Try removing it, refitting the model and rechecking the assumptions. [4 marks]
View(dEi)

dEi_updated <- dEi |>
  filter(site != "13")

mod2 <- lm(impact ~ popn, data = dEi_updated)
summary(mod2)
plot(mod2)


###########################################################
##Section B: Multiple Linear Regression
###########################################################
#Note: Use the dataset with row 13 removed
#(9) We want to use <area>, <alt> and <popn> (including all the 2-way and 3-way interactions) to explain <impact>. Fit this model. [4 marks]
mod3 <- lm(impact ~ area * alt * popn, data = dEi_updated)
summary(mod3)

#(10) View the results, what term would you remove first? [1 mark]
mod3.1 <- update(mod3, ~.-area:alt)
summary(mod3.1)

#(11) Proceed with the entire stepwise simplification. What variables (and interactions, if any) are left in your minimum adequate model? [7 marks]
mod3.2 <- update(mod3.1, ~.-area:alt:popn)
summary(mod3.2)
mod3.3 <- update(mod3.2, ~.-area:popn)
summary(mod3.3)
mod3.4 <- update(mod3.3, ~.-alt:popn)
summary(mod3.4)
mod3.5 <- update(mod3.4, ~.-area)
summary(mod3.5)
:)

plot(mod3.5)

#(12) Trying using step() on the original maximal model instead. Are the results the same? [2 marks]
mod3.s <- step(mod3)
summary(mod3.s)

#(Bonus question) Interpret your results from (11), giving p-values and effect size for the variable(s) with significant effects. [4 marks]
