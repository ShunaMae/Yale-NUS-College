#View(iris) in CONSOLE to see the data set 

data(iris)
iris
summary(iris)

nrow(iris)
ncol(iris)

unique(iris$Species)

table(iris$Species)

mean(iris$Sepal.Length)

aggregate(Sepal.Length~Species, 
          data = iris, 
          FUN = mean)

boxplot(iris$Sepal.Length ~ iris$Species, 
        col = "lightgreen", 
        xlab = "Species", 
        ylab = "Sepal length (cm)", 
        main = "Anderson's Iris Data")


par(mfrow = c(3, 1))

setosa <- iris[iris$Species == "setosa",]
versicolor <- iris[iris$Species == "versicolor",]
virginica <- iris[iris$Species == "virginica",]

hist(setosa$Sepal.Length,
     xlab = "Sepal length (cm)",
     main = "setosa",
     ylim = c(0,12),
     breaks = c(seq(4.3,8, 0.2)),
     xlim = c(4.3, 8))
grid()

hist(versicolor$Sepal.Length, 
     xlab = "Sepal length (cm)", 
     main = "versicolor", 
     ylim = c(0,12), 
     breaks = c(seq(4.3,8, 0.2)),
     xlim = c(4.3, 8))
grid()

hist(virginica$Sepal.Length, 
     xlab = "Sepal length (cm)", 
     main = "versicolor", 
     ylim = c(0,12), 
     breaks = c(seq(4.3, 8, 0.2)), 
     xlim = c(4.3, 8))
grid()

