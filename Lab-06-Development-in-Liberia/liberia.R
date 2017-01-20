######################
### Lab 6 on Slack ###
######################

rm(list=ls(all=TRUE))

# install.packages("sp", dependencies = TRUE)
# install.packages("rgdal", dependencies = TRUE)
# install.packages("rgeos", dependencies = TRUE)
# install.packages("raster", dependencies = TRUE)
# install.packages("spatstat", dependencies = T)
# install.packages("maptools", dependencies = TRUE)
# install.packages("ggmap", dependencies = TRUE)
# install.packages("ggplot2", dependencies = TRUE)
# install.packages("dplyr", dependencies = TRUE)
# install.packages("ncdf4", dependencies = T)
library(sp)
library(rgdal)
library(rgeos)
library(raster)
library(spatstat)
library(maptools)
library(ggmap)
library(ggplot2)
library(dplyr)
library(ncdf4)


###########################
## Bring in Spatial Data ##
###########################
counties <- readOGR(dsn = "counties", layer = "counties", stringsAsFactors = F, verbose = F)
districts <- readOGR(dsn = "districts", layer = "districts", stringsAsFactors = F, verbose = F)
clans <- readOGR(dsn = "clans", layer = "clans", stringsAsFactors = F, verbose = F)
liberia <- readOGR(dsn = "liberia", layer = "liberia_revised", stringsAsFactors = F, verbose = F)
africa <- readOGR(dsn = "liberia", layer = "africa", stringsAsFactors = F, verbose = F)


##################################
## Projection Reference Systems ##
##################################
# proj4string(counties)
# proj4string(districts)
# proj4string(clans)
# proj4string(liberia)
# proj4string(africa)
counties <- spTransform(counties, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
districts <- spTransform(districts, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
clans <- spTransform(clans, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
liberia <- spTransform(liberia, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
africa <- spTransform(africa, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))


#####################
## Data Management ##
#####################
# Fix Bomi
BomiDistricts <- subset(districts@data, districts@data$FIRST_CCNA == "Bomi")
Bomi_HH <- sum(BomiDistricts$HHOLDS)
counties@data[1,7] <- Bomi_HH
rm(BomiDistricts, Bomi_HH)


##############################
## Fortifications and Joins ##
##############################
# Fortifying spatial objects
cnty_f <- fortify(counties, region = "CCNAME")
dist_f <- fortify(districts, region = "DNAME")
clan_f <- fortify(clans, region = "CLNAME")
afr_f <- fortify(africa, region = "COUNTRY")
 
# Extracting relevant Columns from Data
countiesData <- counties@data[,1:8]
districtsData <- districts@data[,1:10]
clansData <- clans@data[,1:11]

# Create ID columns, County already has one
# districtsData$id <- row.names(districtsData)
# clansData$id <- row.names(clansData)

# Performing left joins b/w foritfied obj and data
cnty_f <- left_join(x = cnty_f, y = countiesData, by = c("id" = "CCNAME"))
dist_f <- left_join(x = dist_f, y = districtsData, by = c("id" = "DNAME"))
clan_f <- left_join(x = clan_f, y = clansData, by = c("id" = "CLNAME"))
rm(countiesData, districtsData, clansData)

#######################
## Create Label Objs ##
#######################
# County Labels
cnty_names <- counties@data$CCNAME
cnty_center_pts <- gCentroid(counties, byid = T)
cnty_labels <- cbind.data.frame(cnty_names, cnty_center_pts@coords[,1],cnty_center_pts@coords[,2])
names(cnty_labels) <- c("County", "x", "y")
rm(cnty_names, cnty_center_pts)

# District Labels
dist_names <- districts@data$DNAME
dist_center_pts <- gCentroid(districts, byid = T)
dist_labels <- cbind.data.frame(dist_names, dist_center_pts@coords[,1], dist_center_pts@coords[,2])
names(dist_labels) <- c("District", "x", "y")
rm(dist_names, dist_center_pts)

# Clan Labels
clan_name <- clans@data$CLNAME
clan_center_pts <- gCentroid(clans, byid = T)
clan_labels <- cbind.data.frame(clan_name, clan_center_pts@coords[,1], clan_center_pts@coords[,2])
names(clan_labels) <- c("Clan", "x", "y")
rm(clan_name, clan_center_pts)

# Country Labels
afr_name <- africa@data$COUNTRY
afr_center_pts <- gCentroid(africa, byid = T)
afr_labels <- cbind.data.frame(afr_name, afr_center_pts@coords[,1], afr_center_pts@coords[,2])
names(afr_labels) <- c("Country", "x", "y")
rm(afr_name, afr_center_pts)

# Get Surrounding Countries Names Only
afrTEST1 <- afr_labels[which(afr_labels$Country == "CÃ´te d'Ivoire"),]
afrTEST2 <- afr_labels[which(afr_labels$Country == "Guinea"),]
afrTEST3 <- afr_labels[which(afr_labels$Country == "Sierra Leone"),]
afrTEST <- rbind.data.frame(afrTEST1, afrTEST2, afrTEST3)
# Adjust Positions
afr_labels <- afrTEST[c(1,4,7), 1:3]
afr_labels[1, 2] <- afr_labels[1, 2] - 2.25  # Ivory Coast
afr_labels[1, 3] <- afr_labels[1, 3] - 1.13105  # Ivory Coast
afr_labels[2, 2] <- afr_labels[2, 2] + 1.9173  # Guinea
afr_labels[2, 3] <- afr_labels[2, 3] - 2.439738  # Guinea
afr_labels[3, 2] <- afr_labels[3, 2] + 0.78653  # Sierra Leonne
afr_labels[3, 3] <- afr_labels[3, 3] - 0.561883  # Sierra Leonne
rm(afrTEST, afrTEST1, afrTEST2, afrTEST3)


##########################
## Managing Survey Data ##
##########################
cwiq10 <- load("cwiq10.RData") # Does not load workspace ???

# Create Survey Centerpoints
cnty_survey_cpts <- cbind.data.frame(county_id = counties@data$FIRST_CCOD, cnty_labels, stringsAsFactors = F)
dist_survey_cpts <- cbind.data.frame(county_id = districts@data$FIRST_CCOD, district_id = districts@data$FIRST_DCOD, dist_labels, stringsAsFactors = F)
clan_survey_cpts <- cbind.data.frame(county_id = clans@data$FIRST_CCOD, district_id = clans@data$FIRST_DCOD,clan_id = clans@data$FIRST_CLCO, clan_labels, stringAsFactors = F)

# Correcting Survey Codes
cwiq10$county <- substr(cwiq10$hid_mungai, 1, 2)
cwiq10$district <- substr(cwiq10$hid_mungai, 3, 4)
cwiq10$clan_town <- substr(cwiq10$hid_mungai, 5, 7)
cwiq10$county[cwiq10$county == "01"] <- "30"

# Reconstructing District Codes
dist_survey_cpts$dist_code <- paste(dist_survey_cpts$county_id, dist_survey_cpts$district_id, sep = "")
cwiq10$dist_code <- paste(cwiq10$county, cwiq10$district, sep = "")

# Reconstructing Clan Codes
clan_survey_cpts$clan_code <- paste(clan_survey_cpts$county_id, clan_survey_cpts$district_id, clan_survey_cpts$clan_id, sep = "")
cwiq10$clan_code <- paste(cwiq10$county, cwiq10$district, cwiq10$clan_town, sep = "")

# Join Survey and Census Data
cwiq_cnty <- left_join(x = cnty_survey_cpts, y = cwiq10, by = c("county_id" = "county"))
cwiq_dist <- left_join(x = dist_survey_cpts, y = cwiq10, by = c("dist_code" = "dist_code"))
cwiq_clan <- left_join(x = clan_survey_cpts, y = cwiq10, by = c("clan_code" = "clan_code"))


##############
## Clan Map ##
##############
clan_liberia <- get_map(location = c(-11.5, 4.25, -7.35, 8.6), zoom = 7, maptype = "watercolor")
clan_liberia <- ggmap(clan_liberia)
clan_liberia <- clan_liberia + geom_map(data = clan_f, map = clan_f, aes(x = long, y = lat, map_id = id, fill = log10(SUM_TOTAL)))
clan_liberia <- clan_liberia + geom_map(data = afr_f, map = afr_f, aes(x = long, y = lat, map_id = id), color = "white", alpha = 0, size = 1.25)
clan_liberia <- clan_liberia + geom_map(data = cnty_f, map = cnty_f, aes(x = long, y = lat, map_id = id), color = "white", alpha = 0, size = 0.75)
clan_liberia <- clan_liberia + scale_fill_gradient(low = "chocolate4", high = "chocolate1", space = "Lab")
clan_liberia <- clan_liberia + annotate('text', x = cnty_labels$x, y = cnty_labels$y, label = cnty_labels$County, size = 2.8, color = "black")
clan_liberia <- clan_liberia + annotate('text', x = afr_labels$x, y = afr_labels$y, label = afr_labels$Country, size = 4.25)
clan_liberia <- clan_liberia + ggtitle("Liberian Clans")
clan_liberia

ggsave("latex/clans_liberia.pdf", clan_liberia, width = 10, height = 10, dpi = 300)


#######################
## Spatial Densities ##
#######################
# Subset by Religion
clanChristian <- subset(cwiq_clan, n12 == 1)
clanMuslim <- subset(cwiq_clan, n12 == 2)
clanTraditional <- subset(cwiq_clan, n12 == 3)
clanOther <- subset(cwiq_clan, n12 == 4)

# Subset by Education - None (00), S8 (22), SH12 (26), Uni (31)
clanNoEdu <- subset(cwiq_clan, o3 == 00)
clanS8 <- subset(cwiq_clan, o3 == 22)
clanSH12 <- subset(cwiq_clan, o3 == 26)
clanUni <- subset(cwiq_clan, o3 == 31)

# Create Point Pattern Window
win <- as(liberia,"owin")

# Create Point Pattern Class Objs
pppChristian <- ppp(x = clanChristian$x, y = clanChristian$y, window = win, marks = clanChristian$wta_hh)
pppMuslim <- ppp(x = clanMuslim$x, y = clanMuslim$y, window = win, marks = clanMuslim$wta_hh)
pppTraditional <- ppp(x = clanTraditional$x, y = clanTraditional$y, window = win, marks = clanTraditional$wta_hh)
pppOther <- ppp(x = clanOther$x, y = clanOther$y, window = win, marks = clanOther$wta_hh)
rm(clanChristian, clanMuslim, clanTraditional, clanOther)

pppNoEdu <- ppp(x = clanNoEdu$x, y = clanNoEdu$y, window = win, marks = clanNoEdu$wta_hh)
pppS8 <- ppp(x = clanS8$x, y = clanS8$y, window = win, marks = clanS8$wta_hh)
pppSH12 <- ppp(x = clanSH12$x, y = clanSH12$y, window = win, marks = clanSH12$wta_hh)
pppUni <- ppp(x = clanUni$x, y = clanUni$y, window = win, marks = clanUni$wta_hh)
rm(clanNoEdu, clanS8, clanSH12, clanUni)

# Plot 4 Densities by Religion
par(mar=c(0,0,1,1))

# Christians
pdf("latex/clan_christian.pdf")
plot(density(pppChristian), main = "Christians")
dev.off()
# Muslims
pdf("latex/clan_Muslim.pdf")
plot(density(pppMuslim), main = "Muslims")
dev.off()
# Traditional Religions
pdf("latex/clan_Traditional.pdf")
plot(density(pppTraditional), main = "Traditional Religions")
dev.off()
# Other Religion
pdf("latex/clan_Other.pdf")
plot(density(pppOther), main = "Other")
dev.off()
# No Education
pdf("latex/clan_NoEdu.pdf")
plot(density(pppNoEdu), main = "No Education")
dev.off()
# Grade 8
pdf("latex/clan_S8.pdf")
plot(density(pppS8), main = "Grade 8/Middle School")
dev.off()
# Grade 12
pdf("latex/clan_SH12.pdf")
plot(density(pppSH12), main = "Grade 12/High School")
dev.off()
# University
pdf("latex/clan_Uni.pdf")
plot(density(pppUni), main = "University")
dev.off()


