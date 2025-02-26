# Title: GIS in R Project - Honours, February 2025
# Author: Arwenn Kummer
# Date Created: 24/02/2025 

# Install relevant packages for GIS 
install.packages(c("tidyverse", "sf", "lwgeom", "terra", "stars", "exactextractr"))
install.packages(c("cowplot", "hrbrthemes", "knitr", "leaflet", "htmltools", "rosm", "ggspatial", "rnaturalearth", "mapview", "tmap"))

library(tidyverse)
library(readr)
library(sf)
library(terra)

#  Jasper's Magic Coding Skills got this data in and working:

data = read_delim("line_humile_antweb.txt", delim = "\t")

# so our data is in, and we want only the entries that have "South Africa" as the country
data_sa <- data %>% filter(Country == "South Africa")

# we care the most about the loclatitude and loclongitude variables as these will help us map each observation to the vegetation type layer

# read in the shape file of South Africa
sa_shape <- st_read("C:/Users/Arwenn Kummer/Documents/GIT/GISinR/gadm41_ZAF_shp/gadm41_ZAF_4.shp")

# read in the veg_types shape file for South Africa
veg <- st_read("C:/Users/Arwenn Kummer/Documents/GIT/GISinR/vegmap_2018_shpfile/VEGMAP2018_AEA_07012019_beta.shp")

# check the coordinate reference system used by the vegtypes data
st_crs(veg) #AEA_RSA_WGS84
# BASEGEOGCRS: WGS 84
# CONVERSION: Lambert Azimuthal Equal Area - latitude of false origin ...
# CS: Cartesian axes, 2. Dealing with North and East and units of metres. (yay!)


# Let's look closer at the data:
class(veg) # sf and data.frame 
head(veg) # 6 feeatures and 19 fields


# Can't get this to work...???
st_write(veg, "C:/Users/Arwenn Kummer/Documents/GIT/GISinR/vegmap_2018_shpfile", append = FALSE)

file.exists("C:/Users/Arwenn Kummer/Documents/GIT/GISinR/vegmap_2018_shpfile")

plot(veg)




# Archive ----
# read in the .txt file of data:
# data <- read.table("line_humile_antweb.txt", header = TRUE, sep = " ", col.names = c("SpecimenCode",	"Subfamily",	"Genus",	"Species",	"LifeStageSex",	"Medium",	"SpecimenNotes",	"DNANotes",	"LocatedAt",	"OwnedBy",	"TypeStatus",	"DeterminedBy",	"DateDetermined",	"CollectionCode",	"CollectedBy",	"DateCollectedStart",	"DateCollectedEnd",	"Method",	"Habitat",	"Microhabitat",	"CollectionNotes",	"LocalityName",	"Adm1",	"Adm2",	"Country",	"Elevation",	"ElevationMaxError",	"LocLatitude", "LocLongitude",	"LatLonMaxError",	"Bioregion",	"LocalityNotes",	"LocalityCode",	"Created	uploadId"))
