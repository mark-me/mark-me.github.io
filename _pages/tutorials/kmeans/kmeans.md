---
layout: post
title: Clustering methods
comments: true
permalink: /clustering-methods/
published: false
---

k-Means clustering is one of the techniques that make sense of large samples of observations by grouping them on similar behaviour. For example, we have the idea that we can group customers by the kinds of articles they buy. In cluster analysis terms this means we want to see if we can group customers by similarity. 

# Determining a distance measure

If we want to group customers by similarity, we need a measure(s) of their similarity; in the statistics field the reverse of similarity is used: distance measures. The distance measure used highly impacts the form of the clusters and the clustering method we can use. There are many distance metrics, but the four most important are:

* **Euclidian distance**: this is the distance we're all used to: the shortest distance between two points. Be careful using this measure, the distance can be highly impacted by outliers, throwing your clustering off.  
* **Manhattan distance**: this is called after the shortest distance a taxi can take through most of [Manhattan](http://becomeanewyorker.com/streets-and-avenues-a-history-of-the-grid-system/), the Euclidian distance, with the difference we have to drive around the buildings. This distance is not
* **Hamming distances**: the number of positions between two strings of equal length at which the corresponding symbols are different.
* **Jaccard distance**: the inverse of the number of elements both observations share divided (compared to), all elements in both sets.

In addition correltion coefficient can also be turned into distance measures by subtracting them from zero. 

# Choosing a clustering algorithm

So here's your decision tree:

* If your distance is squared _Euclidean_ distance, use k-means. This is because, since the k-means algorithm tries to minimize variance of Euclidian distances from the center of a cluster.
* If your distance is _Manhattan_ distance, use k-medians
* If you have _any other_ distance, use k-medoids

# Data preparation

## Scaling

The value of distance measures is intimately related to the scale on which measurements are made. 

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
