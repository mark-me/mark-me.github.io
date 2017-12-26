library(RCurl)      # The library that is used for downloading the data
library(tidyverse)  
library(ggrepel)    # The library used for labelling MDS plots, which prevents overlapping labels

col_theme <- c("#222430", "#136692", "#573253", "#883F9F", "#B2E4AB", "#B19EF8", "#69C4EC", "#35166E", "#6E3516", "#4F6E16", 
               "#136692", "#573632", "#325736", "#325357", "#9F3F56", "#569F3F", "#3F9F88", "#ABE4DD", "#DDABE4", "#E4ABB2", 
               "#F89EE5", "#E5F89E", "#9EF8B1", "#9169EC", "#EC9169", "#C4EC69", "#0390CA", "#3D03CA", "#CA3D03", "#90CA03")  # Color theme

# Download and prepare the data ----
# Data about countries and their corresponding ISO-3 codes, used for plotting the world map
x <- getURL("https://raw.githubusercontent.com/mark-me/mark-me.github.io/master/_pages/tutorials/clustering-mds/COW_country_codes.csv")
df_country <- read.csv(text = x, stringsAsFactors = FALSE)
df_country %<>%   # Transform country data, so naming conventions are met, and data is deduplicated 
  select(name = StateAbb, country = country_area, iso_alpha_3) %>% 
  unique()

# Data that relates religion codes to names.
x <- getURL("https://raw.githubusercontent.com/mark-me/mark-me.github.io/master/_pages/tutorials/clustering-mds/COW_religion_codes.csv")
df_religion <- read.csv(text = x, na.strings = "", stringsAsFactors = FALSE)

# Correlates of war religion data: http://cow.dss.ucdavis.edu/data-sets/world-religion-data
x <- getURL("https://raw.githubusercontent.com/mark-me/mark-me.github.io/master/_pages/tutorials/clustering-mds/WRP_national.csv")
df_country_religion <- read.csv(text = x, stringsAsFactors = FALSE)
rm(x)

# Complete country religion data and select the year 2010
df_country_religion %<>%
  filter(year == 2010) %>%
  left_join(df_country, by = "name") %>%
  select(-year, -state, -name, -reliabilevel) %>%  # Removing irrelevant columns 
  filter(!is.na(country)) %>%                             # Remove the rows that are not recognized as countries
  gather(key = religion, value = qty_adherents, -country, -iso_alpha_3) %>%   # Rotate all columns with numeric values to rows
  inner_join(df_religion, by = "religion") %>%            # Join all religion codes, so non-religion rows are omitted
  filter(qty_adherents > 0 & !is.na(religion_group)) %>%  # Remove all religion's that are aggregates of other specified religions 
  group_by(country, iso_alpha_3, religion_group) %>%      # Aggregate the countries and religious groupings
  summarise(qty_adherents = sum(qty_adherents)) %>%       # Sum the number of adherents per religious groups for each country
  ungroup() %>% 
  group_by(country, iso_alpha_3) %>%                      # These last 3 statements calculate the percentage of religious per group for each country
  mutate(perc_adherents = qty_adherents / sum(qty_adherents)) %>% 
  ungroup()

# Create a matrix od countries and their religions as columns ----
df_country_by_religion <- df_country_religion %>%
  select(-qty_adherents) %>% 
  spread(key = religion_group, 
         value = perc_adherents, 
         fill = 0)

rm(df_country_religion, df_religion, df_country)

# Creating distances ----
dist_religion <- dist(df_country_by_religion[, -c(1:3)], method = "manhattan")

# MDS ----
mat_distance <- as.matrix(dist_religion)                    # Turn the distances object into a regular matrix
row.names(mat_distance) <- df_country_by_religion$country   # Add the country names as row labels
colnames(mat_distance) <- df_country_by_religion$country    # Add the country names as column names

mds_religions <- cmdscale(mat_distance)  # Perform the actual MDS

# Create a data-frame for the MDS solution
df_mds_religions <- cbind(df_country_by_religion,
                                     x = mds_religions[,1], 
                                     y = mds_religions[,2])

