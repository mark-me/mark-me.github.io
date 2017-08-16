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
3. what the location and base name of the output files are

```r
qty_files <- 20                 # The number of files you want to create
file_input <- "~/input.csv"     # The file you want to split
file_output_base <- "~/output"  # The base of the output filename
```

# Combining files
