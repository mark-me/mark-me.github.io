---
layout: post
title: Splitting and combining files
comments: true
permalink: /splitting-combining-files/
---

Since I'm lazy I generally prefer one file when importing CSV files, but some people prefer split files (for very good reasons). So there are times when I have to split a big file for somebody into smaller files, and there are times when somebody provides me with a set of files thaty I want to put in the same data frame. In this tutorial I'll walk you through both scenario's using ";"-delimited CSV files, but you can quite easily adjust it to any file type you'd want.

# Splitting files

In this scenario we're going to split the file in 20 separate files, but we could have wanted to split the file by x rows... I've chosen to this scenario because it's more easy to transform it to the 'by x rows' scenario than the other way around. 

First we're going to define:

1. how many output files we want, 
2. what the input file is and
3. what the location and base name of the output files are.

```r
qty_files <- 20                 # The number of files you want to create
file_input <- "~/input.csv"     # The file you want to split
file_output_base <- "~/output"  # The base of the output filename
```

Next we're going to read the input file and afterwards determine the number of rows we're going to split the file by. If you'd want to use the 'by x rows' scenario, you can replace the code following the ```qty recs <- ``` by the number of desired rows.

```r
df_input <- read.csv2(file_input)              # (";" seperated is assumed, use read.csv for "," separated)
qty_recs <- ceiling(nrow(df_input)/qty_files) 
```

Having the data loaded and knowing the number of records we want to put in each output file, we will create a list of data frames by splitting the input data frame.
```r
lst_outputs <- split(df_input, (as.numeric(rownames(df_input))-1) %/% qty_recs)
```
Let's 

# Combining files

To combine multiple CSV files in one data frame we're going to need those CSV file names first.  For this we're going to use the _list.files_ function together with a regular expression pattern. The pattern in the syntax below assumes the file name starts with 'input', is followed by some characters (.*) and ends with the extension .csv. 
```r 
filenames <- list.files(pattern="^input.*.csv$")
```

To combine multiple CSV files in one data frame we're going crazy and using a _do.call_ function and combine that with a _lapply_ function. 
```r 
tbl_revenue <- do.call("rbind", lapply(filenames, read.csv, header = TRUE, sep=";", dec=","))
```

That's all. Since the combining took only two statements I didn't bother to make a downloadable script.
