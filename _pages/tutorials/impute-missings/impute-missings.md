---
layout: page
title: Replacing missing data with best guesses
comments: true
permalink: /impute-missings/
---

# Creating a data set

The demo data set for this I'll be using the **iris** data set. First a copy is created for reference puproses:
```r
tbl_iris_orig <- iris
```
Not something you'd normally do, but for recrateal purposes I'll introduce some missing values in the iris data set. To do this I'll use _prodNA_ function from the **missForest** package. So that needs to be loaded first:
```r
library(missForest)
```
The create random NA data in the data set in 10% of the cases:
```r
tbl_iris_miss <- prodNA(iris, noNA = 0.1)
```

# Visualize the mess

```r
# Visual missing value patterns ----
library(VIM)
mice_plot <- aggr(tbl_iris_miss, col=c('navyblue','yellow'),
                  numbers=TRUE, sortVars=TRUE,
                  labels=names(tbl_iris_miss), cex.axis=.7,
                  gap=3, ylab=c("Missing data","Pattern"))

# Missing value patterns
md.pattern(tbl_iris_miss)
```

## Methods

## kNN

**[VIM](https://www.rdocumentation.org/packages/VIM/versions/4.7.0/topics/VIM-package)** library
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
