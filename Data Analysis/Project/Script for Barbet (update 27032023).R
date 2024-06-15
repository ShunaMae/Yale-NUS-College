
library(tidyverse)
library(readr)
library(hms)
library(nlme)
library(nortest)
library(lme4)
library(DHARMa)
library(MASS)

public_holidays <- as.Date(c("2022-12-31", "2023-01-01","2023-01-02", "2023-01-03", "2023-01-27", "2023-01-28", "2023-01-29", "2023-01-30", "2023-01-31", "2023-02-10", "2023-02-13", "2023-03-01"))

prep_data <- function(df){
  df |>
    mutate(
      transect = as.double(substr(FOLDER, 2,2)),
      distance = case_when(
        substr(FOLDER, 4, 4) == "5" ~ 50,
        substr(FOLDER, 4, 4) == "1" ~ 100,
        TRUE ~ 200
      ),
      time_sec = as.numeric(TIME) + OFFSET,
      time_day = as_hms(time_sec),
      to_classify = weekdays(DATE),
      Date = as.Date(DATE, format = "%m/%d/%Y"),
      days = case_when(
        Date %in% public_holidays ~ "off_day",
        to_classify == "Saturday" ~ "off_day",
        to_classify == "Sunday" ~ "off_day",
        TRUE ~ "weekday")
    ) |>
    dplyr::select(
      DATE, top_match = `TOP1MATCH*`, top_dist = TOP1DIST,
      transect, distance, time_day, days, DURATION
    )
}

LB <- prep_data(read_csv("data/barbet_clusters.csv"))

############### BARBET DATA #################
LB_analysis <- LB |>
  ## filter for the top_match
  filter(top_match == "Lineated Barbet 1") |>
  ## filter for the disrtance from the cluster 
  filter(top_dist <= 1)

str(LB_analysis)

## Converted <distance> and <transect> and <days> to factors.
# Remove: LB_analysis$distance=as.factor(LB_analysis$distance)
LB_analysis$transect=as.factor(LB_analysis$transect)
LB_analysis$days=as.factor(LB_analysis$days)
str(LB_analysis)

########################## EXPLAIN <DURATION> ##################################
############# WITH <DISTANCE> AND <DAYS> WITH <TRANSECT> ########################

## Fitting the model: LME with <transect> as a random effect.
lb_duration_mod1a=lme(DURATION~distance*days,random=~1|transect,data=LB_analysis)

## Diagnostic plots.
# Variance for whole dataset
plot(lb_duration_mod1a) #looks like there is some heteroscedasticity.

# Variance for levels of random effect
plot(lb_duration_mod1a,resid(.,scaled=T)~fitted(.)|transect,abline=0,lty=2) #equality of variance not very good.

# Normality for whole dataset
qqnorm(lb_duration_mod1a,abline=c(0,1),lty=2) #non-normal.
  
# Normality for levels of random effect
qqnorm(lb_duration_mod1a,~resid(.,type="p")|transect,abline=c(0,1),lty=2) #non-normal.

##################################
   
## Transform the y-variable <DURATION>.
logDURATION=log(LB_analysis$DURATION)

## Refit the model: LME with <transect> as a random effect.
lb_duration_mod1b=lme(logDURATION~distance*days,random=~1|transect,data=LB_analysis)
  
## Diagnostic plots.
# Variance for whole dataset
plot(lb_duration_mod1b) #looks ok.

# Variance for levels of random effect
plot(lb_duration_mod1b,resid(.,scaled=T)~fitted(.)|transect,abline=0,lty=2) #equality of variance not very good.

# Normality for whole dataset
qqnorm(lb_duration_mod1b,abline=c(0,1),lty=2) #non-normal.

# Normality for levels of random effect
qqnorm(lb_duration_mod1b,~resid(.,type="p")|transect,abline=c(0,1),lty=2) #non-normal.

## Note: transforming <distance> using log(y), sqrt(y), and 1/y did not help.
## Proceed to fit a GLMM instead.


##################################

## Refit the model: NB GLMM with <transect> as a random effect.
lb_duration_mod2a=glmer.nb(DURATION~distance*days+(1|transect),data=LB_analysis)
plot(simulateResiduals(lb_duration_mod2a)) # many problems with overdispersion, ks-test, equality of variance.


##################################

## Refit the model: Quasi-GLMM with <transect> as a random effect.
lb_duration_mod3a=glmmPQL(DURATION~distance*days,random=~1|transect,
                          family=quasi,data=LB_analysis)

summary(lb_duration_mod3a)

lb_duration_mod3b=update(lb_duration_mod3a,~.-distance:days)
summary(lb_duration_mod3b)

lb_duration_mod3c=update(lb_duration_mod3b,~.-distance)
summary(lb_duration_mod3c)

# Ask friends for help: which model is better -> include <distance> p-value=0.0735

## Checking plots
plot(DURATION~distance,data=LB_analysis) # Looks like there is no significance
boxplot(DURATION~days,data=LB_analysis) # Looks like there is no significance

ggplot(LB_analysis, aes(x=distance, y=DURATION)) +
  geom_point(aes(col=days))


# No diagnostic plots nor AIC() so we will use lb_duration_mod3c.

########################## EXPLAIN <N> ##################################
############# WITH <DISTANCE> AND <DAYS> WITH <TRANSECT> ########################
LB_chorus <- LB_analysis |>
  filter(time_day <= as.hms("10:00:00", format = "%h%m:%s"))  |>
  group_by(transect, distance, days) |>
  summarise(n = n())

lb_chorus_mod1a=glmer(n~distance*days+(1|transect),data=LB_chorus,family=poisson)

## Rescale variables
lb_chorus_mod2a=glmer(n~scale(distance)*days+(1|transect), 
                           data=LB_chorus,family=poisson)

## piecewise 
lb_chorus_mod_piece=glmer(n~scale(distance)*days+(1|transect), 
                      data=LB_chorus,family=poisson)
plot(simulateResiduals(lb_chorus_mod2a)) # no problems.

summary(lb_chorus_mod2a) 

## Note: scale(distance):days p-value 0.0646, close to 0.05

lb_chorus_mod2b=update(lb_chorus_mod2a,~.-scale(distance):days)
summary(lb_chorus_mod2b)

lb_chorus_mod2c=update(lb_chorus_mod2b,~.-days)
summary(lb_chorus_mod2c)

AIC(lb_chorus_mod2a, lb_chorus_mod2b, lb_chorus_mod2c)
# first model has lowest AIC score, but third model is the simplest.
# 183.1729-182.6469 # 0.526
# Ask Prof Ian: which model to use?

library(ggplot2)
ggplot(LB_chorus,aes(x=days,y=n))+geom_boxplot(aes(col=distance))
ggplot(LB_chorus,aes(x=distance,y=n))+geom_boxplot(aes(col=days))

# Based on the boxplot, there seems to be an interaction between <distance> and <days>, that's why R tells
# you to keep the interaction in AIC(). Makes sense to use the model with the interaction, but this makes it
# hard to use the effect sizes. Perhaps report the averages (mean no. of vocalisations at each level of <distance>).

# Use lb_chorus_mod2a.

############################## ANALYSIS ########################################
summary(lb_duration_mod3c)
# duration significantly affected by <days>

summary(lb_chorus_mod2a)
# dawn chorus not significantly affected by <scale(distance)> nor <days>,
# but the interaction makes sense even though its not significant.

#### piecewise regression 

bp <- 100
b1 <- function(x, bp) ifelse(x <= bp, x, 0)
b2 <- function(x, bp) ifelse(x < bp, 0, x)

LB_duration_model.2 <- lme(DURATION ~ b1(distance, 100) * days + b2(distance, 100) * days, random = ~1|transect, data = LB_analysis)

LB_duration_model.3 <- lme(DURATION ~ b1(distance, 100) + b2(distance, 100) + days, random = ~1|transect, data = LB_analysis)

summary(LB_duration_model.2)
summary(LB_duration_model.3)

AIC(LB_duration_model.2, LB_duration_model.3)
plot(LB_duration_model.3)

LB_duration_model.4 <-glmer.nb(DURATION ~ scale(b1(distance, 100)) + scale(b2(distance, 100)) + days + (1|transect), data = LB_analysis)
summary(LB_duration_model.4)

## piece 

View(LB_analysis)
LB_n_model.2 <- glmer(n ~ scale(b1(distance, 100)) * days + scale(b2(distance, 100)) * days + (1|transect), data = LB_chorus, family = poisson)
LB_n_model.3 <- glmer(n ~ scale(b1(distance, 100)) + scale(b2(distance, 100)) + days + (1|transect), data = LB_chorus, family = poisson)
summary(LB_n_model.2)
summary(LB_n_model.3)

plot(simulateResiduals(LB_n_model.3))
