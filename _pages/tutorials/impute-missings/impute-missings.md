---
layout: page
title: Replacing missing data with best guesses
comments: true
permalink: /impute-missings/
---

* TOC
{:toc}

# Mutilated data
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

# Visualize the mess

Now to see the extent to which the missing data is missing I can use a plot function, _aggr_, from the **[VIM](https://www.rdocumentation.org/packages/VIM/versions/4.7.0/topics/VIM-package)** library. So first we'll load that library.
```r
tbl_iris_imp <- kNN(tbl_iris_miss)
```

First we'll take a look at the number of cases per variable:
```r
tbl_iris_miss %>% 
  gather(key = variable, value) %>% 
  filter(is.na(value)) %>% 
  ggplot() +
    geom_bar(aes(x = variable), fill = "#3E0425") +
    guides(fill = FALSE) +
    labs(list(title = "MIssing values per variable")) +
    theme_minimal()
```
{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/impute-missings/plot-missing-per-variable.png" alt="" width="443" height="450" align="center"/>
<br>
{: refdef}

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

Loading the required **Hmisc** library:
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
