#library(readr)
#titanic <- read_csv("lesson02/titanic (2).csv")
#View(titanic)

titanic <- read.csv("C:/Users/Kelly Ng/Downloads/titanic.csv")

#A comma-separated values file is a delimited text file that uses a comma to separate values. 
#Each line of the file is a data record. Each record consists of one or more fields, 
#separated by commas. The use of the comma as a field separator is the source of the name for this 
#file format.


#dimensions of spreadsheet 

nrow(titanic)
#there are 2208 rows 

ncol(titanic)
#there are 11 columns 

#unique values in the column class: 
unique(titanic$class)
#there are 4 unique values. 3rd, crew, 2nd, 1st

#how many people are in each class
table(titanic$class)
#there are 286 people in the 1st class
#271 people in 2nd class
#709 people in 3rd class 
#942 people among the crew 

#create a subset called sec_class that only contains second class passengers   
sec_class <- titanic[titanic$class == "2nd",]

median(sec_class$age)

sum(sec_class$age == 30)

sum(sec_class$gender == "Female" & sec_class$age == 30)

sec_class$price <- sec_class$pnd + sec_class$shl/20 + sec_class$pnc/240

class_survived <- table(titanic$survived, titanic$class)
class_survived

barplot(class_survived, 
        beside = TRUE, 
        col = c("lightgreen", "mediumpurple"))
grid(nx = NA, ny = NULL)
legend("topleft", legend = c("Died", "Survived"), 
       fill = c("lightgreen", "mediumpurple"))
#have to put the legend AFTER grid or the barplot, or else R won't know which graph to put the legend on