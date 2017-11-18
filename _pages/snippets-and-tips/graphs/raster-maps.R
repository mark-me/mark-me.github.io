# Get country data ----
library(RCurl)
x <- getURL("https://raw.githubusercontent.com/mark-me/mark-me.github.io/master/_pages/snippets-and-tips/graphs/dutch-population.csv")
tbl_dutch_population <- read.csv(text = x, na.strings = "")
rm(x)

# Load graphic libraries ----
library(tidyverse)
library(raster)

# Get maps ----
netherlands <- getData("GADM", country = "NLD", level = 0)
provinces <-  getData("GADM", country = "NLD", level = 1)

# Convert rasters to ggplot-ready data frames ----
fnetherlands <- fortify(netherlands)
fprovinces <- fortify(provinces)

# Create a set of unique provinces with their respective raster id ----
tbl_province <- data.frame(id = as.character(provinces$ID_1),
                           name = provinces$NAME_1)

# Add Dutch population data set ----
tbl_province <- tbl_province %>% 
  left_join(tbl_dutch_population, by = c("name" = "province")) %>% 
  left_join(fprovinces, by = "id")

# Plot the raster ----
ggplot(fnetherlands, aes(x = long, y = lat, group = group)) + 
  geom_path() +
  geom_polygon(data = tbl_province, 
               aes(x = long, y = lat, fill = qty_population_km2)) +
  geom_path(data = fprovinces, 
            aes(x = long, y = lat)) + 
  scale_fill_continuous(low = "#8FC4FF", high = "#483D7A", na.value = NA) 
