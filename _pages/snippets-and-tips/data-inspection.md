---
layout: page
title: Data inspection
permalink: /data-inspection/
---
## Cross tabs

To see cross-tabulations with frequencies you can use the statement below, do also all table entries can be found that didn't contain any value. 

```r
table(colum_values_rows, column_values_across, useNA = "ifany")
```

## Correlation matrices are boring

When making correlation matrices to inspect possible relations between variables, I often get scared by the table I get. Using the following pseudo code, you can plot the correlation matrix in a network graph that is less daunting to look at, using the **qgraph** library: 

```r
library(qgraph) # Loading the library 
library(SemiPar) # Library just used for the data 
data(milan.mort) # Making data available 
corr_matrix=cor(milan.mort) # Making a correlation matrix 
qgraph(corr_matrix, 
       shape="circle", 
       posCol="darkgreen", 
       negCol="darkred", 
       layout="spring", 
       vsize=10) # Creating the network graph 
```

Positive correlations are depicted as green lines, and negative are red, the width of lines show the strength of the relationship.

<img src="/_pages/snippets-and-tips/correlation-network.png" alt="Correlation network" align="center"/> 
