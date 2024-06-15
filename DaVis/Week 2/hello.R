# writing a general function 
say_hello <- function(name){
  print(c("Hello,", name), quote = FALSE)}

say_hello("Shuna")

# we can set a default value 
say_hello <- function(name = "world"){
  print(c("Hello,", name), quote = FALSE)}
say_hello()
say_hello("You")

# return value of a function 
increment <- function(x){
  return(x+1)
}

increment(10)

y <- increment(10)
y + 10

# concatenate and print function 
return_null <- function(){
  cat("I'm printing a lot of stuff, but I will not return anything")
}
z <- return_null()
z


square_1 <- function(x) {
  print(x^2)
}
square_2 <- function(x) {
  x^2
}
square_3 <- function(x) {
  cat(x^2)
}

square_1(10)
square_2(10)
square_3(10)




rnorm(mean = 0, sd = 1)



rnorm(sd = 1, x = 10, mean = 0)


rnorm(10, 0, 1)




rnorm(10, 0, sd = 1)
