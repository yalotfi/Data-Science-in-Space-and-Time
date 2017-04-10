###############################
###############################
# Author: Yaseen Lotfi        #
# Date: 4/10/2017             #
# Title: Lab 1 Skeleton Files #
# Description:                #
#   Dealing with Data         #
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

names(raw_data)[1] <- "ID"  # Tells R to assign the string value, "ID" to the first element of names(raw_data)

# Note what the old name was and whether or not is changes.

# 2) Show the number of rows and columns, run:
#   nrow(objName)
#   ncol(objName)

# 3) Avoid printing all of your data by looking at the first or last n-number of rows
#   head(objName, n)
#   tail(objName, n)

# The default is 6 rows. It is more productive to use head or tail than to click on
# on the data object in the RStudio IDE. Get in the habit of using the console because
# you will become a more efficient and productive programmer.














