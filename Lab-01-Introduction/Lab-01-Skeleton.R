###############################
###############################
# Author: Yaseen Lotfi        #
# Date: 4/10/2017             #
# Title: Lab 1 Skeleton Files #
# Description:                #
#   Working with real data    #
###############################
###############################

# Always include these statements at the top of your scripts.
# First, a statement to clean your R environment
# Second, a statement which sets your working directory
# Third, check that your working directory was set to the proper destination

rm(list = ls())
setwd("C:/Users/yalot/OneDrive/CompSci/GitHub/Data-Science-in-Space-and-Time/Lab-01-Introduction")
getwd()

##############
## Packages ##
##############

# If you need to install the packages:
#   1) Highlight the install.packages block
#   2) Ctr/Command + Shift + C to uncomment
#   3) Run those lines to install

# install.packages("dplyr", dependencies = T)
# install.packages("stringr", dependencies = T)
# install.packages("ggplot2", dependencies = T)
# install.packages("ggmap", dependencies = T)
# install.packages("rgdal", dependencies = T)
# install.packages("raster", dependencies = T)
library(dplyr)
library(stringr)
library(ggplot2)
library(ggmap)
library(rgdal)
library(raster)

# You have now loaded all third-party software meaning
# that you can now use commands that are otherwise not
# available in base R.


#########################
### Import Flat Files ###
#########################

# After installing and loading R software packages,
# we can start working with our dataset.

# read() commands search for files and create R dataframes.
# You need to supply the filepath to the dataset
# To see other options, run ?read.csv in the console.

# The file path begins from your working directory => Look in the data folder and find the *.csv file
# Tell R how to read this data, splitting each data point everytimme it finds a comma
#   *.csv == "comma-separated-value"

inst_raw_data <- read.csv2("data/hd2014.csv", sep = ",")
admin_raw_data <- read.csv("data/adm2014.csv", sep = ",")

# What command and arguments would you use if the data was tab-delimited?

############################
### Merge Two Dataframes ###
############################

# Sometimes separate data contain information we need for our analysis.
# In this case it is useful to merge or join two datasets by a common column.
# Below are two ways to do the same thing. Left join is more precise in what we are
# actually doing, and this command comes from the "dplyr" package. There are different
# types of join which we could also if we wanted.  Run ?left_join to see these options
# and read some of the resources on the GitHub Repo for more in depth explanations.

raw_data_merge <- merge(x = inst_raw_data, y = admin_raw_data, by = "UNITID", all.x = TRUE)
raw_data  <- left_join(x = inst_raw_data, y = admin_raw_data, by = "UNITID")

# Up to this point, we have created a lot of unnecessary objects so it is a good time
# clean up our environment a little. After creating a joined dataset, we no longer need
# the initial datasets. It is a good habit to remove unnecessary objects from your
# environment from an efficiency standpoint but also from a readability and organization one.

rm(inst_raw_data, admin_raw_data, raw_data_merge)

# Note, if you try to remove an object that does not exist, R will ignore it and only output a warning.

#############################
### Subsetting & Indexing ###
#############################

# Now that we aggragated our raw_data, we can extract the features that we are interested
# in using for our analysis. For the purposes of this exercise, we will not get into what
# each column means. Instead focus on the mechanics of how we extract the information we want.
# In the future, you will want to think about how to slice and dice your data.

# STEP 2: SUBSETTING
# The next two lines are straightforward. We want to pull a subset of the raw data only where
# the feature ICLEVEL is equal to 9. This command will reduce the number of rows in our data.

institutions <- subset(raw_data, HLOFFER == 9)

# STEP 1: INDEXING
# Indexing is extremely useful. While we take a manual approach here, in the future you will
# use conditional logic to subset and index. For now, all we are doing is pulling which columns
# we are interested in. In this instance, we are reducing the number of features in our dataset
# and saving it in a new data frame called institution. 

# Note the syntax of an index:

# objName[rowNumber, colNumber]  # This will return a single value at this position (think cell addresses in excel)

# This syntax is very useful. We could assign a new value at that index position:

# objName[rowNumber, colNumber] <- someValue

# If we are only interested in rows or columns, we can still use indexing as follow:
# This will return a row-wise or column-wise vector, or 1D list of values. This can be very useful as well,
# but you must recognize what you are indexing.

# objName[, colNumber]  OR  objName[rowNumber, ]

# You will probably not know the row or column numbers more oftent than not. In this case, we can use
# conditional logic with the following syntax:

# objName[conditionalTestRow, conditionalTestCol]  # You can include one or both tests.

# There are a lot of way to construct a conditional test, so it is worth looking through some
# of the resources in the main GitHub repository. We will also emphasize when we use it
# in the future so you can learn to recognize this tool and build an intuition for it.

# Finally, we happen to no which columns we want to keep, so we will index by column
# and save the new dataframe in a variable called 'institutions'. Notice we are overwriting
# the object we already created. This is okay as long as you are aware of what you are doing.
# A lot of errors in the future might come frome the coder unintentionally overwriting a data
# object without realizing it. In this case, we are sure we want to do this.

institutions <- institutions[,c(1:2,4:5,66:67, 80, 86, 92, seq(118, 144, 2))]

# In this use of indexing, we are listing column numbers that we want to extract.
# The colon operator simply says, "1 to 2" or 66:67. The seq() command will start
# at the first argument, 118 and count up to the second argument, 144, incrementing by 2.
# To understand the code, copy seq(118, 144, 2) into your console to see exactly what it is doing.

# Now we have reduced the dimensionality of our data to something relevant to our analysis. We can
# create new columns by passing some computation over other columns. In this case, we will divide the
# number of students admitted by the number of applicants and save the admission rate to a new columns
# we define as 'percent_admit'.

institutions$percent_admit <- institutions$ADMSSN/institutions$APPLCN

# The $ operator is very important here.

########################
### Explore the Data ###
########################

# Run the following commands in the R Console because they are 
# not necessary for our script. While RStudio will show a lot
# of this info, you can save the output into variables and
# use them to execute based on their values. Conditional logic
# is an important concept beyond the scope of this Lab.

# 1) To view the column names of your dataset, run:
#   names(objName)  # Replace "objName" with name of dataframe

# One way we would use names(x) is for renaming columns. For example,
# we can rename the first column to "ID" with following code:

names(raw_data)[1]
names(raw_data)[1] <- "ID"  # Tells R to assign the string value, "ID" to the first element of names(raw_data)
names(raw_data)[1]

# Note what the old name was and whether or not it changed.

# 2) Show the number of rows and columns, run:
#   nrow(objName)
#   ncol(objName)

# 3) Avoid printing all of your data by looking at the first or last n-number of rows
#   head(objName, n)
#   tail(objName, n)

# The default is 6 rows. It is more productive to use head or tail than to click on
# on the data object in the RStudio IDE. Get in the habit of using the console because
# you will become a more efficient and productive programmer.

# 4) View Data Structure because you should always be thinking of the data type
#   str(objName)

# 5) Summary Statistics of each variable in your dataser:
#   summary(objName)

# 5) Is there missing Data? We can count the number of missing data by column.

apply(raw_data, 2, function(x) sum(is.na(x)))

# There is a lot happening in this line, so let's break it down. The apply() command
# will apply a function over a given data set, defined in the first argument. The 2 tell
# apply() that it should apply the function by column. The third argument is an anonymous
# function because we only use it this one time. We are going to ask if 'x' NA or not. We then
# sum all the TRUE cases, telling us how many null values exist in each column of our data frame.
# This is extremely useful when getting a sense of how 'dirty' your data is. Even if you don't
# get what the code does right away, I recommend using this code in future debugging exercises.













