library(tidyverse)
library(tibble)
library(ggplot2)
library(scatterplot3d)
library(vegan)
library(gganimate)
library(gifski)
library(transformr)
library(infer)
library(patchwork)
library(dplyr)
library(readr)

test <- read_csv("EuryWL.csv")
View(test)

test$Win[test$Win == "l"] <- as.numeric("0")
test$Win[test$Win == "w"] <- as.numeric("1")


test$Win <- as.numeric(test$Win)


test <- test %>%
  replace(is.na(.), 0)

glimpse(test)

nmds <- test %>%
  select(-Idc,-Idb, -Idfly, -Idf, -Behaviors)%>%
  metaMDS(., distance="jaccard", k=3, trymax=50, trace = 2)
#What is jaccard?#

glimpse(nmds)

plot(nmds)

stressplot(nmds)

test <-  nmds %>% 
  
  scores(., choices = c(1:3), display=c("sites")) %>%

  data.frame(.) %>%
  bind_cols(test, .) 

p1 <-  ggplot() +
  geom_point(data = test, 
             aes(x=NMDS1, y=NMDS2, colour = id), 
             alpha = 0.7)

loser <- test %>% 
  filter(Win == 0)

p2 <-  ggplot() +
  geom_point(data = loser, 
             aes(x=NMDS1, y=NMDS2, colour = id), 
             alpha = 0.7)+
  labs(title = "Loser")+
  theme(plot.title = element_text(hjust = 0.5))

winner <- test %>% 
  filter(Win == 1)

p3 <-  ggplot() +
  geom_point(data = winner, 
             aes(x=NMDS1, y=NMDS2, colour = id), 
             alpha = 0.7)+
  labs(title = "Winner")+
  theme(plot.title = element_text(hjust = 0.5))
