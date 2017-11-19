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

# Define a blank theme for ggplot to get rid of bloat ----
blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text =  element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

# Plot the raster ----
ggplot(fnetherlands, aes(x = long, y = lat, group = group)) + 
  geom_path(size = .2) +
  geom_polygon(data = tbl_province, 
               aes(x = long, y = lat, fill = qty_population_km2)) +
  geom_path(data = fprovinces, 
            aes(x = long, y = lat), size = .2) + 
  scale_fill_continuous(low = "#8FC4FF", high = "#483D7A", na.value = NA)  +
  labs(fill = "Population/km2") +
  blank_theme

# Combining a google map with the raster ----
library(ggmap)
map_nld <- get_map(location = "netherlands", 
                   zoom = 7, 
                   maptype = "terrain", 
                   source = "google", 
                   color = "color")

ggmap(map_nld) + 
  geom_path(data = fnetherlands, aes(x = long, y = lat, group = group), size = .2) +
  geom_polygon(data = tbl_province, 
               aes(x = long, y = lat, group = group, fill = qty_population_km2), alpha = 0.7) +
  geom_path(data = fprovinces, 
            aes(x = long, y = lat, group = group), size = .2) + 
  scale_fill_continuous(low = "#8FC4FF", high = "#483D7A", na.value = NA) +
  labs(fill = "Population/km2") +
  blank_theme
