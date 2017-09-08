---
layout: page
title: Replacing missing data with best guesses
comments: true
permalink: /impute-missings/
---

* TOC
{:toc}

# Creating a data set

The demo data set for this I'll be using the **iris** data set. First a copy is created for reference puproses:
```r
tbl_iris_orig <- iris
```
And now for something I don't normally do, but will now for recrateal purposes, introducing some missing values in the iris data set. To I'll be using the _prodNA_ function from the **missForest** package. So the librart needs to be loaded first:
```r
library(missForest)
```
The create random NA data in the data set in 10% of the cases:
```r
tbl_iris_miss <- prodNA(iris, noNA = 0.1)
```

# Visualize the mess

Now to see what the extent is the missing data is I can use a plot function, _aggr_, from the **[VIM](https://www.rdocumentation.org/packages/VIM/versions/4.7.0/topics/VIM-package)** library.
```r
library(VIM)
mice_plot <- aggr(tbl_iris_miss, col=c('navyblue','yellow'),
                  numbers=TRUE, sortVars=TRUE,
                  labels=names(tbl_iris_miss), cex.axis=.7,
                  gap=3, ylab=c("Missing data","Pattern"))
```
## Missing value patterns
```
md.pattern(tbl_iris_miss)
```

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

# Methods

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
