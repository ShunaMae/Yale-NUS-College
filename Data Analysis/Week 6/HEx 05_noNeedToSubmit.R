###########################################################
#                 Hands-On Exercise (HEx) 5               #
###########################################################
# No need to submit this file on Canvas, this is just     #
#  for you to practise.                                   #
###########################################################

###########################################################
## The innoculationData.xlsx Dataset 
###########################################################
# Overall Description: this dataset contains data on the immune response of an animal to 3 vaccination treatments.

# Description of individual variables:
#<indiv> is the unique identifier for each animal
#<weight> is the animals' weight in grams
#<sex> is the animals' sex
#<site> is the facility at which each animal was vaccinated and is a potential confounding variable
#<treatment> is the type of vaccination administered and is the main explanatory variable
#<titre> is the amount of antibodies produced as a proxy for immune response and is the response variable

library(tidyverse)
library(dplyr)
library(readxl)
###########################################################
##Section A: ANOVA
###########################################################
#(1) Import the innoculationData.xlsx dataset as inDa. [1 mark]
inDa <- read_excel("innoculationData.xlsx")

#(2) In this dataset, <titre> is the response variable. Convert whatever variable(s) need(s) to be converted to factor(s). [2 marks]
inDa <- inDa |>
  mutate(
    indiv = as.factor(indiv),
    sex = as.factor(sex),
    site = as.factor(site),
    treatment = as.factor(treatment)
  )

#(3) Draw separate boxplots to explore <titre> explained by:
#(a) <site>. [1 mark]
boxplot(inDa$site, inDa$titre)
#(b) <sex>. [1 mark]
boxplot(inDa$sex, inDa$titre)
#(b) <treatment>. [1 mark]
boxplot(inDa$treatment, inDa$titre)

#(4) Fit an ANOVA to explain <titre> by <site>. [2 marks]
q4 <- lm(titre ~ site, data = inDa)

#(5) Check assumptions graphically. Do you see any potential problems? [1 mark]
par(mfrow = c(2,2))
plot(q4)
# 

#(6) Check whether the residuals of the model are normally distributed. What is your conclusion? [1 mark]
shapiro.test(resid(q4))
# significant, so not normally distributed

#(7) Assume that the residuals are not normally distributed. Perform the correct test instead. [1 mark]
kruskal.test(titre ~ site, inDa)

#(8) Do pairwise Wilcoxon tests to compare every level of <site> with a Bonferroni correction. [2 marks]
pairwise.wilcox.test(x = inDa$titre, g = inDa$site, method = "bonferroni")

#(9) Interpret your result in words. [no marks]
# no significant difference between sites 

#(10) Use ggplot to produce an appropriate plot to graphically show your result. [2 marks]
inDa |>
  ggplot(aes(site, titre) ) +
  geom_boxplot(notch = T)

#(11) Fit an ANOVA to explain <titre> by <treatment> and <sex> (allowed to interact). [2 marks]
q11 <- lm(titre ~ treatment* sex, data = inDa)

#(12) Simplify the model till you reach the minimum adequate model. [3 marks]
summary(q11)
q12 <- update(q11, ~. -treatment:sex)
summary(q12)

#(13) Check the model assumptions graphically. [1 mark]


#(14) Check the normality of the residuals and the equality of variance assumptions. [3 marks]


#(15) Assume all assumptions are met, do pairwise t-tests to compare all levels of <treatment> with a Bonferroni correction and interpret the pairwise t-tests. [2 marks]


#(16) View and interpret the results of your final model. [no marks]


#(17) Using ggplot2, do an appropriate plot for the data. [3 marks]


#(Bonus question 1) Why do you think we checked the effect of <site> first in questions (4) to (10)? Do you think the result that was found is what the authors were hoping for? [2 marks]


#(Bonus question 2) If there was a difference between sites, would you have done the analysis in (11) any differently? If so, how? [1 mark]


###########################################################
##Section B: ANCOVA
###########################################################
#(18) We want to look for patterns in the rest of the dataset. Fit a model using <weight>, <site> and <sex> (together with all the possible interactions) to explain <titre>. [2 marks]


#(19)  What kind of model is this and why? [2 marks]


#(20) Simplify your model till you obtain the minimum adequate model. [6 marks]


#(21) Check all the assumptions both graphically and using statistical tests. [3 marks]


#(22) Assume all assumptions are met, interpret the results of your model. [no marks]


#(23) Do an appropriate plot to illustrate your results. [3 marks]


#(Bonus question 3) Based on all the above analyses, what explanatory variables do you think are important to explain <titre>? 
#Fit a model with these explanatory variables, simplify it, and check and interpret (including visualising) the results. [15 marks]


