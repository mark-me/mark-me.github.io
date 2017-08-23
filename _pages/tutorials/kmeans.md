---
layout: post
title: k-Means Clustering
comments: true
permalink: /kmeans/
published: false
---

k-Means clustering is one of the techniques that make sense of large clouds of observations by grouping them. 

# Data preparation

When the data we choose to cluster 

# Determining clusterability

## Hopkins statistic


## 


# Choosing k

The k-means clustering algorithm splits the data into a set of k clusters, where k must by us. Each cluster is represented by means of points belonging to the cluster, the so-called medioid. Although we have the final say what k must be, it is cannot be based on wish thinking. The optimal k is determined by similarity of objects: objects within a cluster should be as similar as possible, whereas objects from different clusters should be as dissimilar as possible.



The **[factoextra](http://www.sthda.com/english/rpkgs/factoextra/#cluster-analysis-and-factoextra)** library cotains a lot of goodies in respect to clustering, one of which is a function which helps us determine k visually by plotting the GAP statistic

```r

```


```r
kmeans(x, centers, iter.max = 10, nstart = 1)
```
