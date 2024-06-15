###########################################################
#                Hands-On Exercise (HEx) 8                #
###########################################################
# Write your R code here and submit this file on Canvas   #
# If you are asked to submit some screenshots/images,     #
#  paste them onto a word document and submit it too.     #
###########################################################

###########################################################
##Section A: Survival Analysis
###########################################################
#An experiment tested 3 different treatments on the survival of an invasive weed.
#Let's analyse a dataset of these weeds where their <death> is explained by their 
#<weight> and treatment <group>. The censorship variable is correctly stored as <status>.
library(tidyverse)
#(1) Read in and store the "weeds.txt" dataset. [1 mark]
weeds <- read.table("weeds.txt", header = T)
weeds <- weeds |>
  mutate(
    status = as.numeric(status),
    group = as.factor(group)
  )
#(2) Use ggplot to visualise the data by plotting the following plots:
#(a) Boxplot of <death> by <group>, with jittered points coloured according to <weight> on top of the boxplots. [2 marks]
weeds |>
  ggplot(aes(group, death)) +
  geom_boxplot() + 
  geom_jitter(aes(color = weight), width = 0.2)
  
#(b) To your plot in (a), add this to the end and see what changes: +scale_colour_continuous(type="viridis") [no marks]

weeds |>
  ggplot(aes(group, death)) +
  geom_boxplot() + 
  geom_jitter(aes(color = weight), width = 0.2)+
  scale_colour_continuous(type="viridis")

#(c) To your plot in (a), add this to the end and see what changes: +scale_colour_gradient(low="blue",high="red") [no marks]
#Note: you can easily customise the colours in your plots using these commands above

weeds |>
  ggplot(aes(group, death)) +
  geom_boxplot() + 
  geom_jitter(aes(color = weight), width = 0.2)+
  scale_colour_gradient(low="blue",high="red")

#(d) Plot a survival curve of the weeds broken down by <group>. [3 marks]
library(ggfortify)
library(survival)
q2_d <- survfit(Surv(death, status) ~ group, data = weeds)
autoplot(q2_d)

#(3) Let's do a survival analysis using a GLM with gamma errors.
#(a) Fit a model explaining <death> using <weight> interacting with <group>. [2 marks]
q3_a <- glm(death ~ weight * group, family = Gamma, data = weeds)
#(b) Simplify the model, using AIC to check every removal. What explanatory variable(s) is/are in your final model? [4 marks]
summary(q3_a)
q3_b.1 <- update(q3_a, ~.-group:weight)
summary(q3_b.1)
q3_b.2 <- update(q3_b.1, ~.-weight)
summary(q3_b.2)
AIC(q3_a, q3_b.1, q3_b.2)
# group alone is the best model 


#(c) Paste your summary() output here. Using the coefficients, calculate the survival duration for each group predicted by your final model. [3 marks]

#Call:
##  glm(formula = death ~ group, family = Gamma, data = weeds)

#Deviance Residuals: 
##  Min       1Q   Median       3Q      Max  
##-2.0892  -1.5535  -0.5632   0.5042   2.4450  

# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
#  (Intercept) 0.043328   0.006804   6.368 2.31e-09 ***
#  groupB      0.026021   0.012842   2.026 0.044544 *  
#  groupC      0.081361   0.020730   3.925 0.000133 ***
#  ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#(Dispersion parameter for Gamma family taken to be 1.233125)

#Null deviance: 259.84  on 149  degrees of freedom
#Residual deviance: 232.93  on 147  degrees of freedom
#AIC: 1092.4

# Number of Fisher Scoring iterations: 7

grpA <- 1/0.043328
grpB <- 1 / (0.043328 + 0.026021)
grpC <- 1/ (0.043328 + 0.081361)
sprintf("group A: %f, group B: %f, group C: %f", grpA, grpB, grpC)

#(d) Plot diagnostic plots (using the DHARMa package). [1 mark]
library(DHARMa)
plot(simulateResiduals(q3_b.2))

#(e) Do you see anything wrong? [no marks]
## KS test showing significance means that the two data may not  be coming from the same distribution. 

#(4) Let's do a parametric survival analysis instead.
#(a) Fit a constant hazard model explaining <death> using <weight> interacting with <group>. [3 marks]
q4_a <- survreg(Surv(death, status) ~ weight * group, dist = "exponential", data = weeds)

#(b) Fit 3 other models with different hazard functions: (i) Weibull, (ii) loglogistic, (iii) any other function. [3 marks]
q4_b.1 <- survreg(Surv(death, status) ~ weight * group, dist = "weibull", data = weeds)
q4_b.2 <- survreg(Surv(death, status) ~ weight * group, dist = "loglogistic", data = weeds)
q4_b.3 <- survreg(Surv(death, status) ~ weight * group, dist = "rayleigh", data = weeds)

#(c) Compare all these 4 models from (a) and (b) using AIC. Which is the best? [1 marks]
AIC(q4_a, q4_b.1, q4_b.2, q4_b.3)
## the model with loglogistic model has the lowest AIC

#(d) Using the best model, simplify the model, using AIC to check each removal. What explanatory variable(s) is/are in your final model? [4 marks]
summary(q4_b.2)
q4_d.1 <- update(q4_b.2, ~.-weight:group)
summary(q4_d.1)
q4_d.2 <- update(q4_d.1, ~.-weight)
summary(q4_d.2)
AIC(q4_b.2, q4_d.1, q4_d.2)
## the last model is the best model 
#(e) Paste your summary() output here. Using the coefficients, calculate the survival duration for each group predicted by your final model. [3 marks]

# Call:
#  survreg(formula = Surv(death, status) ~ group, data = weeds, 
#          dist = "loglogistic")
#              Value Std. Error     z       p
# (Intercept)  2.7266     0.2466 11.06 < 2e-16
#  groupB      -1.0142     0.3417 -2.97   0.003
#  groupC      -1.3641     0.3340 -4.08 4.4e-05
#  Log(scale)  -0.0631     0.0711 -0.89   0.375

#Scale= 0.939 

#Log logistic distribution
#Loglik(model)= -466   Loglik(intercept only)= -474.3
#Chisq= 16.77 on 2 degrees of freedom, p= 0.00023 
#Number of Newton-Raphson Iterations: 3 
#n= 150 

#(f) Compare these results to the results from the gamma GLM. Which would you prefer? [no marks]
## I prefer the gamma GLM model. Scale of 0.939 implies that the hazard is almost constant. 


###########################################################
##Section B: GLMM
###########################################################
#(9)  We're going to analyse the "Arabidopsis" dataset from the "lme4" package.
#(a) Load the package, save the dataset as a new object and convert <rack> and <nutrients> to factors. [2 marks]
library(lme4)
data("Arabidopsis")


Arabidopsis <- Arabidopsis |>
  dplyr::mutate(
    rack = as.factor(rack),
    nutrient = as.factor(nutrient)
  )


#(b) Examine the variables in the dataset. We want to explain <total.fruits> using both fixed and random effects. What kind of analysis (including what error family) should we use? [2 marks]
## glmm with poisson distribution 

#(10) Using glmer(), fit the model you identified above with the following fixed and random effects: [3 marks]
#Fixed effects: <rack> interacting with <amd>, and <nutrient> (not interacting with any other variable)
#Random effects: <gen> nested within <popu> as a random intercept

q10 <- glmer(total.fruits ~ rack * amd + nutrient + (1| popu/gen), family = poisson, data = Arabidopsis)

#(11) Check the model using the DHARMa package. Are there problems with the model? [1 mark]
plot(simulateResiduals(q10))
## KS test showing the significance -> two populations may not be from the same distribution 
## within-group deviations from uniformity issue: the variance within groups are not uniform 


#(12) Assuming there are problems, fit the same model using a negative binomial error distribution. [2 marks]

q12 <- glmer.nb(total.fruits ~ rack * amd + nutrient + (1| popu/gen), 
                  data = Arabidopsis)

#(13) Check the model using the DHARMa package. Are there problems with the model? [1 mark]
plot(simulateResiduals(q12))
## overdispersion, KS test failure, within-variation 

#(14) Assuming there are problems, fit the same model using glmmPQL() and simplify until you get your minimum adequate model. [4 marks]
library(MASS)
q14 <- glmmPQL(total.fruits ~ rack * amd + nutrient, random = ~1|popu/gen,
               family = poisson, data = Arabidopsis)
summary(q14)

#(15) Based on your results, what plot(s) would you draw to illustrate your analysis results to a reader? Try drawing these plots. [no marks]
#Hint: think about what significant relationships are shown in your results. There are what you would need to illustrate.

View(Arabidopsis)
Arabidopsis |>
  ggplot(aes(rack, total.fruits)) +
  geom_boxplot() +
  geom_jitter(aes(color = nutrient), width = 0.4)
