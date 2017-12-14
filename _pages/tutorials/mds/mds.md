---
layout: page
title: Multidimensional scaling
comments: true
permalink: /mds/
published: true
---

<img src="/_pages/tutorials/clustering-mds/flat-earth.jpg" width="249" height="140" align="right"/> 

* Squeezing distances in n-dimensions in 2-dimensions
* Each time refitting points on two-dimensions 
* Trying to minimizing stress 
* Stress: Difference between original and squeezed distances
You can perform a classical MDS using the _cmdscale_ function.

```r
str(USArrests)
dist_USArrests <- dist(USArrests, method = "euclidian")
mds_USArrests <- cmdscale(dist_USArrests, eig = TRUE, k = 2)
```
