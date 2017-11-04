---
layout: page
title: Clustering and MDS
comments: true
permalink: /clustering-mds/
published: true
---

Cluster analysis or clustering is the task of grouping a set of objects in such a way that objects in the same group (called a cluster) are more similar (in some sense or another) to each other than to those in other groups (clusters) (source: [Wikipedia](https://en.wikipedia.org/wiki/Cluster_analysis)). Cluster is usually used to make sense of large samples of observations by grouping them on similar behaviour. For example: we have the idea that we can group customers by the kinds of articles they buy, but the large population of customers does not let us readily see how these groups are formed, or even if they are there. This tutorial shows you how you can do a cluster analysis for your data set, evaluate it and display it's results 

# The road to cluster analysis

<img src="/_pages/tutorials/clustering-mds/yellow-brick-road.jpg" width="294" height="180" align="right"/> 

Clustering is about similarity. So a first step in cluster analysis is **calculating similarity** between the observations in your data set. We'll explore this in the section [Determining similarity](/clustering-mds/#determining-similarity). Although I'm talking about similarity, we'll be actually doing the inverse of calculating the inverse of similarity: dissimilarity or distance. The more similar observations are, the smaller the distance between them and the more dissimilar they are, the greater the distance between them. The result of calculating distance is often expressed in a distance matrix. A distance matrix looks similar to a correlation matrix: the columns and rows denominate the same observations, and the number in a crossing states how dissimilar they are. The distance matrix will be the input for a clustering algorithm, but also for the visualisation of the set. 

Before we start the clustering itself we'll be **visualising similarity**. With the distance matrix itself is hard to get an overall impression how closely observations resemble eachother. To get a more intuitive idea, we will convert these distances to create a scatterplot. Since distances are expressed as distances between observations we could take each observation as an axis in our plot, but this will quickly result in more then two or three dimensions and at that moment my imagination falls short on how I should interpret this. Luckily there is an framework called MultiDimensional Scaling (MDS) which reduces the number of dimensions to two, which my imagination can handle. How this is done and how the resulting similarity plot is created is explained in the section [Applying multidimensional scaling](/clustering-mds/#applying-multidimensional-scaling).

The last step before the actual clustering is **assessing clusterability** or our data. This is explained in the section [Determining clusterability](/clustering-mds/#determining-clusterability)


# Determining similarity

If we want to group observations by similarity, we need a measure(s) of their similarity; in the statistics field the reverse of similarity is used: distance measures. The distance measure used highly impacts the form of the clusters and the clustering method we can use. The choice of your distance metric is determined by the measurement levels of the variables in your data set. (If you need a refresh on measurement levels, you can find a quick explanation [here](/statistical-tests/#levels-of-measurement).) There are many distance metrics, but the four I found most useful are discussed here.

In relation to similarity correltion coefficients are often mentioned, which are similarity measures instead of distance measures. They can also be turned into distance measures by subtracting them from zero, but I'll skip a discussion about those here since most cases will be covered by those used here.

## Euclidian distance

The Euclidian distance is the distance measure we're all used to: the shortest distance between two points. This distance measure is mostly used for interval of ratio variables. Be careful using this measure, the distance can be highly impacted by outliers, throwing your clustering off. The distances are calculated by

```r
dist(x, mehod = "Euclidean")
```

## Manhattan distance

<img src="/_pages/tutorials/clustering-mds/manhattan.jpg" width="271" height="180" align="right"/> 

The Manhattan distance is called after the shortest distance a taxi can take through most of [Manhattan](http://becomeanewyorker.com/streets-and-avenues-a-history-of-the-grid-system/), the difference from the Euclidian distance: we have to drive around the buildings instead of straight through them. This distance measure is useful for ordinal and interval variables.

## Hamming distance

The Hamming distance the number of positions between two strings of equal length at which the corresponding symbols are different. This is useful for categorical variables.

## Jaccard distance

Jaccard distance is the inverse of the number of elements both observations share divided (compared to), all elements in both sets (think [Venn diagrams](https://en.wikipedia.org/wiki/Venn_diagram)). This is useful when comparing observartions with categorical variables. The Jaccard distance matrix can be created using the _vegdist_ function of the **[vegan](https://www.rdocumentation.org/packages/vegan)** library. 
```r
library(vegan)

df_cluster_methods <- read.table(con <- textConnection("Complete	Exclusive	Fuzzy	Hierarchical	Partitioned	Euclidian	Manhattan	Pearson	Spearman	Jaccard
cmeans	1	0	1	0	1	0	0	0	0	0
fanny	1	0	1	0	1	0	0	0	0	0
hclust	1	1	0	1	0	1	1	1	1	1
kmeans	1	1	0	0	1	1	0	0	0	0
pam	1	1	0	0	1	1	1	0	0	0"), header = TRUE, row.names = 1)
close(con)
df_cluster_methods <-  df_cluster_methods[1:5,]

dist_matrix <- vegdist(df_cluster_methods[, -1], method = "jaccard")
fit <- cmdscale(dist_matrix,eig=TRUE, k=2) # k is the number of dim
df_mds <- data.frame(x = fit$points[,1], y = fit$points[,2])
df_mds$names <- row.names(df_cluster_methods)

ggplot(df_mds,aes(x, y, col = names)) +
  geom_jitter() +
  geom_label_repel(aes(label = names)) +
  guides(col = FALSE) +
  scale_color_manual(values = col_theme)

fit <- hclust(dist_matrix, method="ward") 
plot(fit)
```


## Gower distance
Gower's General Similarity Coefficient one of the most popular measures of proximity for mixed data types. The explanation of it's workings is a bit more complex and beyond the scope of this tutorial. Calculating the 

# Applying multidimensional scaling

## MDS

<img src="/_pages/tutorials/clustering-mds/flat-earth.jpg" width="249" height="140" align="right"/> 

* Squeezing distances in n-dimensions in 2-dimensions
* Each time refitting points on two-dimensions 
* Trying to minimizing stress 
* Stress: Difference between original and squeezed distances
You can perform a classical MDS using the _cmdscale_ function.


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


# Means clustering



## Choosing k

The k-means clustering algorithm splits the data into a set of k clusters, where k must by us. Each cluster is represented by means of points belonging to the cluster, the so-called medioid. Although we have the final say what k must be, it is cannot be based on wish thinking. The optimal k is determined by similarity of objects: objects within a cluster should be as similar as possible, whereas objects from different clusters should be as dissimilar as possible.



The **[factoextra](http://www.sthda.com/english/rpkgs/factoextra/#cluster-analysis-and-factoextra)** library cotains a lot of goodies in respect to clustering, one of which is a function which helps us determine k visually by plotting the GAP statistic

```r

```


```r
kmeans(x, centers, iter.max = 10, nstart = 1)
```

# Median clustering

A 
*[skmeans](https://www.rdocumentation.org/packages/skmeans/versions/0.2-11)*
[median](https://rstudio-pubs-static.s3.amazonaws.com/75036_b3e83952e88e4c98ad4fffbee571260f.html)



# Mediod clustering

[PAM](http://www.sthda.com/english/wiki/partitioning-cluster-analysis-quick-start-guide-unsupervised-machine-learning#pam-partitioning-around-medoids)

# Jaccard clustering

[Jaccard clustering](http://www.win-vector.com/blog/2015/09/bootstrap-evaluation-of-clusters/) _clusterboot_ of the **[vegan](https://www.rdocumentation.org/packages/vegan)** library

