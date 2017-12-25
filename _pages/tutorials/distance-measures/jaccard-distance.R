library(RCurl)      # The library that is used for downloading the data
library(tidyverse) 
library(unvotes)
library(lubridate)
col_theme <- c("#222430", "#136692", "#573253", "#883F9F", "#B2E4AB", "#B19EF8", "#69C4EC", "#35166E", "#6E3516", "#4F6E16", 
               "#136692", "#573632", "#325736", "#325357", "#9F3F56", "#569F3F", "#3F9F88", "#ABE4DD", "#DDABE4", "#E4ABB2", 
               "#F89EE5", "#E5F89E", "#9EF8B1", "#9169EC", "#EC9169", "#C4EC69", "#0390CA", "#3D03CA", "#CA3D03", "#90CA03") # My color theme

# Select vote issues ----
select_issue <- "Human rights"

# Descriptions UN roll call data set ----
data(un_roll_calls)
data(un_roll_call_issues)
data(un_votes)

## Create data set
df_country_votes <- un_votes %>% 
  inner_join(un_roll_calls, by ="rcid") %>%
  inner_join(un_roll_call_issues, by = "rcid") %>% 
  select(-country) %>% 
  filter(importantvote == 1 & 
           issue == select_issue &
           !is.na(country_code) ) %>% 
  mutate(year_vote = year(date)) %>%
  mutate(vote_no = ifelse(vote == "yes", 1, ifelse(vote == "no", 0, 99))) %>%
  select(unres, country_code, vote_no) %>% 
  spread(unres, vote_no, fill = 99)

# Data about countries and their corresponding ISO-3 codes, used for plotting the world map
x <- getURL("https://raw.githubusercontent.com/mark-me/mark-me.github.io/master/_pages/tutorials/clustering-mds/COW_country_codes.csv")
df_country <- read.csv(text = x)
df_country %<>%   # Transform country data, so naming conventions are met, and data is deduplicated 
  select(country = country_area, country_code = iso_alpha_2, region, sub_region) %>% 
  unique()

df_country_votes %<>%
  left_join(df_country, by = "country_code") %>% 
  select(country_code, country, region, sub_region, everything() )


# Distance vote concurrence ----
library(vegan)
dist_matrix <- vegdist(df_country_votes[, -c(1:4)], method = "jaccard", na.rm = TRUE)

mat_dist <- as.matrix(dist_matrix)

# MDS vote concurrence ----
mds_country_votes <- cmdscale(dist_matrix) # k is the number of dim
df_mds_country_votes <- data.frame(x = mds_country_votes[,1], 
                                   y = mds_country_votes[,2],
                                   country = df_country_votes$country,
                                   region = df_country_votes$region,
                                   sub_region = df_country_votes$sub_region)

library(ggrepel)
ggplot(df_mds_country_votes,aes(x, y)) +
  geom_jitter(aes(col = region)) +
  geom_label_repel(aes(label = country, fill = region), alpha = .6) +
  scale_color_manual(values = col_theme) +
  scale_fill_manual(values = col_theme) +
  theme_bw()
