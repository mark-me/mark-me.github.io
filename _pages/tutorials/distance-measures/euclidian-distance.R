library(tidyverse)  
library(ggrepel)
col_theme <- c("#222430", "#136692", "#573253", "#883F9F", "#B2E4AB", "#B19EF8", "#69C4EC", "#35166E", "#6E3516", "#4F6E16", 
               "#136692", "#573632", "#325736", "#325357", "#9F3F56", "#569F3F", "#3F9F88", "#ABE4DD", "#DDABE4", "#E4ABB2", 
               "#F89EE5", "#E5F89E", "#9EF8B1", "#9169EC", "#EC9169", "#C4EC69", "#0390CA", "#3D03CA", "#CA3D03", "#90CA03")  # Color theme

glimpse(USArrests)

# Scaling and centering ----
scaled_USArrests <- scale(USArrests)

# Creating a distance object ----
dist_USArrests <- dist(scaled_USArrests, method = "euclidian")

# Convert distance object to matrix ----
mat_USArrests <- as.matrix(dist_USArrests)

# Create a MDS solution ----
mds_USArrests <- cmdscale(mat_USArrests, eig = TRUE, k = 2)  # Perform the actual MDS

# Create a data-frame for the MDS solution ----
df_mds_USArrests <- data.frame(city = row.names(USArrests),   
                               scaled_USArrests, 
                               x = mds_USArrests$points[,1], 
                               y = mds_USArrests$points[,2])

# Rotating all variables, so we can facet a plot
df_mds_USArrests %<>% 
  gather(key = "variable", value = "values", -city, -x, -y) 

# The plot with MDS solution, projecting variable values within the similarity space
ggplot(df_mds_USArrests, aes(x, y)) +
  geom_jitter(aes(col = values, alpha = values)) +
  geom_label_repel(aes(label = city, fill = values, alpha = values), col = col_theme[1]) +
  scale_color_continuous(low = col_theme[2], high = col_theme[3]) +
  scale_fill_continuous(low = col_theme[2], high = col_theme[3]) +
  facet_wrap(~variable) +
  guides(alpha = FALSE) +
  theme_bw()
