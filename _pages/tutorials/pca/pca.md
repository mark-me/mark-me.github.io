---
layout: page
title: Principal Component Analysis
comments: true
permalink: /pca/
published: true
---

<img src="/_pages/tutorials/pca/orange-juice.jpg" alt="Me" width="118" height="170" align="right"/>

Principal Component Analysis (PCA) is a method for reducing a data-set with a high number of variables to a smaller set of new variables, containing most of the same information. In the data science realm it is mostly used to achieve one or more of the following goals:

* Reducing the number of variables in a dataset reduces the number of degrees of freedom of a statistical model, which in turn reduces the risk of overfitting the model.
* Machine learning algorithms perform significantly faster when less variables are included.
* It can simplify the interpretation of data, by showing which variables play the biggest role in describing the data set.

# How it works

Imagine each variable as a dimension of a space.

{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/pca/pca-explained-1.png" alt="No PC" width="537" height="220" align="center"/><br>
{: refdef}

{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/pca/pca-explained-2.png" alt="PC 1" width="537" height="220" align="center"/><br>
{: refdef}

{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/pca/pca-explained-3.png" alt="PC2" width="537" height="220" align="center"/><br>
{: refdef}

{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/pca/pca-explained-4.png" alt="Rotated" width="537" height="220" align="center"/><br>
{: refdef}

# Our example: country religions

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
{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/pca/plot-pc-choice.png" alt="Variance PC" width="360" height="450" align="center"/><br>
{: refdef}

```r
no_pcs <- 4
```

# Interpreting principal components

Get loadings
```r
df_loadings <- data.frame(religion = row.names(fit_pca$loadings), fit_pca$loadings[, 1:no_pcs])
df_loadings %<>%
  gather(key = "pc", value = "loading", -religion)
```

```r
ggplot(df_loadings, aes(x = pc, y = religion, fill = loading, size = abs(loading))) +
  geom_point(shape = 21, col = alpha = 0.8) +
  scale_fill_gradientn(colors = c("red", "white", "blue")) +
  scale_size(range = c(3, 20)) + 
  guides(size = FALSE) +
  labs(x = "PCs", y = "Religion", fill = "Loading")
```

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/pca/plot-pc-loadings.png" target="_blank">
<img src="/_pages/tutorials/pca/plot-pc-loadings.png" alt="PC loadings" width="540" height="450" align="center"/><br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}
