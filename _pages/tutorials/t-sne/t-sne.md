---
layout: page
title: t-SNE
comments: true
permalink: /t-sne/
published: true
---
<img src="/_pages/tutorials/t-sne/buurman-buurman.jpg" alt="alice catterpillar" width="308" height="187" align="right"/>
t-Distributed Stochastic Neighbor Embedding, or t-SNE, like other data reduction techniques as [PCA](/pca/) and [MDS](/clustering-mds/), creates new smaller set of variables out of a large number of variables, retaining much of the information of the original data-set, but has a different approach to achieving this. What does this method add to these others? In my experience so far, it serves my gread to give me most predictability _and_ the serves my desparation in the exploratory 'get me a gist of the data' phase. In other words: it improves the goodies of PCA and does not too much damage to representing a dataset in comparison to MDS. 

So how does it work? Some of the workings of this approach are in the name of method. The method is al about _neighbouring_ points and _embedding_ these neighboring points in local neighborhoods fitting them to a lower dimensionsional space. The _t-Distributiony_ and _stochasticacy_ part need further explanation. At least: that's what my first thoughts were about these words... The result is clustering of the observations around


In this R tutorial I'll be using the Barnes-Hut implementation of t-SNE from the **[Rtsne](https://www.rdocumentation.org/packages/Rtsne)** library. The biggest reason for this is it's quick processing and little else, since I have little patience for my computer and too little time to read endlessly.
