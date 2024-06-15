###########################################################
#                Hands-On Exercise (HEx) 6                #
###########################################################
# Write your R code here and submit this file on Canvas   #
# If you are asked to submit some screenshots/images,     #
#  paste them onto a word document and submit it too.     #
###########################################################

###########################################################
## The SiteSuitability.xlsx Dataset 
###########################################################
# Overall Description: this dataset contains data on how suitable various marine sites are for potential restoration.

# Description of individual variables:
#<index> is a measure of the suitability of a site for restoration
#<group> represents the geographical grouping of the sites and is an explanatory variable
#<grown> reflects whether coral implantation has taken place at that site and is an explanatory variable
#<abund> is a measure of the biodiversity at that site and is an explanatory variable
#<par> is a measure of the sunlight received at each site and is an explanatory variable


###########################################################
##Section A: GLS
###########################################################
#(1) Import the SiteSuitability.xlsx dataset as d1 and convert any variable type that needs to be converted. [no marks]
library(tidyverse)
library(readxl)
d1 <- read_xlsx("SiteSuitability.xlsx") |>
  mutate(group = as.factor(group),
         grown = as.logical(grown))

#(2) In this dataset, <index> (a measure of the suitability of a site for restoration) is the response variable.
#(a) Plot <index> against <group>. Do you see any potential inequality of variance? Why? [1 mark]
plot(d1$group, d1$index)
## Yes, there is a potential inequality of variance, as the size of boxes differ a lot between groups.

#(b) Plot <index> against <abund>. Do you see any potential heteroscedasticity? Why? [1 mark]
plot(d1$abund, d1$index)
## Yes, there is a potential heteroscedasticity 
## it seems that the variance increases as abund increases

#(3) Let's concentrate on <abund>. Fit a regression, using <abund> to explain <index>. [2 marks]
q3 <- lm(index ~ abund, data = d1)


#(4) Plot the diagnostic plots for this model. Comment on whether you see any problems in the plots. [2 marks]
par(mfrow = c(2,2))
plot(q3)
## the residual plot seems unequal, spreading out as the fitted values increase 


#(5) Try using the ncvTest() function from the "car" package to test the model for heteroscedasticity. [1 mark]
library(car)
ncvTest(q3)
## as the p-value < 0.01, we reject the null hypothesis and conclude that there is evidence of heteroscedasticity in the model. 

#(6) Use GLS to fit models with the following error structures:
library(nlme)
#(a) No error structure. [1 mark]
q6_a <- gls(index ~ abund, data = d1)

#(b) Fixed error structure based on <abund>. [2 marks]
vs1 <- varFixed(~abund)
q6_b <- gls(index ~ abund, data = d1, weights = vs1)

#(c) Ident error structure based on <group>. [2 marks]
vs2 <- varIdent(form = ~1|group)
q6_c <- gls(index ~ abund, data = d1, weights = vs2)

#(d) Exp error structure based on <abund> for different levels of <group>. [3 marks]
vs3 <- varExp(form = ~abund | group)
q6_d <- gls(index ~ abund, data = d1, weights = vs3)

#(e) A combination of (b) and (c). [3 marks]
vs4 <- varComb(varFixed(~abund), varIdent(form = ~1|group))
q6_e <- gls(index ~ abund, data = d1, weights = vs4)

#(7) Use AIC to compare all these different models from (3) and (6). [1 mark]
AIC(q3, q6_a, q6_b, q6_c, q6_d, q6_e)



#(8) Based on AIC, which model is the best and which variables are important for accounting for heteroscedasticity? [2 marks]
## q6_d is the best model with lowest AIC, which is the model that account for Exp error structure 
## based on <abund> for different levels of <groups>

#(9) Since both <abund> and <group> are important, fit another model using both variables (with interactions) to explain <index>. [2 marks]
q9 <- gls(index ~ abund * group, data = d1, weights = vs3)

#(10) Let's take a closer look at this model.
#(a) View the diagnostic plots. Does it look like this model solved heteroscedasticity? [2 marks]
plot(q9)
## very nicely scattered

#(b) Look at the summary results: are all the variables and interaction important? [1 mark]
summary(q9)
## Yes, all the combinations show significance (o-value < 0.01)

#(c) Compare the best model from (7) to this model in (9). Which would you choose as your final model? [1 mark]
AIC(q3, q6_a, q6_b, q6_c, q6_d, q6_e, q9)
## the most recent model with interaction term is far better than any other models 

#(11) Let's do two different plots (using ggplot2) to view this data with <index> as the response variable.
#(a) Do an appropriate plot with <abund> as the main explanatory variable, and <group> as the secondary explanatory variable. [2 marks]
d1 |>
  ggplot(aes(abund, index, color = group)) +
  geom_point() +
  labs(
    x = "abundance",
    y = "restoration index"
  )

#(b) Do an appropriate plot with <group> as the main explanatory variable, and <abund> plotted as the secondary explanatory variable. [3 marks]
d1 |>
  ggplot(aes(group, index, color = abund)) + 
  geom_boxplot() +
  geom_point()

###########################################################
##Section B: LME
###########################################################
#(12) Using the same dataset, we're going to fit LMEs using the lme() function from the "nlme" package.
#(a) Fit a model using <abund> to explain <index>,  with: 
#(i) <group> as the only random effect. [2 marks]
q12_i <- lme(index ~ abund, random = ~1|group, data = d1)

#(ii) <grown> nested within <group> as the random effect. [2 marks]
q12_ii <- lme(index ~ abund, random = ~1|grown/group, data = d1)

#(iii) <group> and <grown> as separate random effects. [1 mark]
## not possible using lme() function 

#(iv) <par> as a random slope and <group> as the random intercept. [2 marks]
q12_iv <- lme(index ~ abund, random = ~par|group, data = d1)

#(v) <group> as the only random effect and a varIdent error structure based on <grown>. [3 marks]
q12_v <- lme(index ~ abund, random = ~1|group, weights = varIdent(~grown), data = d1)

#(b) Compare all these models using AIC. Which is the best? [1 mark]
AIC(q12_i, q12_ii, q12_iv, q12_v)
## q12_i and q12_v are the best models 

#(13) We're going to fit all the same models in (12) using lmer() from the  "lme4" package.
#(a) Fit a model using <abund> to explain <index>,  with: 
library(lme4)
#(i) <group> as the only random effect. [2 marks]
q13_i <- lmer(index ~ abund + (1|group), data = d1)

#(ii) <grown> nested within <group> as the random effect. [2 marks]
q13_ii <- lmer(index ~ abund + (1|grown/group), data = d1)

#(iii) <group> and <grown> as separate random effects. [1 mark]
q13_iii <- lmer(index ~ abund + (1|group) + (1|grown), data = d1)

#(iv) <par> as a random slope and <group> as the random intercept. [2 marks]
q13_iv <- lmer(index ~ abund + (par|group), data = d1)

#(v) <group> as the only random effect and a varIdent error structure based on <grown>. [1 mark]
## lmer() functinon cannot specify variance structure

#(b) Compare all these models using AIC. Which is the best? [1 mark]
AIC(q13_i, q13_ii, q13_iii, q13_iv)
## q13_iii is the best model. 
