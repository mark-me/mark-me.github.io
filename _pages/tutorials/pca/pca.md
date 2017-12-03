---
layout: page
title: Principal Component Analysis
comments: true
permalink: /pca/
published: true
---

PCA input data: percentage of adherents religions
```r
pca_input_data <- df_country_by_religion[,3:16]
```
Plot comparison of all variables
```r
plot(pca_input_data, col = col_theme[2]) 
```
Perform PCA
```r
fit_pca <- princomp(pca_input_data)
```
# Choose the number of Principal Components
```r
df_pca_var <- data.frame(pca = factor(names(fit_pca$sdev), levels = names(fit_pca$sdev)), 
                         var = (fit_pca$sdev)^2) 
```

```r
ggplot(df_pca_var, aes(x = pca, y = var)) +
  geom_col() +
  coord_flip() +
  labs(x = "PCs", y = "Variance")
```

