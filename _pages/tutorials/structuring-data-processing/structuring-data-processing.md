---
layout: page
title: Structuring data processing
comments: true
permalink: /structuring-data-processing/
---

I prefer to keep the bulk of my data processing out of my R Markdown document, so my analysis isn't cluttered by code. For this reason I make R script files for each source file, so I can easily locate where I should adjust what in case something is not how I wanted things to be. All the files for each data source is called from a central data-prep file, wherein I do all data transformations that are cross-source. This idea is depicted in the diagram below:

<img src="/_pages/snippets-and-tips/script-structuring/data-prep.png" alt="Navigation" align="center"/>

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
