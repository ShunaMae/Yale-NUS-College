###########################################################
#                   Analysis Challenge 2                  #
###########################################################
#(1) Submit this file on Canvas.                          #
#(2) Also submit the Figures file on Canvas.              #
#(3) There are many ways to get things done in R. The     #
# answers below are only one way. As long as your way     #
# works, you will get the marks.                          #
#(4) You will not be double penalised for a mistake. For  #
# example, even if you identify the wrong variables in an #
# earlier question, you will get full marks for the       #
# following questions if you use the correct analyses for #
# the variables you identified.                           #
#(5) Report whatever p-values or statistics you obtain    #
# using comments to help me better mark your work.        #
#(6) PLEASE DO THIS ON YOUR OWN WITHOUT DISCUSSION.       #
###########################################################
#Total marks = 60                                         #
###########################################################

##Description of the "cultivation" dataset:
#A new species of plant was cultivated for use as a nature-based climate solution and data were collected on how different growth conditions affect its growth and bloom success:
#<mass> is the final weight of the plant (in grams) and is a response variable used to measure plant growth
#<bloom> is the number of stalks in each plant that successfully bloomed and is a response variable
#<stalks> is the total number of stalks in each plant being grown that could potentially bloom
#<water> indicates whether the plant was watered (TRUE) or not (FALSE) during the experiment and is an explanatory variable
#<nitra> indicates the nitrate levels (in ppm) in the soil used to grow each plant and is an explanatory variable
#<greenhouse> indicates the greenhouse in which the plant was grown and is potentially a confounding variable, the different greenhouses are not meant to be different from one another
###########################################################

##You are the data expert from an environmental consultancy and have been asked to analyse whether the growth conditions, <water> and <nitra>, affect the growth and bloom rate of the plant.
#Questions
###########################################################
library(tidyverse)
library(nlme)
library(lme4)

##(1) Import the cultivation.txt dataset into R. Convert any variables that need to be converted. [2 marks]
data <- read.table("cultivation.txt", header = T) 
str(data)

#'data.frame':	100 obs. of  6 variables:
#  $ mass      : num  172 184 168 180 171 ...
#$ bloom     : int  48 34 39 41 30 60 61 62 44 51 ...
#$ stalks    : int  87 73 74 77 67 96 97 97 84 88 ...
#$ water     : logi  TRUE TRUE TRUE TRUE TRUE FALSE ...
#$ nitra     : num  34.4 36.3 33.1 37.6 34.4 23.5 28.2 36.6 25.7 23.2 ...
#$ greenhouse: int  1 1 1 1 1 1 1 1 1 1 ...

data <- data |>
  mutate(greenhouse = as.factor(greenhouse))

###########################################################

##(2) We're first going to explore the data using simple graphs to visualise:
##(a) The relationship between <mass> and <water>. Do you expect <water> to have a significant effect? [2 marks]
data |>
  ggplot(aes(water, mass)) +
  geom_boxplot(notch = T)
#### Yes, the watered plants (water = TRUE) seem to have greater mass.
#### notch are not overlapping
#### a significant effect is expected 

##(b) The relationship between <mass> and <nitra>. Do you expect <nitra> to have a significant effect? [2 marks]
data |>
  ggplot(aes(nitra, mass)) +
  geom_point()
#### there appears to be a positive correlation between nitra and mass 
#### I need to wait to test, but I expect nitra to have a significant effect. 

##(c) The interaction between <water> and <nitra>. Do you expect any significant interactions? [3 marks]
data |>
  ggplot(aes(water, nitra)) +
  geom_boxplot(notch = T)

#### as the notches are not overlapping and I do not see much difference between boxes, 
#### I do not expect any difference in nitra based on water
#### therefore, i do not expect any significant interaction between these two variables. 

##(d) The relationship between <mass> and <greenhouse>. Do you expect <greenhouse> to have a significant effect? 
###### Should it be included as a random effect in your analysis? [3 marks]

data |>
  ggplot(aes(greenhouse, mass)) +
  geom_boxplot(notch = T)

#### we can see some variation in median and range between greenhouses. 
#### greenhouse itself may not show significant effect, but it provides an important variation to better understand the situation. 
#### Yes, greenhouse should be included as a random effect in the analysis 

###########################################################

##(3) Assume that you have decided to include <greenhouse> as a random effect, state what would be an appropriate analysis to explain <mass> using <water>, <nitra>, and <water> interacting with <nitra>? Explain your choice. [3 marks]

hist(data$mass)
shapiro.test(data$mass)
## p = 0.09321,
## the histogram looks pretty normal too 
## mass shows a normal distribution 

### therefore, by including a random effect, 
### we are building a linear mixed model. 

###########################################################

##(4) Perform the analysis you identified above. What variables are in the minimum adequate model? [10 marks]
##Paste the diagnostic plots and final p-values in the AC2 Figures.docx file.
##Hint: remember to check assumptions and simplify through stepwise deletion.

q4.1 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data)
### diagnostic plot 
plot(q4.1)
#### the points seem well scattered. 
#### no problem for heteroscedasticity. 
qqnorm(q4.1, abline=c(0, 1), lty = 2)
### the residuals look pretty normally distributed. 
### maybe the one point at the very bottom could be a deviation.

summary(q4.1)

# Fixed effects:  mass ~ water * nitra 
#                     Value Std.Error DF   t-value p-value
# (Intercept)       7.229526 10.994543 92  0.657556  0.5125
# waterTRUE       -13.615518 16.215197 92 -0.839676  0.4033
# nitra             2.855126  0.346488 92  8.240189  0.0000
# waterTRUE:nitra   2.003660  0.523250 92  3.829259  0.0002

### Though water is not significant, the interaction between nitra and water shows significance. 
### therefore, there is no need to simplyfy the model. 

### in the minimum adequate model, I have nitra, water, and the interaction of two variables 
### as well as the random effect by the greenhouse. 

###########################################################

##(5) We suspect that there might be some variance structure caused by the explanatory variables. 
##(a) What kind of analysis would we use to account for this? [1 mark]

### generalized least squares 


##(b) Create variance structures accounting for potential heteroscedasticity due to <water> alone, <nitra> alone, and both. [3 marks]

## water is a logistic variable 
### consider it as categorical 
## nitra is continuous variable

vs1 <- varIdent(form = ~1|water)
vs2 <- varFixed(~nitra)
vs3 <- varPower(form = ~nitra)
vs4 <- varPower(form = ~nitra|water)
vs5 <- varConstPower(form = ~nitra)
vs6 <- varConstPower(form = ~nitra|water)
vs7 <- varExp(form = ~nitra)
vs8 <- varExp(form = ~nitra|water)


##(c) Add these variance structures to your model from (4) (use a different function to fit the models if appropriate). Which model is the best? [4 marks]

q5_c.1 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data, weights = vs1)
q5_c.2 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data, weights = vs2)
q5_c.3 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data, weights = vs3)
q5_c.4 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data, weights = vs4)
q5_c.5 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data, weights = vs5)
q5_c.6 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data, weights = vs6)
## did not converge
q5_c.7 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data, weights = vs7)
q5_c.8 <- lme(mass ~ water * nitra, random = ~1|greenhouse, data = data, weights = vs8)

AIC(q4.1, q5_c.1, q5_c.2, q5_c.3, q5_c.4, q5_c.5, q5_c.7, q5_c.8)

#         df AIC
# q4.1    6 830.3868
# q5_c.1  7 824.2963
# q5_c.2  6 833.5204
# q5_c.3  7 832.0393
# q5_c.4  8 826.0898
# q5_c.5  8 834.0393
# q5_c.7  7 831.9454
# q5_c.8  8 826.4846

## q5_c.1 is the best model. 

##(d) Check, simplify and interpret the results, with effect sizes and p-values, from the best model you identified. [7 marks]
##Note: you may show your coefficients and p-values as comments to support your conclusions.

plot(q5_c.1)
## the points seem well scattered.

qqnorm(q5_c.1, abline=c(0, 1), lty = 2)

summary(q5_c.1)
#                     Value Std.Error DF   t-value p-value
# (Intercept)      7.140275 13.378657 92  0.533706  0.5948
# waterTRUE       -9.958709 15.755438 92 -0.632081  0.5289
# nitra            2.858093  0.417248 92  6.849862  0.0000
# waterTRUE:nitra  1.884773  0.510573 92  3.691488  0.0004

## as the interaction is significant, this is already the minimum model. 

### nitrate levels have significant effect on the plant mass (p < 0.001, n = 100). 
### An increase of 1 ppm in the nitrate level results in an increase of plant mass of 2.86 ± 0.452 (mean ± SE) 
### The interaction between water and nitrate levels was also significant (p = 0.0004), 
### indicating that the effect of nitrate levels on plant mass depends on the presence or absence of water. 
### Specifically, for every 1 ppm increase in nitrate level, the increase in plant mass is 1.88 ± 0.511 (mean ± SE) grams greater when water is present compared to when water is absent.
### The water alone does not show a significance (p = 0.59)
###########################################################

##(6) Produce a plot to show the two different slopes (for <mass> vs <nitra>) for the two levels of <water> TRUE and FALSE. [4 marks]
##Paste the plot into the AC2 Figures.docx file.
##Hint: when you plot a linear relationship, you can also break it into 2 separate lines using the "col=XXX" argument.

data |>
  ggplot(aes(nitra, mass)) +
  geom_point(aes(color = water)) +
  geom_smooth(aes(color = water), method = "lm") +
  labs(
    x = "Nitrate Level (ppm)",
    y = "Plant mass (g)"
  ) + 
  theme_classic()


###########################################################

##(7) I now want to see what variables affect the proportion of <stalks> that <bloom>.
##(a) Fit an appropriate model with <water>, <nitra> and their interaction as explanatory variables, with <greenhouse> as a random effect. [3 marks]

q7_data <- data |>
  mutate(failure = stalks - bloom)
q7_a <- glmer(cbind(bloom, failure) ~ nitra * water + (1|greenhouse), data = q7_data, family = binomial)

##(b) Check whether the model satisfies all assumptions and switch to another appropriate error distribution if it does not. [3 marks]

library(DHARMa)
plot(simulateResiduals(q7_a))
## there seems to be a problem with KS test, which tests whether the sample comes from a population with a specific distribution. 

library(MASS)
q7_b <- glmmPQL(cbind(bloom, failure) ~ nitra * water, random = ~1|greenhouse, data = q7_data, family = quasibinomial)

##(c) Simplify the model to obtain the minimum adequate model. [3 marks]
summary(q7_b)

# q7_c.1 <- update(q7_b, ~.-nitra:water)
# Error in eval(predvars, data, env) : object 'zz' not found
# couldnt solve the error 
q7_c.2 <- glmmPQL(cbind(bloom, failure) ~ nitra + water, random = ~1|greenhouse, data = q7_data, family = quasibinomial)
summary(q7_c.2)
q7_c.3 <- q7_b <- glmmPQL(cbind(bloom, failure) ~ water, random = ~1|greenhouse, data = q7_data, family = quasibinomial)
summary(q7_c.3)
##(d) Interpret the results of the model, reporting effect sizes and p-values. [3 marks]
##Hint: you will need to convert the coefficients.

inv_logit <- function(x){1/(1+1/exp(x))}

inv_logit(0.3373)
inv_logit(0.3373 - 0.2799)

## The sample size is 100.
## the modelling average of blooming success rate without water is 58.35 ± 2.02 % (mean ±  SE).
## if the plant is watered, it showes significantly lower success rate in blooming (48.56 ± 2.94 %, p < 0.001). 

###########################################################

##(8) Produce an appropriate plot to show this result. Paste it into the AC2 Figures.docx file. [2 marks]
##Hint: you may have to calculate a new variable.

q7_data |>
  mutate(success = bloom / stalks * 100) |>
  ggplot(aes(water, success)) +
  geom_boxplot(notch = T) + 
  labs(y = "Blooming Rate (%)") +
  theme_classic()

###########################################################

##(9) The government needs big plants with a high proportion of blooms to stabilise some slopes. What growth conditions, <water> and <nitra>, would you advise to obtain this? [2 marks]
##Hint: Use your results and figures for what affects plant <mass> (questions 5 and 6) and proportion of <bloom> (questions 7 and 8).


## for the proportion of blooms, we know that not watering the plants will raise the chance of seeing the bloom. 
## the problem arises because watered plants are heavier than un-watered plants. So it's up to them which to prioritize first 
## nitrate levels should be high regardless, as we see a positive correlation between nitrate levels and plant mass. 
## one possible answer is to have high nitrate levels without watering. 