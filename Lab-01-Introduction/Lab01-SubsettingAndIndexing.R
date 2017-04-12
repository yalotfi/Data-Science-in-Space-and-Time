rm(list = ls())

################
## Data Types ##
################

# A single value
x <- 12

# A numeric list, or vector
x_ <- seq(1,20,2)

# Build a 4x4 Matrix (missing data is intentional)
A <- matrix(data = c(1,2,3,NA,
                    4,5,6,NA,
                    7,8,9,NA,
                    10,11,12,NA)
           , nrow = 4
           , ncol = 4)  # 4x4 Matrix

# Rule-based Matrix Building
B <- matrix(data = c(seq(1,10,3),
                    seq(2,11,3))
           , nrow = 2
           , ncol = 4)  # 2x4 Matrix

# Try changing the dimensions of these matrices.
# Note: Take note of any errors you might get.

# We can check the data type of any R object with 
class(A)
class(B)