## Episode 4

library(tidyverse)
library(terra)

# Check the data
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
describe("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")


# loading the raster data
DTM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif")
DTM_HARV

DSM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif")
DSM_HARV

# Compute the difference
DTM_HARV_df <- as.data.frame(DTM_HARV, xy=TRUE)
DSM_HARV_df <- as.data.frame(DSM_HARV, xy=TRUE)


#Let's have a look at it

ggplot() +
  geom_raster(data = DTM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()


ggplot() +
  geom_raster(data = DSM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) + 
  coord_quickmap()

# Compute the difference

CHM_HARV <- DSM_HARV - DTM_HARV

CHM_HARV_df <- as.data.frame(CHM_HARV, xy = TRUE)

ggplot() +
  geom_raster(data = CHM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dsmCrop)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()