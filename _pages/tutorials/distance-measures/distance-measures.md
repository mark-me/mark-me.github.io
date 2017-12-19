---
layout: page
title: Distance/similarity measures
comments: true
permalink: /distance-measures/
published: true
---

<img src="/_pages/tutorials/distance-measures/measuring-similarity.jpg" width="192" height="180" align="right"/> 

Sooner or later during an analysis I'll start asking myself: how similar are these observations really? If we want see how similar observations are, we need a measure(s) of their similarity; in the statistics field the reverse of similarity is used: distance measures. There are different distance metric to choose from, and your choice is mostly determined by the measurement levels of the variables in your data set. (If you need a refresh on measurement levels, you can find a quick explanation [here](/statistical-tests/#levels-of-measurement).) There are many distance metrics, but the four I found most useful are discussed here.

This tutorial shows you how to pick a distance metric, how to apply it and how to visualize is using MDS. I won't go into MDS too deeply, but you can follow my tutorial on MDS [here](/mds/) if you want to.

# How to choose a distance measure

| Measurement level | Use case | Method |
| ----------------- | -------  | ------ | 
| Categorical |                         | Jaccard   |
| Categorical | Strings of equal lenght | Hamming   |
| Ordinal     |                         | Manhattan | 
| Mixed       |                         | Gower     |


# Euclidian distance

The Euclidian distance is the distance measure we're all used to: the shortest distance between two points. This distance measure is mostly used for interval of ratio variables. Be careful using this measure, the distance can be highly impacted by outliers, throwing your clustering off. The distances are calculated by the _dist_ function, passing the value "euclidian" to the _method_ argument: 
```r
str(USArrests)
dist_USArrests <- dist(USArrests, method = "euclidian")
```

# Manhattan distance

<img src="/_pages/tutorials/distance-measures/manhattan.jpg" width="271" height="180" align="right"/> 

The Manhattan distance is called after the shortest distance a taxi can take through most of [Manhattan](http://becomeanewyorker.com/streets-and-avenues-a-history-of-the-grid-system/), the difference from the Euclidian distance: we have to drive around the buildings instead of straight through them. This distance measure is useful for ordinal and interval variables.

For an example we cluster the countries by the religions of their people in 2010, for which I've used the data from the [Correlates of War Project](http://cow.dss.ucdavis.edu/data-sets/world-religion-data).
```r
dist_religion <- dist(df_country_by_religion[, -c(1:3)], method = "manhattan")
```

# Hamming distance

The Hamming distance the number of positions between two strings of equal length at which the corresponding symbols are different. This is useful for categorical variables.

# Jaccard distance

[<img src="/_pages/tutorials/distance-measures/jaccard.jpg" width="221" height="170" align="right"/>](https://jaccard.com/collections/meat-tenderizers)

[Jaccard distance](https://digfor.blogspot.nl/2013/03/fruity-shingles.html) is the inverse of the number of elements both observations share divided (compared to), all elements in both sets (think [Venn diagrams](https://en.wikipedia.org/wiki/Venn_diagram)). This is useful when comparing observartions with categorical variables. In this example I'll be using the UN votes dataset from the **unvotes** library. Here we'll be looking at similarity in voting on UN resolutions between countries. 

First we prepare the data by combining the votes with the roll calls, so we know which UN resolutions are being voted for. We'll just take the important votes. We'll just focus on the UN resolutions voted on between 2005 and 2015. Then the votes are recoded, so a yes becomes a 1, a no a 0 and all abstains will be missing values (i.e. NA). The variables are selected that matter to the analysis: the country, the UN resolution reference and the vote. The resolutions then get rotated to being variables, so for each country is a row where the vote for each UN resolution is a variable. 
```r
library(unvotes)
library(lubridate) # For the year extraction function

df_country_votes <- un_votes %>% 
  inner_join(un_roll_calls, by ="rcid") %>% 
  filter(importantvote == 1) %>% 
  mutate(year_vote = year(date)) %>%
  filter(year_vote >= 2005 & year_vote <= 2015) %>% 
  mutate(vote_no = ifelse(vote == "yes", 1, ifelse(vote == "no", 0, NA)))  %>%
  select(unres, country_code, vote_no) %>% 
  spread(unres, vote_no)
```
The Jaccard distance matrix can be created using the _vegdist_ function of the **[vegan](https://www.rdocumentation.org/packages/vegan)** library. 
```r
library(vegan)
dist_matrix <- vegdist(df_country_votes[, -c(1,2)], method = "jaccard", na.rm = TRUE)
```
A intuitive way of exploting the Jaccard distances, you can use the [MDS section](/clustering-mds/#mds). Knowing how much the countries are similar in voting behaviour is nice, but they give a confusing picture of 193 data points. I'd like to have a better overview of countries that are more similar than others. Here's where clustering comes to the resue! Jaccard distances can be used as input for [hierarchical](/clustering-mds/#hierarchical-clustering) and [PAM](/clustering-mds/#pam-for-jaccard-distances) clustering. If you want to follow through on this example on UN voting you can jump to the [PAM](/clustering-mds/#pam-for-jaccard-distances) section.

## Gower distance
Gower's General Similarity Coefficient one of the most popular measures of proximity for mixed data types. For each variable type, a particular distance metric that works well for that type is used and scaled to fall between 0 and 1. Then, a linear combination using user-specified weights (most simply an average) is calculated to create the final distance matrix. 
Calculating the 

_[daisy](https://www.rdocumentation.org/packages/cluster/topics/daisy)_ function from the **[cluster](https://www.rdocumentation.org/packages/cluster)** package.
