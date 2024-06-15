###########################################################
#                Hands-On Exercise (HEx) 01               #
###########################################################
# This is what our HEx will look like                     #
# Write your R code here and submit this file on Canvas   #
# If you are asked to submit some screenshots/images,     #
#  paste them onto a word document and submit it too.     #
###########################################################

###########################################################
##Section A: Installing R and Starting a New Project
###########################################################
#(1) Create a new project named "Week 01.Rproj" (in a folder of your choice) following the instructions in the lecture slides.
#No code needed#

#(2) Create a new script and save it as "Week 01.R".
#No code needed#

#(3) Using the code provided in the lecture slides, install the <readxl> package. [2 marks]


#(4) Now try to write your own code to install a package called <ggplot2>. [2 marks]


###########################################################
##Section B: Importing datasets into R
###########################################################
#(5) Download the "heightweight.xlsx" dataset from Canvas and put it in your R Project folder.
#No code needed#

#(6) Import it into R using the read_excel() command and save it as an object called <d1>. [3 marks]


#(7) Save "heightweight.xlsx" as a tab-delimited (.txt) file from Excel (Save as...) and import it as an object called <d2>. [4 marks]


#(8) Save "heightweight.xlsx" as a CSV (.csv) file from Excel (Save as...) and import it as an object called <d3>. [3 marks]


###########################################################
##Section C: Preparing data in R
###########################################################
#(9) Create a vector named <hp> with the following values in it: 41,39,61,73,84,22. [2 marks]


#(10) Change the value of the third element in <hp> to 55. [1 mark]


#(11) Halve all the values in <hp> and round them up to the nearest whole number. [3 marks]


#(12) Remove the last element from <hp>. [1 mark]


#(13) What is the value of the sum of all the elements in <hp> now? [1 mark]


#(14)(a) Create a vector <reps> with elements that increase from 1 to <101 in steps of 4. [2 marks]

#(14)(b) How many elements are inside <reps>? [1 mark]


#(15) How many rows are in your dataset <d1>? [1 mark]


#(16)(a) Using the <hp> vector from (12), replicate it 5 times to get one long vector called <hpr>. [2 marks]

#(16)(b) Check that <hpr> has the same number of elements as <d1> has rows. If not, try too repeat the steps above. [1 mark]


#(17) Add <hpr> to to <d1> as a variable called "headPeak". [2 marks]


#(18) Using this new <d1>, find the means of headPeak by Sex (i.e. for M and for F separately). (4 marks)


#(19) Write a Conditional command to implement the following: if the mean <weight> in <d1> is 60, multiply <headPeak> by 2. [4 marks]


#(20) Write a For loop adding 1 to d1$headPeak[1]; 2 to d1$headPeak[2]; ... 25 to d1$headPeak[25]. [6 marks]
#Hint: your dummy variable <i> starts from 1 and increases by 1 with each iteration.




