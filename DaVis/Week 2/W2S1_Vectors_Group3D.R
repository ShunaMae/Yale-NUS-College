# to convert scientific notation (e) to floating,
# format(v, scientific = FALSE)

# 1.1
q1.1.1 <- seq(1:25)
q1.1.2 <- (2^q1.1.1 / q1.1.1)


# 1.2
q1.2.1 <- seq(3, 36, by = 3)
q1.2.2 <- seq(1, 34, by = 3)
q1.2.3 <- (0.1^q1.2.1 * 0.2^q1.2.2)


# 2.1
x <- c(2, 3, 5, 7, 11)
y <- rep(c(2, 4), each = 2)
x[y]
# y produces 2 2 4 4. y contains the indexes used to subset x.
# The numbers corresponding to the 2nd and 4th position of x,
# which are 3, 7, are each repeated twice.

# 2.2
x <- c(1, 1, 2, 3, 5, 8)
y <- c(FALSE, TRUE)
x[y]
# y contains the indices used to subset x.
# As y is shorter in length than x, the elements in y were recycled thrice.
# The elements in x corresponding to the TRUE values in y, which are in the
# 2nd, 4th, 6th position of y, are the output.


# 2.3
x <- seq(16, 30, by = 4)
y <- x %% 7 + 1
LETTERS[y]
# x produces the series (16 20 24 28).
# y contains elements that are the remainder of these numbers when they are
# divided by 7, and then added to 1.
# This results in the elements 3 7 4 1.
# When y is subsetted under LETTERS,
# it produces the 3rd, 7th, 4th, and 1st letters of the alphabet in that order.

# 3
cc <- c()
even <- seq(2, 52, 2)
odd <- seq(1, 52, 2)
cc[even] <- LETTERS
cc[odd] <- letters
print(cc)

# Acknowledgements to Charlize's group for the above code in class.

# 4.1
q4.1.1 <- rep(1:17, each = 4)
q4.1.2 <- 0:3
q4.1.3 <- q4.1.1 + q4.1.2

# 4.2
q4.2.1 <- 1:20
q4.2.2 <- rep(seq(1, 20, 2), each = 2) + c(1, 0)
q4.2.3 <- q4.2.1^q4.2.2

# 5.1
q5.1.1 <- 0:1000
q5.1.2 <- sum(1 / factorial(q5.1.1)) # 2.718 (3 d.p)
# This is an approximation of e (mathematical constant).

# 5.2
q5.2.1 <- (1:1000)^2
q5.2.2 <- 2 * prod(4 * q5.2.1 / (4 * q5.2.1 - 1)) # 3.141 (3 d.p)
# This is an approximation of pi (mathematical constant).

# 5.3
# Install package "contfrac" before loading it below 
library(contfrac)
b <- 1 / 1:1000
a <- c(2, rep(1, 999))
q5.3.1 <- GCF(a, b, b0 = 2, finite = TRUE, tol = 0) # 3.141 (3 d.p)
# This is an approximation of pi (mathetmatical constant).
# Credits to https://cran.r-project.org/web/packages/contfrac/contfrac.pdf














