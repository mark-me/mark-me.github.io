---
layout: page
title: Meta-data manipulation
comments: true
permalink: /meta-data-manipulation/
---
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
