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
