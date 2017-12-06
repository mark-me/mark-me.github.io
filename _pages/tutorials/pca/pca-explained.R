library(tidyverse)
col_theme <- c("#222430", "#136692", "#573253", "#883F9F", "#B2E4AB", "#B19EF8", "#69C4EC", "#35166E", "#6E3516", "#4F6E16", 
               "#136692", "#573632", "#325736", "#325357", "#9F3F56", "#569F3F", "#3F9F88", "#ABE4DD", "#DDABE4", "#E4ABB2", 
               "#F89EE5", "#E5F89E", "#9EF8B1", "#9169EC", "#EC9169", "#C4EC69", "#0390CA", "#3D03CA", "#CA3D03", "#90CA03")  # Color theme

tbl_iris_pca <- iris %>% dplyr::select(x = Petal.Length, y = Petal.Width) 

# Plot original
ggplot(tbl_iris_pca, aes(x, y)) +
  geom_jitter(col = col_theme[1], alpha = 0.4) +
  coord_fixed() +
  theme_bw()

# Fit PCA
fit_pca <- princomp(tbl_iris_pca)

# Get first PC line by lm
fit_lm <- lm(tbl_iris_pca$y ~ tbl_iris_pca$x)

# First PC 
slope_pca1 <- fit_lm$coefficients[2]
intercept_pca1 <- fit_lm$coefficients[1]
center_pca1 <- c(mean(tbl_iris_pca$x), mean(tbl_iris_pca$y))

# Plot with PC line 1
ggplot(tbl_iris_pca, aes(x, y)) +
  geom_jitter(col = col_theme[1], alpha = 0.4) +
  geom_abline(intercept = intercept_pca1, slope = slope_pca1, 
              col = col_theme[2], size = 1) +
  annotate(geom = "label", x = 6, y = 1.8, label = "PC1",
           fill = col_theme[2], col = "white") +
  coord_fixed() +
  theme_bw()

# Second PC by rotating PC1 by 90 degrees
slope_pca2 <- -1/fit_lm$coefficients[2]
intercept_pca2 <- center_pca1[2]-(center_pca1[1] * slope_pca2)

# Plot with PC line 1 & 2
ggplot(tbl_iris_pca, aes(x, y)) +
  geom_jitter(col = col_theme[1], alpha = 0.4) +
  geom_abline(intercept = intercept_pca1, slope = slope_pca1, 
              col = col_theme[2], size = 1) +
  annotate(geom = "label", x = 6, y = 1.8, label = "PC1",
           fill = col_theme[2], col = "white") +
  geom_abline(intercept = intercept_pca2, slope = slope_pca2, 
              col = col_theme[4], size = 1) +
  annotate(geom = "label", x = 3.7, y = 2.3, label = "PC2",
           fill = col_theme[4], col = "white") +
  coord_fixed() +
  theme_bw()

# Rotated
as.data.frame(-fit_pca$scores) %>% 
  ggplot(aes(Comp.1, Comp.2)) +
  geom_jitter(col = col_theme[1], alpha = 0.4) +
  coord_fixed() +
  labs(x = "PC1", y = "PC2") +
  theme_bw()