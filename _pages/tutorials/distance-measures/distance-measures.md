---
layout: page
title: Distance/similarity measures
comments: true
permalink: /distance-measures/
published: true
---

* TOC
{:toc}

[<img src="/_pages/tutorials/distance-measures/measuring-similarity.jpg" width="192" height="180" align="right"/>](https://www.bol.com/nl/p/the-ban-of-the-bori/1001004002833612/) 

Sooner or later during an analysis I'll start asking myself: how similar are these observations really? If we want see how similar observations are, we need a measure(s) of their similarity; in the statistics field the reverse of similarity is used: distance measures. There are different distance metric to choose from, and your choice is mostly determined by the measurement levels of the variables in your data set. (If you need a refresh on measurement levels, you can find a quick explanation [here](/statistical-tests/#levels-of-measurement).) There are many distance metrics, but the four I found most useful are discussed here.

This tutorial shows you how to pick a distance metric, how to apply it and how to visualize is using MDS. I won't go into MDS too deeply, but you can follow my tutorial on MDS [here](/mds/) if you want to.

# How to choose a distance measure

| Measurement level | Use case | Method |
| ----------------- | -------  | ------ | 
| Interval Ratio |                         | [Euclidian](/distance-measures/#euclidian-distance) |   
| Categorical    | Number of overlapping variables | Jaccard   |
| Categorical    | Strings of equal lenght | Hamming   |
| Ordinal        |                         | Manhattan | 
| Mixed          |                         | Gower     |


# Euclidian distance

[<img src="/_pages/tutorials/distance-measures/CHiPs.jpg" width="152" height="190" align="right"/>](http://www.imdb.com/title/tt0075488/)

The Euclidian distance is the distance measure we're all used to: the shortest distance between two points. This distance measure is mostly used for interval or ratio variables. Be careful using this measure since the distance measure can be highly impacted by outliers, throwing any subsequent clustering off. 

The data set we'll be using is a data set about crime rates [in cities of the USA from 1973](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/USArrests.html). It contains variables about violent crime rates per 100.000 residents for assault, murder, and rape.

If your data set contains multiple variables, chances are they contain different measures; in this example we do not only have crime rates per 100.000 residents, but also a variable for the percentage of the population considered ubran. It might happen that one of the variables, with the largest range of values, might 'kidnap' the whole distance measure. To prevent this from happening you need to scale and center your data with R's native _[scale](https://stat.ethz.ch/R-manual/R-devel/library/base/html/scale.html)_ function, ensuring all variables equally represented in the distance measure:
```r
scaled_USArrests <- scale(USArrests)
```
The distances are calculated by the _[dist](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/dist.html)_ function, passing the value "euclidian" to the _method_ argument: 
```r
dist_USArrests <- dist(scaled_USArrests, method = "euclidian")
```

## MDS on euclidian similarity

Now we have a distance matrix, we might want to explore the similarities visually. Here we use MDS (for more on that subject, see the [MDS tutorial](/mds/)) to get the 4 dimensional similarity matrix down to two dimensions we can visually interpret. First we convert the distance object to a normal matrix which can be used by the _cmdscale_ function.
```r
mat_USArrests <- as.matrix(dist_USArrests)

mds_USArrests <- cmdscale(mat_USArrests, eig = TRUE, k = 2)  # Perform the actual MDS
```
Then we combine the data set with the MDS solution to a data frame we can use for our plot:
```r
df_mds_USArrests <- data.frame(city = row.names(USArrests),
                               scaled_USArrests, 
                               x = mds_USArrests$points[,1], 
                               y = mds_USArrests$points[,2])
```
Since we want to see how all variables impacted the MDS solution we'll rotate the variables so they become different data sets we can use to make a plot for each variable, through ggplot's _facet_ function.
```r
df_mds_USArrests %<>% 
  gather(key = "variable", value = "values", -city, -x, -y) 
```
Then we can finally create the plot. Note how the _values_ variable and _variables_ variable is used in the _facet_ function are used so we can get a look at the impact of all variables:
```r
ggplot(df_mds_USArrests, aes(x, y)) +
  geom_jitter(aes(col = values, alpha = values)) +
  geom_label_repel(aes(label = city, fill = values, alpha = values)) +
  facet_wrap(~variable) 
```

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/distance-measures/mds-euclidian.png" target="_blank">
<img src="/_pages/tutorials/distance-measures/mds-euclidian.png" alt="Euclidian MDS" align="center" width="50%" height="50%"/><br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}

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

[<img src="/_pages/tutorials/distance-measures/jaccard.jpg" width="200" height="190" align="right"/>](https://jaccard.com/collections/meat-tenderizers)

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

# Gower distance

<img src="/_pages/tutorials/distance-measures/brain-eaters.jpg" width="125" height="190" align="right"/>
Gower's General Similarity Coefficient is one of the most popular measures of proximity for mixed data types. 

For each variable type, a particular distance metric that works well for that type is used and scaled to fall between 0 and 1. Then, a linear combination using user-specified weights (most simply an average) is calculated to create the final distance matrix. 

Calculating the Gower distance matrix in R can be done with the _[daisy](https://www.rdocumentation.org/packages/cluster/topics/daisy)_ function from the **[cluster](https://www.rdocumentation.org/packages/cluster)** package. 

To show how this procedure can be done in R I've found this movie dataset I've found [here](https://rpubs.com/arun_infy13/97529). This movie data set contains numerical variables like rating and number of votes, as well as categorical values about the movie's genre. We'll use the Gower distance measure on this dataset. Here's how we get the data set:
```r
url <- "http://vincentarelbundock.github.io/Rdatasets/csv/ggplot2/movies.csv"
df_movie <- read.table(file = url, header = TRUE, sep = ",")
```
The _df_movie_ data frame contains some columns I considered unnecessary and some needed to be recoded to factor variables so they are treated appropriately by the distance function:
```r
df_movie %<>%
  dplyr::select(-X, -c(r1:r10), -mpaa, -budget) %>% 
  mutate(Action = factor(Action), Animation = factor(Animation), Comedy = factor(Comedy), 
         Drama = factor(Drama), Documentary = factor(Documentary), Romance = factor(Romance),
         Short = factor(Short))
```
Since the movie data set is pretty big, wel'll just create a random sample of 2000 movies, since I'm just demonstrating an idea here:
```r
df_movie_selection <- df_movie[sample(nrow(df_movie), 2000),]
```
Next we'll calculate the similarities between the movies
```r
library(cluster)
dist_gower <- daisy(df_movie_selection[, -1],
                    metric = "gower",
                    type = list(logratio = 3))
```
How does this similarity landscape look? Let's take a peek using MDS. In order to get the MDS _cmdscale_ function to work we need to convert the distance object to a regular matrix:
```r
mat_gower <- as.matrix(dist_gower)
```

## MDS on Gower distance
Next we'll get a MDS solution, _mds_movies_, with 2 dimensions to plot 
```r
mds_movies <- cmdscale(mat_gower, eig = TRUE, k = 2)
```
and convert it to a data frame we can use with ggplot in the desired way:
```r
df_mds_movies <- data.frame(df_movie_selection, 
                            x = mds_movies$points[,1],
                            y = mds_movies$points[,2])

df_mds_movies %<>% 
  dplyr::select(title, x, y, year, rating, Action, Animation, 
                Comedy, Drama, Documentary, Romance, Short) %>% 
  gather(key = "variable", value = "values", -title, -x, -y, -year, -rating)
```
The plot:
```r
ggplot(df_mds_movies, aes(x, y)) +
  geom_jitter(aes(col = variable, alpha = values)) +
  facet_wrap(~variable) +
  guides(alpha = FALSE)
```

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/distance-measures/mds-gower.png" target="_blank">
<img src="/_pages/tutorials/distance-measures/mds-gower.png" alt="Shaped word cloud" align="center" width="50%" height="50%"/><br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}

## t-SNE

```r
library(Rtsne)

fit_tsne <- Rtsne(dist_gower,
                  is_distance = TRUE,
                  check_duplicates = FALSE, 
                  pca = FALSE, 
                  perplexity = 120, 
                  theta = 0.5, 
                  dims = 2)
```
```r
df_tsne_vars <- as_data_frame(cbind(df_movie_selection,
                                    x = fit_tsne$Y[, 1],
                                    y = fit_tsne$Y[, 2]))

df_tsne_movies <- df_tsne_vars %>% 
  dplyr::select(title, x, y, year, rating, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>% 
  gather(key = "variable", value = "values", -title, -x, -y, -year, -rating)
```
Plot:
```r
ggplot(df_tsne_movies, aes(x, y, col = values)) +
  geom_point(aes(alpha = values, col = year)) +
  facet_wrap(~variable)
```

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/distance-measures/t-sne-gower.png" target="_blank">
<img src="/_pages/tutorials/distance-measures/t-sne-gower.png" alt="Shaped word cloud" align="center" width="50%" height="50%"/><br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}
