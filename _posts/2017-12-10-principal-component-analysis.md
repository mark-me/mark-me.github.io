---
layout: post
title: Principal Component Analysis
categories: r tutorial pca
author: Mark
date: 2017-12-10 23:00:00 +0100
tags: 
  - R
  - principal-component-analysis
  - pca
published: true
---


<img src="/_pages/tutorials/pca/pca-explained-3.png" alt="PC2" width="537" height="220" align="center"/><br>

Principal Component Analysis (PCA) is a method for reducing a data-set with a high number of variables to a smaller set of new variables, 'juicing' the most of the same information out of the whole set of variables. In the data science realm it is mostly used to achieve one or more of the following goals:

* Reducing the number of variables in a dataset reduces the number of degrees of freedom of a statistical model, which in turn reduces the risk of overfitting the model.
* Machine learning algorithms perform significantly faster when less variables are included.
* It can simplify the interpretation of data, by showing which variables play the biggest role in describing the data set.

In this tutorial I'll explain the concept behind Principal Component Analysis, and with an example I'll show you how to perform a PCA, how to choose the principal components and how to interpret them.

You can download the script [here](https://gist.githubusercontent.com/mark-me/7333f0e6988b5f4f1cbd17a18fc45259/raw/d7d009d6e4b576808dc68f060de1b5a79b2a4caa/country-religions-pca.R)
