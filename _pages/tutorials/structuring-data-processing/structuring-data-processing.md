---
layout: page
title: Structuring data processing
comments: true
permalink: /structuring-data-processing/
---

When I do larger projects I always encounter three problems:
1. My analysis script becomes cluttered with heaps and heaps of code. I prefer to keep the bulk of my data processing out of my R Markdown document, so my analysis isn't cluttered by code. 
2. Whenever a script gets larger and larger, it also becomes more and more difficult to track down bugs. 
3. Also I'd hate to do all data-processing again and again every day I restart my computer when I continue working on my project. It takes up a lot of time. I don't mind getting coffee while my computer works, but it becomes problematic when my computer is still crunching after I've finished my coffee. 

To address these problems this I made a framework which I'll explain in this tutorial

# Project scripts structure

To ensure I don't get one blob of code I make R script files that will do data loading and transforming for each source. This way I can easily locate where I should adjust code in case something is not how I wanted things to be. All the files for each data source is called from a central data-prep file, wherein I do all data transformations take place that are cross-source. This idea is depicted in the diagram below:

{:refdef: style="text-align: center;"}
<img src="/_pages/snippets-and-tips/script-structuring/data-prep.png" alt="Script structure" align="middle"/>
{: refdef}

# Data processing functions

In each data-prep file I don't do the data processing directly, instead I create a function containing all data processing. Why do I do this? I might not want to do all data-processing again and again every day I restart my computer, but instead load all pre-processed data. The skeleton of that function looks something like this:
```r
prep_datasource_A <- function(do_processing){

  if(process_data){
    
    # Load raw data
    # Transform raw data
    # Write processed file
    
  } else {
  
    # Load previously processed data
  
  }
}
```
As you can see the function takes a boolean _process_data_. The value of this parameter determines whether we process the data from scratch or whether we load pre-processed data.
