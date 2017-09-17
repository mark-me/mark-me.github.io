---
layout: page
title: Replacing missing data with best guesses
comments: true
permalink: /impute-missings/
---

* TOC
{:toc}

# Recoding, discarding or guessing

When thinking about tackling missing data, I first inspect what variables are affected by them, and think what the caused these missing values. They could be the result of: 
1. being a value in itself,
2. a systematic failure in the storage or
3. a random registration errors.

Each of these posibilities needs its own solution. In the first case you recode the missings to a corresponding 'not there' value. In the second case of systemic failure, I would consider discarding the observations. In case of the third option, random errors, I'd follow the steps layed out in this tutorial. Several missing value guessing methods will be used.

# Framework

The nice thing about using different guessinng methods to complete cases, is you can choose which one performs best. To asses which method performs best, we'll be using each method to predict some values that are not actually missing and match those predictions with the actual data. We'll be using three sets of data throughout this procedure:

1. Original data-set : this is the dataset which needs to have missing values replaced by their best guess.
2. Verification data-set : in this set extra missing values are introduced to see how the methods compare.
2. Imputed data-set: this will contain all original data with best guesses replacing the missing values.

# The original data-set

The demo data set for this I'll be using the **[iris](https://en.wikipedia.org/wiki/Iris_flower_data_set)** data set. Which, unlike a lot of real-world examples is very complete. First a copy is created for reference puproses:
```r
tbl_orig <- iris
```

# The verification data-set

And now for something I won't normally do, but will now do for recrateal purposes, I'll mutilate some data creating some missing values in the iris data set to create a verification set. To I'll be using the _prodNA_ function from the **[missForest](https://www.rdocumentation.org/packages/missForest/versions/1.4)** package. So the librart needs to be loaded first:
```r
library(missForest)
```
Now I'll randomly replace data with NA's in the iris data in 10% of the cases, not being picky about which variable the NA is replaced in:
```r
tbl_verif <- prodNA(iris, noNA = 0.1)
```

# Visualizing the mess

To visualize how much of a mess the data is in terms of missing values I've created a function _plot_missing_values_. The function should be applicable to any data-frame. The output of the function applied to the mutilated _tbl_iris_miss_ data frame looks like this:

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/impute-missings/plot-missing-per-variable.png" target="_blank">
<img src="/_pages/tutorials/impute-missings/plot-missing-per-variable.png" alt="" width="718" height="350" align="center"/>
<br>
<i class='fa fa-search-plus '></i> Zoom</a
{: refdef}

The graph on the left shows the percentage and number of values that are missing per variable. The plot on the right shows how the observations are affected. 


that stiches together two ggplots by using the _ggarrange_ function of the **[ggpubr](http://www.sthda.com/english/rpkgs/ggpubr/)** library
```r
plot_missing_values <- function(df) {
  
  df_missing_by_var <- df %>% 
    gather(key = variable, value) %>% 
    group_by(variable) %>% 
    summarise(qty_missing = sum(is.na(value)),
              qty_total = n(),
              perc_missing = sum(is.na(value)/n()))
  
  p_miss_vars <- ggplot(df_missing_by_var) +
    geom_col(aes(x = variable, y = perc_missing), fill = "#541a3b") +
    geom_text(aes(x = variable, 
                  y = perc_missing, 
                  label = qty_missing),
              col = "white",
              hjust = 1
    ) +
    guides(fill = FALSE, col = FALSE, size = FALSE) +
    labs(list(title = "Missing values per variable", 
              x = "Variable", 
              y = "% Missing")) +
    scale_y_continuous(labels =  percent) +
    coord_flip() + 
    theme_minimal()

  rm(df_missing_by_var)
  
  tbl_miss_pattern <- df %>% 
    mutate_all(funs(is.na))%>%
    group_by_all() %>% 
    summarise(qty = n()) %>% 
    arrange(desc(qty)) %>% 
    ungroup() %>% 
    mutate(id = row_number()) %>% 
    gather(key = variable, is_missing, -id, -qty)
  
  p_miss_pattern <- ggplot(tbl_miss_pattern) +
    geom_raster(aes(x = variable, y = reorder(id, qty), fill = is_missing)) +
    geom_text(aes(y = reorder(id, qty), label = as.character(qty)), x = 1, col = "white") +
    scale_fill_manual(values = c("#541a3b", "#bf81bf")) +
    theme_minimal() + 
    theme(axis.text.x = element_text(angle = 270, hjust = 0, vjust = 0),
          axis.text.y = element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    guides(fill = FALSE) + 
    labs(list(title = "Missing value patterns", y = "Cases", x = "", fill = "Missing"))
  
  rm(tbl_miss_pattern)
  
  ggarrange(p_miss_vars, p_miss_pattern)
}
```

Then we'll see how many cases are affected and how:
```r
mice_plot <- aggr(tbl_iris_miss, col = c("navyblue", "yellow"),
                  numbers = TRUE, sortVars = TRUE,
                  labels = names(tbl_iris_miss), cex.axis = .7,
                  gap = 3, ylab = c("Missing data", "Pattern"))
```

<a href="/_pages/tutorials/impute-missings/VIM-plot.png" target="_blank">
{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/impute-missings/VIM-plot.png" alt="" width="442" height="400" align="center"/>
<br>
{: refdef}
<i class='fa fa-search-plus '></i> Zoom</a>


## Missing value patterns
```
md.pattern(tbl_verif)
```
The output will look something like this:

|  |Petal.Length|Species|Sepal.Width|Sepal.Length|Petal.Width|
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
|88|1|1|1|1|1|0|
|10|1|1|1|0|1|1|
|10|1|1|0|1|1|1|
| 7|0|1|1|1|1|1|
|14|1|1|1|1|0|1|
|...|...|...|...|...|...|...|
|  |12|13|15|16|19|75|

Interpreting

# Solutions

## Means, medians and other 'simple' replacements

Loading the required **[Hmisc](https://www.rdocumentation.org/packages/Hmisc)** library:
```r
library(Hmisc)
```
Putting means:
```r
tbl_iris_miss$imputed_sepal_length <- with(tbl_iris_miss, impute(Sepal.Length, mean))
```


## kNN

Fir this we'll use the **[VIM](https://www.rdocumentation.org/packages/VIM/versions/4.7.0/topics/VIM-package)** library we used before to inpect the extent of the missing values mess. If you didn't load the library, we'll do it now.
```r
tbl_imp_knn <- kNN(tbl_verif)
tbl_imp_knn %<>%
  select(names(tbl_verif))
tbl_imp_knn$method = "kNN"
```

Then we apply the _kNN_ function for the whole data frame, end put the set, the original set included, replaced NA's in the data frame _tbl_iris_imp_: 
```r
tbl_iris_imp <- kNN(tbl_iris_miss)
```

## Decision tree

**[missForest](https://www.rdocumentation.org/packages/missForest/versions/1.4)**
```r
library(missForest)
```

```r
forest <- missForest(tbl_verif)
tbl_imp_forest <- forest$ximp
tbl_imp_forest$method = "missForest"
```

## HMisc approach

Imputation that is based on [bootstrapping](http://thestatsgeek.com/2013/07/02/the-miracle-of-the-bootstrap/) and/or predictive mean matching ([pmm](https://statisticalhorizons.com/predictive-mean-matching)) can be done by using the _aregImpute_ function from the **[Hmisc](https://www.rdocumentation.org/packages/Hmisc)** library. If not done before the library is loaded like this:
```r
library(Hmisc)
```
In bootstrapping, different bootstrap resamples are used for each of multiple imputations. Then, a flexible additive model (non parametric regression method) is fitted on samples taken with replacements from original data and missing values (acts as dependent variable) are predicted using non-missing values (independent variable).

Then, it uses predictive mean matching (default) to impute missing values. Predictive mean matching works well for continuous and categorical (binary & multi-level) without the need for computing residuals and maximum likelihood fit.
```r
impute_areg <- aregImpute(~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width +
                           Species, data = tbl_verif, n.impute = 5)
```

```r
tbl_imp_areg <- impute.transcan(impute_areg,
                                imputation = 5,
                                data = tbl_verif,
                                list.out = TRUE,
                                pr = FALSE,
                                check = FALSE)
```
Extracting the imputations
```r
tbl_imp_areg <- data.frame(matrix(unlist(tbl_imp_areg), nrow = nrow(tbl_orig)))
names(tbl_imp_areg) <- names(tbl_orig)
tbl_imp_areg %<>%
  mutate(method = "impute_areg") %>% 
  mutate(Species = factor(levels(tbl_orig$Species)[Species]))
```

# Evaluating methods

```r
tbl_orig %<>% mutate(method = "Original")
tbl_verif %<>% mutate(method = "Verification")
tbl_imputations <- rbind(tbl_orig,
                         tbl_verif,
                         tbl_imp_knn, 
                         tbl_imp_forest,
                         tbl_imp_areg)
```

## Factor variables

```r
tbl_imp_factor <- tbl_imputations %>% 
  select(method, which(sapply(.,is.factor))) %>% 
  cbind(., id= rep(1:nrow(tbl_orig), 5)) %>% 
  gather(key = variable, value, -id, -method)
```

```r
tbl_imp_factor_orig <- tbl_imp_factor %>% 
  filter(method == "Original") %>% 
  select(-method) %>% 
  rename(value_orig = value)
```

```r
tbl_imp_factor_verif <- tbl_imp_factor %>% 
  filter(method == "Verification") %>% 
  select(-method) %>% 
  rename(value_verif = value)
```

```r
tbl_imp_factor %<>%
  filter(method %nin% c("Original", "Verification")) %>%
  rename(value_imp = value) %>% 
  inner_join(tbl_imp_factor_orig, by = c("id", "variable")) %>%
  inner_join(tbl_imp_factor_verif, by = c("id", "variable"))
```

## Numerical variables

```r
tbl_imp_numeric <- tbl_imputations %>% 
  select(method, which(sapply(.,is.numeric))) %>% 
  cbind(., id= rep(1:nrow(tbl_orig), 5))%>% 
  gather(key = variable, value, -id, -method)
```

```r
tbl_imp_num_orig <- tbl_imp_numeric %>% 
  filter(method == "Original") %>% 
  select(-method) %>% 
  rename(value_orig = value)
```

```r
tbl_imp_num_verif <- tbl_imp_numeric %>% 
  filter(method == "Verification") %>% 
  select(-method) %>% 
  rename(value_verif = value)
```

```r
tbl_imp_numeric %<>%
  filter(method %nin% c("Original", "Verification")) %>% 
  rename(value_imp = value) %>% 
  inner_join(tbl_imp_num_orig, by = c("id", "variable")) %>% 
  inner_join(tbl_imp_num_verif, by = c("id", "variable"))
```
```r
tbl_imp_numeric %>% 
  filter(is.na(value_verif) & !is.na(value_orig)) %>% 
  ggplot(aes(x = value_orig, y = value_imp, col = method)) +
    geom_abline(intercept = 0, slope = 1) +
    geom_point() +
    facet_wrap(~variable, ncol = 2, scales = "free")
```

### RMSE
```r
tbl_imp_numeric %>% 
  mutate(error_sq = (value_imp - value_orig) ^ 2)%>% 
  group_by(method, variable) %>% 
  summarise(rmse = sqrt(sum(error_sq))/n()) %>% 
  ggplot(aes(x = variable, y = rmse, fill = method)) +
    geom_col(position = "dodge")
```

### Violin plots
```r
tbl_imp_numeric %>% 
  mutate(perc_error = (value_imp - value_orig)/value_orig) %>% 
  ggplot(aes(x = method, y = perc_error, col = method, fill = method)) +
    geom_jitter(alpha = 0.4) +
    geom_violin(alpha = 0.4) +
    scale_y_continuous(labels = percent) +
    facet_wrap(~variable, ncol = 2, scales = "free")
```
