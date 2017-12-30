library(tidyverse)  
library(ggrepel)
col_theme <- c("#222430", "#136692", "#573253", "#883F9F", "#B2E4AB", "#B19EF8", "#69C4EC", "#35166E", "#6E3516", "#4F6E16", 
               "#136692", "#573632", "#325736", "#325357", "#9F3F56", "#569F3F", "#3F9F88", "#ABE4DD", "#DDABE4", "#E4ABB2", 
               "#F89EE5", "#E5F89E", "#9EF8B1", "#9169EC", "#EC9169", "#C4EC69", "#0390CA", "#3D03CA", "#CA3D03", "#90CA03")  # Color theme

# Download and prepare the data ----
url <- "http://vincentarelbundock.github.io/Rdatasets/csv/ggplot2/movies.csv"
df_movie <- read.table(file = url, header = TRUE, sep = ",")

df_movie %<>%
  select(-X, -c(r1:r10), -mpaa, -budget) %>% 
  mutate(Action = factor(Action), Animation = factor(Animation), Comedy = factor(Comedy), 
         Drama = factor(Drama), Documentary = factor(Documentary), Romance = factor(Romance),
         Short = factor(Short))

#df_movie_selection <- df_movie %>% filter(rating > 7 & votes > 500)
df_movie_selection <- df_movie[sample(nrow(df_movie), 2000),]


# Gower distance ----
library(cluster)
dist_gower <- daisy(df_movie_selection[, -1],
                    metric = "gower",
                    type = list(logratio = 3))

mat_gower <- as.matrix(dist_gower)


# Non-metric MDS ----
library(vegan)

# Restore the tidyverse 'select' function in preference to the MASS version
select <- dplyr::select 

mds_nonmetric <- monoMDS(dist_gower)

# Visualize MDS solution ----
## Prep data
df_mds_nonmetric <- cbind(df_movie_selection, 
                       x = mds_nonmetric$points[,1], 
                       y = mds_nonmetric$points[,2])

df_mds_nonmetric %<>% 
  mutate(genre = paste0(ifelse(Animation == 1, "Animation, ", ""),
                        ifelse(Comedy == 1, "Comedy, ", ""), 
                        ifelse(Drama == 1, "Drama, ", ""),
                        ifelse(Documentary == 1, "Documentary, ", ""),
                        ifelse(Romance == 1, "Romance, ", ""),
                        ifelse(Short == 1, "Short, ", ""))) %>% 
  mutate(genre = substr(genre, 1, nchar(genre) - 2)) %>% 
  mutate(genre = factor(genre)) %>% 
  group_by(genre) %>% 
  mutate(qty_genre = n(),
         med_year = median(year),
         med_rating = median(rating)) %>% 
  filter(qty_genre >= 10)

df_genres <- df_mds_nonmetric %>%
  group_by(genre, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  summarise(x = median(x), 
            y = median(y))

# Plot data
p_non_metric <- ggplot(df_mds_nonmetric, aes(x, y)) +
  geom_label_repel(data = df_genres, 
                   aes(x, y, label = genre, col = genre)) + 
  geom_jitter(aes(col = genre), alpha = .2) +
  guides(alpha = FALSE, col = FALSE) +
  labs(title = "Non-metric MDS") +
  theme_bw()

p_non_metric

tbl_mds_set <- df_mds_nonmetric %>% 
  filter(Drama == 1 ) 

df_genres_set <- df_genres %>% 
  filter(Drama == 1 ) 

p_non_metric <- ggplot(tbl_mds_set, aes(x, y)) +
  geom_label_repel(data = df_genres_set, aes(x, y, label = genre)) +
  geom_jitter(aes(col = rating-med_rating), alpha = .6) +
  scale_color_gradient2(low = "red", mid = "white",
                        high = "blue") +
  guides(alpha = FALSE) +
  labs(title = "Non-metric MDS") +
  theme_bw()

p_non_metric

# Metric MDS ----
mds_metric <- cmdscale(dist_gower)

# Visualize MDS solution ----
## Prep data
df_mds_metric <- cbind(df_movie_selection, 
                       x = mds_metric[,1], 
                       y = mds_metric[,2])

df_mds_metric %<>% 
  mutate(genre = paste0(ifelse(Animation == 1, "Animation, ", ""),
                        ifelse(Comedy == 1, "Comedy, ", ""), 
                        ifelse(Drama == 1, "Drama, ", ""),
                        ifelse(Documentary == 1, "Documentary, ", ""),
                        ifelse(Romance == 1, "Romance, ", ""),
                        ifelse(Short == 1, "Short, ", ""))) %>% 
  mutate(genre = substr(genre, 1, nchar(genre) - 2)) %>% 
  mutate(genre = factor(genre)) %>% 
  group_by(genre) %>% 
  mutate(qty_genre = n(),
         med_year = median(year),
         med_rating = median(rating)) %>% 
  filter(qty_genre >= 10)

df_genre_metric <- df_mds_metric %>%
  group_by(genre, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  summarise(x = median(x), 
            y = median(y))

# Plot data
p_metric <- ggplot(df_mds_metric, aes(x, y)) +
  geom_label_repel(data = df_genre_metric, 
                   aes(x, y, label = genre, col = genre)) + 
  geom_jitter(aes(col = genre), alpha = .2) +
  labs(title = "Metric MDS") +
  guides(alpha = FALSE, col = FALSE) +
  theme_bw()

p_metric

# Combine plots ----
library(gridExtra)

grid.arrange(p_non_metric, p_metric, ncol = 2)
