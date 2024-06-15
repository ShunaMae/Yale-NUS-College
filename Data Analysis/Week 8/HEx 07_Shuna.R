###########################################################
#                 Hands-On Exercise (HEx) 7               #
###########################################################
# Write your R code here and submit this file on Canvas   #
# If you are asked to submit some screenshots/images,     #
#  paste them onto a word document and submit it too.     #
###########################################################

###########################################################
##Section A: Poisson GLM
###########################################################
#(1) Using the <Ovary> dataset in the "nlme" package, fit a Poisson GLM using <Time> and <Mare> (together with their interaction) to explain <follicles>. [5 marks]
library(nlme)
data(Ovary)
q1 <- glm(follicles ~ Time * Mare, family = poisson, data = Ovary)

#(2) Check whether there is overdispersion. [2 marks]
summary(q1)
353.32 / 286
## there is no overdispersion 

#(3) Assuming there are problems with overdispersion, what two error families could you try instead? [1 mark]
## quasipoisson or negative binomial 

#(4) Try fitting the same model as in (1) using a quasipoisson GLM instead. [2 marks]
q4 <- glm(follicles ~ Time * Mare, family = quasipoisson, data = Ovary)

#(5) Using glm.nb() from the MASS package, try fitting the same model as in (1) using a negative binomial GLM instead. [3 marks]
library(MASS)
q5 <- glm.nb(follicles ~ Time * Mare, data = Ovary)

#(6) Using the DHARMa package, plot diagnostic plots for the poisson and negative binomial GLMs. [3 marks]
library(DHARMa)
plot(simulateResiduals(q5))

#(7) Are there any problems identified in the diagnostic plots? [1 mark]
## we can see that residual patterns are highlighted in red

#(8) Based on these results, which of the 3 models above would you choose? [1 mark]
## Quasipoisson

###########################################################
##Section B: Multinomial GLM
###########################################################
#(9) We're going to use a dataset where we use the <Form> of a butterfly and the identity of a <Mantis> to predict where it will attack the butterfly <AttLoc>. Read in the "firstStrike.txt" dataset and convert all variables to factors. [2 marks]
library(tidyverse)
Strike <- read.table("firstStrike.txt", header = TRUE) |>
  mutate(
    AttLoc =  as.factor(AttLoc),
    Form = as.factor(Form),
    Mantis = as.factor(Mantis)
  )

#(10) How many categories are there in our response variable <AttLoc>? What kind of GLM do we need to fit? [1 mark]
unique(Strike$AttLoc)
## 4 caterogries, Body, BWE, FWE, HWE
## As the # of category > 2, we need to use multinomial GLM.

#(11) Fit a multinomial GLM using <Form> interacting with <Mantis> to explain <AttLoc>. [4 marks]
library(nnet)
q11 <- multinom(AttLoc ~ Form * Mantis, data = Strike)

#(12) View the results using Anova(). [2 marks]
library(car)
Anova(q11)
## we can see the interaction term is not significant 

#(13) Simplify the model manually to arrive at your minimum adequate model. Along the way, check that any new model you produce is better than the previous one. [4 marks]
q13 <- update(q11, ~.-Form:Mantis)
Anova(q13)
AIC(q11, q13)
## for the model q13, we can see all the explanatory variables are significant 
## and AIC is better than the previous model i.e., q11. 

#(14) Calculate the p-values for <Form> and <Mantis> comparing all other attack locations to "Body". [2 marks]
z1 <- summary(q13)$coefficients/summary(q13)$standard.errors
p1 <- (1-pnorm(abs(z1), 0, 1))*2
p1

#(15) Relevel the <AttLoc> variable (you may create a new variable if you wish) so that "BWE" is the new reference level. [2 marks]
Strike$AttLoc2 <- relevel(Strike$AttLoc, ref = "BWE")

#(16) Fit the same minimum adequate model from (13), but using this new <AttLoc> variable from (15). [1 mark]
q16 <- multinom(AttLoc2 ~ Form + Mantis, data = Strike)

#(17) Calculate the p-values for <Form> and <Mantis> comparing all other attack locations to "BWE". [2 marks]
z2 <- summary(q16)$coefficients/summary(q16)$standard.errors
p2 <- (1-pnorm(abs(z2), 0, 1))*2
p2

#(18) Produce graphs (hint: you can use bar graphs similar to those in Poisson Example 2 in the lecture) to visualise:
#(a) The effect of <Form> on <AttLoc>. Paste your plot into the HEx Week 07 Figures.docx file. [2 marks]
Strike |>
  ggplot(aes(AttLoc)) +
  geom_bar(aes(fill = Form), position = position_dodge2(preserve = 'single'))

#(b) The effect of <Mantis> on <AttLoc>. Paste your plot into the HEx Week 07 Figures.docx file. [2 marks]
Strike |>
  ggplot(aes(AttLoc)) +
  geom_bar(aes(fill = Mantis), position = position_dodge2(preserve = 'single'))
#(c) The effect of <Form> and <Mantis> on <AttLoc>. Paste your plot into the HEx Week 07 Figures.docx file. (Hint: try using faceting) [3 marks]

Strike |>
  ggplot(aes(AttLoc)) +
  geom_bar(aes(fill = Mantis), position = position_dodge2(preserve = 'single')) +
  facet_grid(Form~.)

















