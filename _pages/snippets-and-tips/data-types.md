---
layout: page
title: Data types and structures
comments: true
permalink: /data-types/
---

* TOC
{:toc}

# Data structures

R uses several kinds of data structures:

*   _Variables_ - a variable contains a single value. The can contain a number (integer or double), characters or a logical value.
*   _Vectors_ - A vector is a list of contain only one data type.
*   _Lists_ - A list is a list (surprise, surprise) that can contain different data-types for each element. A list entry could also contain a vector, another list or even a table.
*   _Tables_ - A table is usually a combination of vectors, in which each vector functions as a column. R had different implementations of tables.
    *   The _data frame_ is the standard R table solution.
    *   _tbl_ is a more more user friendly implementation of a data frame from the **tibble** library, which is part of the **tidyverse** library
        *   A data frame can be converted to a table using the _as_data_frame(data_frame)_ function
    *   _data.table_ is most commonly used for very large data-sets, but even when using the BIS data of a country I did not have to use this.

# Factoring

Factoring data is used so that R understands you are using variable to make distinctions between groups of data, instead of it being a variable that is a name or identifier. Factors can be categorical variables, or ordinal variables.
When factoring a variable, R transforms the actual value to an internal value. It is especially important to realize this when treating a numeric value as a factored variable. After factoring a numeric variable, you cannot automatically assume that the mutation you make on that variable is the one you expect it to be. For example: when adding 1 to a factored numeric variable:
```r
mtcars %>%
  mutate(fac_gear = factor(gear, ordered = TRUE)) %>%
  mutate(gear_plus = gear + 1) %>%
  mutate(fac_gear_plus = as.numeric(fac_gear) + 1) %>%
  select(gear, gear_plus, fac_gear, fac_gear_plus)
```

**TODO**

By default the order of factors is determined by sorting the values, if you want to specify your own factor ordering you can define a factored variable like this:

```r
rating_pd <- factor(rating_pd, levels=c("AAA", "AA", "A", "BBB", "BB", "B", "CCC", "CC", "C", "D"), ordered=TRUE)
```

If the variable was already factored and the order is is not as it should be, the ordering can be adjusted as in the example:

```r
rating_pd = gdata::reorder.factor(rating_pd, new.order=c("AAA", "AA", "A", "BBB", "BB", "B", "CCC", "CC", "C", "D"))
```
<a name="dropping-factor-levels"></a>
## Dropping levels from factors

```r
drop.levels(tbl_revenue$sector)
```

