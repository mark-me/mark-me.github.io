---
layout: page
title: Multidimensional scaling
comments: true
permalink: /mds/
published: true
---

<img src="/_pages/tutorials/mds/flat-earth.jpg" width="249" height="140" align="right"/> 

Multidimensional scaling (MDS) is one of the unsupervised dimension reduction algorithms, like [PCA](/pca/) or [t-SNE](/t-sne/). The goal I use MDS for mostly is visually inspecting observed similarities or dissimilarities (distances) between the observations based of a set of variables in a data set. Inspecting the similarity based on more than two variables at once quickly becomes problematic, because you quickly run out of options visualising observations in a meaningful way. This is where MDS comes in handy: it 'boils' down the similarity in a multidimensional space to an easier to comprehend two dimensional space. What makes MDS great is that it can work with any kind of similarity matrix. Unlike t-SNE, which you could also use for this kind of inspection, MDS 'respects' original distances; causing as little disturbances as possible to real distance measures (like geographical distances). 
In this tutorial I'll explain the concept behind MDS, how you can apply it and how you could interpret its outcome.

# The concept

* Squeezing distances in n-dimensions in 2-dimensions
* Each time refitting points on two-dimensions 
* Trying to minimizing stress 
* Stress: Difference between original and squeezed distances

# Applying MDS

MDS takes in similarity matrices. (If you want to read up on that I've written a [tutorial about that subject](/distances/)
You can perform a classical MDS using the _cmdscale_ function.

```r
str(USArrests)
dist_USArrests <- dist(USArrests, method = "euclidian")
mds_USArrests <- cmdscale(dist_USArrests, eig = TRUE, k = 2)
```
