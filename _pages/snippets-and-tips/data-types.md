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

# Inspecting data structures

The _glimpse()_ function is a great alternative for the _str()_ function: is shows data-types in a compacter way, and the screen size is taken into consideration for the output.

# Column renaming

After importing files I usually rename the columns so they adhere to the in-script conventions, to prevent messy data joining and searching for column names forever. You can rename all column names at once by using:

```r
names(table) <- c("column_a", "column_b", "column_c", "column_d", "column_e")
```

Renaming a single column or select columns using the **dplyr** library:

```r
rename(mtcars, spam_mpg = mpg, cylinders = cyl)
```

# Re-ordering columns

You can reorder all columns by _select_ing them one by one, but by making use of the _everything()_ function you can put all columns, except the re-ordered in at once:

```r
mtcars %<>% select(cyl, disp, hp, everything())
```

# Selecting multiple columns at once

If you adhere to certain column naming conventions (like using the prefix _amt__ for currency columns), you can use certain functions to select multiple columns in one statement.

*   _starts_with():_ starts with a prefix
*   _ends_with():_ ends with a prefix
*   _contains():_ contains a literal string
*   _matches():_ matches a regular expression
*   _num_range():_ a numerical range like x01, x02, x03.
*   _one_of():_ variables in character vector.
*   _everything():_ all variables.

An example with the iris data-set (form the **tidyverse**) is:

```r
select(iris, starts_with("Petal"))
```
