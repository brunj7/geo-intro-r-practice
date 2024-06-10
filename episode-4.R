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

# Transform in data frames for visualization
DTM_HARV_df <- as.data.frame(DTM_HARV, xy=TRUE)
DSM_HARV_df <- as.data.frame(DSM_HARV, xy=TRUE)


# Let's plot
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


# Compute the difference using the simple way

CHM_HARV <- DSM_HARV - DTM_HARV
CHM_HARV
CHM_HARV_df <- as.data.frame(CHM_HARV, xy = TRUE)

#Check how it looks
ggplot() +
  geom_raster(data = CHM_HARV_df , 
              aes(x = x, y = y, fill = HARV_dsmCrop)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()

# What is the distribution of canopy height?

ggplot(CHM_HARV_df) +
  geom_histogram(aes(HARV_dsmCrop))

# Compute the difference using the advanced way

# function in R

# Function definition
percentage <- function(x) {
  x/100
}

# Using the function
percentage(34)


# defining our function
CHM_ov_HARV <- lapp(sds(list(DSM_HARV, DTM_HARV)), 
                    fun = function(r1, r2) { 
                      r1 - r2
                      })

# Let's plot
CHM_ov_HARV_df <- as.data.frame(CHM_ov_HARV, xy = TRUE)

ggplot() +
  geom_raster(data = CHM_ov_HARV_df, 
              aes(x = x, y = y, fill = HARV_dsmCrop)) + 
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) + 
  coord_quickmap()


# Save our new raster
writeRaster(CHM_ov_HARV, "CHM_HARV.tiff",
            filetype="GTiff",
            overwrite=TRUE,
            NAflag=-9999)

