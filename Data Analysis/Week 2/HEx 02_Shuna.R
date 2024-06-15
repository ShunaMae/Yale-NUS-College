###########################################################
#                 Hands-On Exercise (HEx) 2               #
###########################################################
# This is what our HEx will look like                     #
# Write your R code here and submit this file on Canvas   #
# If you are asked to submit some screenshots/images,     #
#  paste them onto a word document and submit it too.     #
###########################################################


###########################################################
## The protectedAreas.xlsx Dataset 
###########################################################
# Overall Description: this dataset contains data on species richness within 40 protected patches. The study attempted to measure
# how biodiversity within the patches is affected by location, physical parameters and a recent negative event.

# Description of individual variables:
#<site> denotes the Protected Area that the patch is located within and is an explanatory variable
#<elevation> is the average altitude of the patch and is an explanatory variable
#<richness> is the species richness measured in a recent survey at each patch and is the response variable
#<temp> is the average temperature within each patch and is an explanatory variable
#<impact> is an indication of whether a patch was affected by a recent negative event and is an explanatory variable
#<country> denotes the country that each patch is located in and is an explanatory variable


###########################################################
##Section A: Understanding variables and correcting mistakes
###########################################################
#(1) Import the "protectedAreas.xlsx" dataset and save it as <paData>. Remember to load any packages required. [2 marks]
library(readxl)
paData <- read_excel("protectedAreas.xlsx")

#(2) What code will help you check what variables are in <paData> and what are their types. [1 mark]
str(paData)
## site: chr
## elevation: num 
## richness: num 
## temp: num 
## impact: chr 
## country: num 

#(3) Identify which variables should be changed to factor type. [3 marks]
## country and site should be changed to factor type.
## both country and site are explanatory variables. 
## and are not response variables. 

#(4) Write the code to change these variables to the correct type. [3 marks]
paData$country <- as.factor(paData$country)
paData$site <- as.factor(paData$site)

#(5) Use code to automatically check whether there are any NAs in the dataset. State how many NAs there are. [2 marks]
apply(is.na(paData), 2, which) ## integer(0) ... no NAs 
summary(paData) ## no NAs seen

#(6) Using basic R within R Studio, plot 3 separate boxplots for <elevation>, <richness> and <temp> to identify outliers. [3 marks]

## elevation
boxplot(paData$elevation)
which(paData$elevation < quantile(paData$elevation,0.25) - 1.5*IQR(paData$elevation))
which(paData$elevation > quantile(paData$elevation,0.75) + 1.5*IQR(paData$elevation))
### both integer(0) and no outliers observed in the boxplot. 

boxplot(paData$richness)
which(paData$richness < quantile(paData$richness,0.25) - 1.5*IQR(paData$richness))
which(paData$richness > quantile(paData$richness,0.75) + 1.5*IQR(paData$richness))
## one outlier observed in the boxplot 
## outlier is in row 6


boxplot(paData$temp)
which(paData$temp < quantile(paData$temp,0.25) - 1.5*IQR(paData$temp))
which(paData$temp > quantile(paData$temp,0.75) + 1.5*IQR(paData$temp))
## no outlier observed. 


#(7) Does any variable have outliers? If so, which? [1 mark]
## Yes, variable 'richness' has an outlier. 

#(8) Identify which observation(s) the outlier(s) comes from. [4 marks]
which(paData$richness > 80)
## row 6

#(9) Remove the row(s) you identified in (8) from the dataset. [1 mark]
paData <- paData[-6,]
boxplot(paData$richness)

###########################################################
##Section B: Importing datasets into R
###########################################################
#(10) Import the "protectedAreas2.xlsx" dataset (this has been corrected from the earlier dataset) and save it as <paData2>. [1 mark]
paData2 <- read_excel("protectedAreas2.xlsx")

#(11) Change the type of all the variables that need to be changed. [1 mark]
str(paData)
paData2$site <- as.factor(paData2$site)
paData2$impact <- as.logical(paData2$impact)
paData2$country <- as.factor(paData2$country)

#(12) Install the "ggplot2" and "GGally" packages. [2 marks]
install.packages("ggplot2")
install.packages("GGally")
library(ggplot2)
library(GGally)

#(13) Using "GGally", do a pairs plot of all the variables in <paData2>. [1 mark]
ggpairs(paData2)

#(14) Copy and paste the pairs plot from (13) into the Word file provided. [1 mark]


#(15) Do a correlation plot of only the numeric variables in <paData2>. [3 marks]
library(dplyr)
paData_numeric <- paData2 |> 
  dplyr::select(-site, -impact, -country) |> 
  ggpairs() |> 
  show()

ggpairs(paData2[, 2:4])

ggcorr(paData2[,2:4], pallette = "RdBu", label = TRUE)

#(16) Copy and paste the pairs plot from (15) into the Word file provided. [1 mark]


###########################################################
##Section C: Data visualisation
###########################################################
#(17) What variable type is <temp> (categorical or continuous)? Draw a histogram of <temp> using ggplot2. [5 marks]
## continuous 
paData2 |>
  ggplot(aes(x = temp)) +
  geom_histogram(color = "white") +
  labs(
    x = "temperature",
    y = "frequency"
  )
  
  

#(18) I want to see how the data is distributed in <country> and <site>. What should I use? [1 mark]
## contingency table of counts

#(19) Do what you identified in (18). (Note: you can still get marks here even if you identified the wrong plot in (18).) [3 marks]
table(paData2$site, paData2$country, dnn = c("site", "country"))

#(20) I want to use <impact> to explain <richness>. What plot should I use? [1 mark]
## boxplot

#(21) Do the plot you identified in (20). (Note: you can still get marks here even if you identified the wrong plot in (20).) [5 marks]
paData2 |>
  ggplot(aes(x = impact, y = richness)) +
  geom_boxplot(notch = T) +
  scale_x_discrete(labels = c("Not impacted", "Impacted")) +
  labs(x = "Patches with negative events")

#(Bonus question) From your plot in (21), Do you think that <impact> explains <richness> well? Explain your reasons. [2 marks]

## from the boxplot, we can see that the notch is overlapping. 
## therefore, it is unlikely that impact explains the richness well. 



