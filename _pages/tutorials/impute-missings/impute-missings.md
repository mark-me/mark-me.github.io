---
layout: page
title: Replacing missing data with best guesses
comments: true
permalink: /impute-missings/
---

* TOC
{:toc}

# Guessing or discarding

Assumptions: data missing because of random registration errors, not systematic.

# Framework

 Complete cases (training & testing), incomplete cases (application set). Create testing by random replacing.

# Let's mutilate some data

The demo data set for this I'll be using the **[iris](https://en.wikipedia.org/wiki/Iris_flower_data_set)** data set. Which, unlike a lot of real-world examples is very complete. First a copy is created for reference puproses:
```r
tbl_iris_orig <- iris
```
And now for something I won't normally do but will now do, for recrateal purposes, creating some missing values in the iris data set. To I'll be using the _prodNA_ function from the **[missForest](https://www.rdocumentation.org/packages/missForest/versions/1.4)** package. So the librart needs to be loaded first:
```r
library(missForest)
```
Now I'll randomly replace data with NA's in the iris data in 10% of the cases, not being picky about which variable the NA is replaced in:
```r
tbl_iris_miss <- prodNA(iris, noNA = 0.1)
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
{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/impute-missings/VIM-plot.png" target="_blank">
<img src="/_pages/tutorials/impute-missings/VIM-plot.png" alt="" width="442" height="400" align="center"/>
<br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}

## Missing value patterns
```
md.pattern(tbl_iris_miss)
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

# Reviewing solutions

```r
tbl_comparison <- data_frame(orig = tbl_iris_orig$Species,
                             miss = tbl_iris_miss$Species,
                             imp = tbl_iris_imp$Species)
```

```r
tbl_comparison <- tbl_comparison[!complete.cases(tbl_comparison), ]
ggplot(tbl_comparison) +
  geom_jitter(aes(x = orig, y = imp)) +
  geom_abline(slope = 1, intercept = 0)
```

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
tbl_iris_imp <- kNN(tbl_iris_miss)
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
iris.imp <- missForest(tbl_iris_miss)
tbl_iris_imp <- iris.imp$ximp
```

## HMisc approach

Imputation that is based on [bootstrapping](http://thestatsgeek.com/2013/07/02/the-miracle-of-the-bootstrap/) and/or predictive mean matching ([pmm](https://statisticalhorizons.com/predictive-mean-matching)) can be done by using the _aregImpute_ function from the **[Hmisc](https://www.rdocumentation.org/packages/Hmisc)** library. If not done before the library is loaded like this:
```r
library(Hmisc)
```
In bootstrapping, different bootstrap resamples are used for each of multiple imputations. Then, a flexible additive model (non parametric regression method) is fitted on samples taken with replacements from original data and missing values (acts as dependent variable) are predicted using non-missing values (independent variable).

Then, it uses predictive mean matching (default) to impute missing values. Predictive mean matching works well for continuous and categorical (binary & multi-level) without the need for computing residuals and maximum likelihood fit.
```r
impute_arg <- aregImpute(~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width +
                           Species, data = tbl_iris_miss, n.impute = 5)
```

```r
impute_arg
```

```
Multiple Imputation using Bootstrap and PMM

aregImpute(formula = ~Sepal.Length + Sepal.Width + Petal.Length + 
    Petal.Width + Species, data = tbl_iris_miss, n.impute = 5)

n: 150 	p: 5 	Imputations: 5  	nk: 3 

Number of NAs:
Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
          17           14           12           18           14 

             type d.f.
Sepal.Length    s    2
Sepal.Width     s    2
Petal.Length    s    2
Petal.Width     s    2
Species         c    2

Transformation of Target Variables Forced to be Linear

R-squares for Predicting Non-Missing Values for Each Variable
Using Last Imputations of Predictors
Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
       0.877        0.721        0.978        0.967        0.992 
```

```r
tbl_iris_hmisc <- impute.transcan(impute_arg,
                                  imputation = 5,
                                  data = tbl_iris_miss,
                                  list.out = TRUE,
                                  pr = FALSE,
                                  check = FALSE)

tbl_iris_hmisc <- data.frame(matrix(unlist(tbl_iris_hmisc), nrow = nrow(tbl_iris_orig)))
names(tbl_iris_hmisc) <- names(tbl_iris_orig)
```

