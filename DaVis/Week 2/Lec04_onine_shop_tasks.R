# How profitable is your online shop? 

## Load packages 
library(styler)


## 1. Creating Vectors 

### a) create two vectors 
Customers <- c(33,22,41,39,38,46,47) |> as.integer()
####Customers <- as.integer(c(33,22,41,39,38,46,47))
Sales <- c(65.05, 80.17, 326.53, 137.88,
           374.34, 329.04, 251.29)

### b) how to confirm the class and number of element
#### class and length for customers 
class(Customers)
length(Customers)

#### class and length for sales
class(Sales)
length(Sales)



## 2. Vector operations and sub-setting 

### a) create sales_per_customer
sales_per_customer <- Sales / Customers
sales_per_customer

### b) fix the wrong value 
Sales[4] <- 317.88
sales_per_customer <- Sales / Customers


### c) total customers and total sales 
sum(Customers)
sum(Sales)

### d) mean daily sales on the weekend 
mean(Sales[1:2])

### e) mean daily sales on weekdays 
#### positively
mean(Sales[3:7])
#### negatively
mean(Sales[-1:-2])

### f) the cost for web-designer 
if (sum(Sales[3:7]) * 0.1 - 50 > 0){
  print("The additional Sales is bigger")
} else{print("The cost is bigger")}


## 3. Writing our own function

daily_customers <- c(33L, 22L, 41L, 39L, 38L, 46L, 47L)
daily_sales <- c(65.05, 80.17, 326.53, 317.88, 374.34, 329.04, 251.29)

### a) calculate the total number of customers 
sum(daily_customers)
sum(daily_sales)


### b) the predicted weekly profit
daily_sales_with_strategy = c()
for (i in c(1:7)){
  daily_sales_with_strategy[i] = (daily_sales[i]/daily_customers[i]) * (daily_customers[i] + 2)
}
sum(daily_sales_with_strategy) - 50

### c) write a function
weekly_profit <- function(d_customers, d_sales, w_ad_cost, addl_d_customs){
  ave <- d_sales / d_customers
  ave_new <- ave * addl_d_customs
  return (sum(ave_new) + sum(d_sales) - w_ad_cost)
}

### d) the weekly profit without advertisement 
weekly_profit(daily_customers, daily_sales, 0, 0)

### e) the weekly profit with the basic package
weekly_profit(daily_customers, daily_sales, 50, 2)




## 4. Working with sequences 

### a) the number of additional customers 
additional <- seq(2,12, by = 2)
additional 

### b) the costs of the advertising packages
weekly_cost <- cumsum(seq(50,100,by = 10))
weekly_cost

### c) the weekly profit under each scenario 
profit_with_packages <- c()
for (i in c(1:6)){
  profit_with_packages[i] <- weekly_profit(daily_customers, daily_sales, 
                                           weekly_cost[i], additional[i])
}
profit_with_packages


## 5. Finding the maximum of vector 

### a) 

wp <- mapply(
  weekly_profit,
  weekly_cost, 
  additional,
  MoreArgs = list(
    d_customers = daily_customers,
    d_sales = daily_sales
  )
)

### b) find the maximum profit from wp 
max(wp)

### c) find the advertising package that maximizes profit 
which.max(wp)
