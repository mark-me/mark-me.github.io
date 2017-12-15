---
layout: page
title: Multidimensional scaling
comments: true
permalink: /mds/
published: true
---

<img src="/_pages/tutorials/mds/Taylor-Swift-Cats.jpg" width="227" height="170" align="right"/> 
Whenever I'm in a explorative phase of my data modelling, very soon I'll have questions about the data that may sound familiar in it's vangueness:

* Can I find any groups in this list of people, by how much money they spent on drugstore items, minutes they've spent in greeneries department and the amount of time they spent in the gym?
* What smartphones are available in the market and how much are they alike in terms of specs and pricing? (Give me a data-set please!)
* How much do cats look alike in fluffyness of the tail, playfulness, hair color, eye color, number of legs.... I have a _lot_ of cats... OK!?!?!?
* I have no clue what I'm looking for, please give me a clue?

The similarity between these questions is mostly captured by the generic sentence: how similar are these cases in terms of _a_, _b_ _c_, _d_, _e_... well, you're getting the picture... right? What you're really looking for are variables that can make sense in a narrative about a set of data. Maybe you find, small pockets of observations that have special meanings. Maybe you can find variables that are group defining. These narratives can further by explored by clustering data or making predictions based on group defining variables. One of the tools I use to answer these types of questions is MultiDimensional Scaling (MDS).

MDS let's you visually inspect similarity in observations in an easy 2D scatterplot. The more alike observations are the closer their points are together, the more unlike they are the further they are apart. But, how do you get a 2D scatterplot for so many variables? MDS does this by "rearranging" the observations in an efficient manner, so as to arrive at a configuration that best approximates the alikeness of observations. 

# The concept

<img src="/_pages/tutorials/mds/flat-earth.jpg" width="249" height="140" align="right"/> 
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
