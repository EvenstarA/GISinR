# GIS in R Module
# Lecture Notes - 26/02/2025 
# Arwenn Kummer
install.packages(c("tidyverse", "sf", "lwgeom", "terra", "stars", "exactextractr"))
install.packages(c("cowplot", "hrbrthemes", "knitr", "leaflet", "htmltools", "rosm", "ggspatial", "rnaturalearth", "mapview", "tmap"))

# load libraries
library(tidyverse)
library(readr)
library(sf)
library(terra)

# read the vegetation data in; historic extent (veg_h) and current(veg_c)

veg_h <- st_read("C:/Users/Arwenn Kummer/Documents/GIT/GISinR/Indigenous_Vegetation_-_Historic_Extent/Indigenous_Vegetation_-_Historic_Extent.shp")

veg_c <- st_read("C:/Users/Arwenn Kummer/Documents/GIT/GISinR/indigenous_veg_current_extent/Indigenous_Vegetation_-_Current_Extent.shp")


# HISTORIC VEGETATION TYPES ----

# using veg_h data, we want to map the vegetation types to the historic extent of the vegetation
st_crs(veg_h)
# PROJCRS: WGS84 / Pseudo-Mercator
# CONVERSION: Popular Visualization Pseudo-Mercator, 0 
# CS: North and East. Cartesian 2 

# Checking structure, head and classes
str(veg_h)
class(veg_h)
head(veg_h)

# getting column names
names(veg_h)

# plot the national vegetation type maps
plot(veg_h[2])

# plot the vegetation types with different colors that represent the different NTNL_VGTN_ values
ggplot() +
  geom_sf(data = veg_h, aes(fill = `NTNL_VGTN_`)) +
  theme_minimal()


# iNATURALIST OBSERVATION DATA ----

install.packages("rinat")
library(rinat)

# linepithema humile observations 
lh <- get_inat_obs(taxon_name = "Linepithema humile",
                   bounds = c(-35, 18, -33.5, 19), # THESE BOUNDS VALUES COULD BE REALLY USEFUL SOMEWHERE ELSE IN THE CODE!
                   maxresults = 1500)
head(lh)
 
# filter the observations by a range of column attribute criteria

#Filter returned observations by a range of column attribute criteria
lh <- lh %>% filter(positional_accuracy<46 & 
                      latitude<0 &
                      !is.na(latitude) &
                      captive_cultivated == "false" &
                      quality_grade == "research")

class(lh)

# convert the data frame above to be a spatial object so we can map it

lh_sf <- st_as_sf(lh, coords = c("longitude", "latitude"), crs = 4326)

view(lh_sf)

class(lh_sf)
names(lh_sf)

# plot the species distribution on a lat/long axes
ggplot() + geom_sf(data = lh_sf)


# USING VEG PLOTS AND iNATURALIST DATA: ---- 

# here we need to use the raster part...

# we need to rasterize our data; turn the vector layer into a raster, but we need an existing raster grid to rasterize to, like dem30 in this example. (dem30 is an elevation data frame it seems...which I'm not currently using?) 

# 
# veg_h$NTNL_VGTN_ <- as.factor(veg_h$NTNL_VGTN_ )
# 
# veg_h_ras <- rasterize(vect(veg_h),  field = "NTNL_VGTN_")
# 
# veg_h_ras %>%
#   as.data.frame(xy = TRUE) %>%
#   ggplot() +
#   geom_raster(aes(x = x, y = y, fill = NTNL_VGTN_))


ggplot() +
  geom_sf(data = veg_h, aes(fill = `NTNL_VGTN_`)) +
  geom_sf(data = lh_sf, colour = "black", size = 0.8)
  



# ADDING A BASELINE MAP TO THE PLOT ----

library(rosm)
library(ggspatial)
install.packages("prettymapr")
library(prettymapr)

# Add open street map to plot
ggplot() + 
  annotation_map_tile(type = "osm", progress = "none") + 
  geom_sf(data=lh_sf)

# interactive maps with leaflet and map view

library(leaflet)
library(htmltools)

leaflet() %>% 
  addTiles(group = "Default") %>%
  addCircleMarkers(data = lh_sf, 
                   group = "Linepithema humile", 
                   radius = 3, 
                   color = "blue")

# common sense checks: see where they pop up
library(mapview)
library(leafpop)

mapview(lh_sf, 
        popup = 
          popupTable(lh_sf,
                     zcol = c("user_login", "captive_cultivated", "url")))


# I may not actually need to crop this map......----
# myextent <- st_sf(a = 1:2, geom = st_sfc(st_point(c(18,-33)), st_point(c(19,-34))), crs = 4326)
# 
# myextent <- st_transform(myextent, crs = "+proj=pmerc +lat_0=0 +lon_0=19 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs") 

# veg_h <- st_crop(veg_h, myextent)

# #Make a vector with desired coordinates in metres according to CRS
# ext <- c(-66642.18, -3809853.29, -44412.18, -3750723.29) 
# names(ext) <- c("xmin", "ymin", "xmax", "ymax") 
# ext
