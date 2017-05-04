x <- floor(runif(50, 1, 11))
y <- floor(runif(50, 1, 11))
z <- floor(runif(50, 1, 11))

lm(x ~ x + x + 1)
