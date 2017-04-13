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

# What is a data frame? Basically a matrix but columns can have different data types,
# unlike matrices which must be numeric. These include classes, strings, and numerics.

# For simplicity, we will work a generic data set that is included with R.

# First save the data set:

df <- mtcars  # We are assigning the variable mtcars to our own defined variable of df

# mtcars, among many other data sets, are preloaded in every R session

# Explore the dataset a little by printing information to the console:

class(df)  # Notice the class is data.frame
str(df)  # Print out description of the data structure
names(df)  # Print column names of the dataset
summary(df)  # Print summary statistics of each column
head(df)  # Print the first 6 rows, add an argument to print n rows
tail(df)  # Print the first 6 columns, add an argument to print n columns
nrow(df)  # Ask R to count the number of rows in your data set
ncol(df)  # Ask R to count the number of columns

# Remember that while these commands alone simply print output to the console, we can
# SAVE their values in variables!

colNames <- names(df)  # Now we have an array of strings where each element is a column name
numberOfRows <- nrow(df)  # Saved an integer value representing our total number of rows
numberOfCols <- ncol(df)  # Same as above, but for column count

# How can we extract specific information from the dataframe? By using indexes and subsets.
# Print the first value of the first column:
df[1, 1]

# Print the first row:
df[1, ]

# Print the last row, two ways:
df[32, ]  # Explicitely because we know the row of interest
df[numberOfRows, ]  # This is the same as df[nrows(df), ] OR df[32, ]

# Print by IDs:
df[ ,"mpg"]  # mpg is the first column, so this is the same as df[ ,1]

# Remember the array of column names we saved?
df[ ,colNames[1]]  # Index inception!! Indexing works for dimensional data types

# A more concise way to pull column-wise vectors, like above, is with the $ operator
df$mpg # is the same as df[ ,"mpg"] AND df[ ,colNames[1]] but is MORE CONCISE

# The $ operator can be used to create new columns as well:
df$mpg_2 <- df$mpg^2  # We define a new column value and name by simple assignment

# That we have altered our dataset, the variables that store the the old column
# names and count did NOT update. This is an example of when we might want to
# overwrite a variable with a new value.

colNames <- names(df)
numberOfCols <- ncol(df)
