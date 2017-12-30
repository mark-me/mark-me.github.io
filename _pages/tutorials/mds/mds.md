---
layout: page
title: Multidimensional scaling
comments: true
permalink: /mds/
published: true
---

* TOC
{:toc}

<img src="/_pages/tutorials/mds/Taylor-Swift-Cats.jpg" width="227" height="170" align="right"/> 
Whenever I'm in an explorative phase of my data modelling, very soon I'll have questions about the data that may sound familiar in it's vangueness:

* Can I find any groups in this list of people, by how much money they spent on drugstore items, minutes they've spent in greeneries department and the amount of time they spent in the gym?
* Are there any groups of customers that stand out in money spent, products they buy and marketshare we have?
* What smartphones are available in the market and how much are they alike in terms of specs and pricing? (Give me a data-set please!)
* How much do cats look alike in fluffyness of the tail, playfulness, hair color, eye color, number of legs.... I have a _lot_ of cats... OK!?!?!?
* And the desperate: "I have no clue what I'm looking for, please give me a clue?"

The similarity between these questions is mostly captured by the generic sentence: how similar are these cases in terms of _a_, _b_ _c_, _d_, _e_... well, you're getting the picture... right? What you're really looking for, are variables that can make a narrative about a set of data: maybe you find small pockets of observations that have special meanings or maybe you find variables that are group defining. These narratives can further by explored by clustering data or making predictions based on a subset of variables. 

As you might have noticed, I've used the word similarity a lot. We can calculate similarity between observations per variable. (You can find out more about caclulating similarities in this [tutorial](/distance-measures/).) If you want to include all similarities in your judgement of similarity you can use MDS to reduce the number of similarity measures while retaining as much of the similarity as possible. With MDS you can reduce the number of similarities to two measures of similarity. With this MDS let's you visually inspect similarity in observations in an easy 2D scatterplot. The more alike observations are the closer their points are together, the more unlike they are the further they are apart. But, how do you get a 2D scatterplot for so many variables? MDS does this by "rearranging" the observations in an efficient manner, so as to arrive at a configuration that best approximates the alikeness of observations. 

# The concept

<img src="/_pages/tutorials/mds/flat-earth.jpg" width="178" height="100" align="right"/> 

The MDS-like solution you are very familiar with, without even being conscious of it, is a world map. Making a flat world map, from  the spherical object it is, always does some kind of 'damage' to the origianl. This video that illustrates that really well:

{:refdef: style="text-align: center;"}
<iframe width="560" height="315" src="https://www.youtube.com/embed/kIID5FDi2JQ" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>
{: refdef}

While the MDS algorithm tries to fit the observations in the lower dimensional space, it tries to keep a measure called _stress_ as low as possible. The _stress_ measure compares the distances of the original _n_-dimensional space (_n_ = each variables distance measure) to the newly created distances in the lower dimensional space. The MDS algorithm moves the observations around until the configuration is is the solution with the lowest stress.

# Choosing the type of MDS

There are two types of MDS: parametric and non-parametric MDS. The measurement level of the variables you used to create your distance matrix determines the choice of the type of MDS you'll be using. Any MDS algorithm you'll be using takes in a similarity matrix. (If you want to read up on that I've written a [tutorial about that subject](/distances/)

# Metric MDS

[<img src="/_pages/tutorials/distance-measures/CHiPs.jpg" width="152" height="190" align="right"/>](http://www.imdb.com/title/tt0051432/)You can perform a classical MDS using the _[cmdscale](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/cmdscale.html)_ function which is included in the base R package, so you won't need to install a package for this one. 

The data set we'll be using is a data set about crime rates [in cities of the USA from 1973](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/USArrests.html). It contains variables about violent crime rates per 100.000 residents for assault, murder, and rape. I've used this example before in the [Similarity tutorial](/distance-measures/), which you could read up on, for more on similarity and distances. 

First a distance object is created ofrom the scaled data, which is needed to 'feed' the _cmdcale_ function:
```r
scaled_USArrests <- scale(USArrests)
dist_USArrests <- dist(scaled_USArrests, method = "euclidian")
```
Now we convert the distance object to a normal matrix which can be used by the _cmdscale_ function.
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
This creates the plot below, where the cities are plotted by similarity and their respective crime rates and population are indicated by their opacity. We can see here is that the distances across the X axis tells us a lot about assault: the left side shows high assault rates. The rape and murder rates are highest in the top left and lower left corners respectively. It seems Assault is prevalent in cities were rape and murder is also prevalent, but rape and murder are not prevalent across the same cities. The y axis represents differences in urban population percentages, it seems urban population and crime rates are not necessarily related.

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/distance-measures/mds-euclidian.png" target="_blank">
<img src="/_pages/tutorials/distance-measures/mds-euclidian.png" alt="Euclidian MDS" align="center" width="80%" height="80%"/><br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}

It seems approaching similarities in this way already told us a lot about this data set, and should give some directions on which [statistical tests](/statistical-tests/) mightt be done to do to see if you can confirm any the semi 'hypotheses' just made... Carrying on...

[This link](https://raw.githubusercontent.com/mark-me/mark-me.github.io/master/_pages/tutorials/distance-measures/euclidian-distance.R) will give you the entire script for a running example you can play around with yourself.

# Non-metric MDS

[<img src="/_pages/tutorials/distance-measures/brain-eaters.jpg" width="125" height="190" align="right"/>](http://www.imdb.com/title/tt0051432/)
To perform non-metric MDS we use the Kruskal's Non-metric MDS implemented with the _[monoMDS](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/isoMDS.html)_ function from the [vegan](https://www.rdocumentation.org/packages/vegan) library. Its not the only function you can do Kruskal's Non-metric MDS with, but it is the fastest performing one

(You can also choose the _[metaMDS](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/metaMDS.html)_ from the **vegan** library or the _[isoMDS](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/isoMDS.html)_ from the **[MASS](https://www.rdocumentation.org/packages/MASS/)** library. If you use the **MASS** library, **dplyr**'s _select_ function will be overruled, which is annoying. You can reset the select function back to the dplyr function with ```select <- dplyr::select```)

To show how this procedure can be done in R I've found this movie dataset I've found [here](https://rpubs.com/arun_infy13/97529). This movie data set contains numerical variables like rating and number of votes, as well as categorical values about the movie's genre. Since this set is an example of mixe data (categorical genre data, and interval data like rating) we'll be using Gower's General Similarity Coefficient. Calculating Gowe's distance is explained further in the [Similarity tutorial](/distance-measures/). 

Calculating the Gower distance matrix in R can be done with the _[daisy](https://www.rdocumentation.org/packages/cluster/topics/daisy)_ function from the **[cluster](https://www.rdocumentation.org/packages/cluster)** package. Before we jump into the code, a short explanation about the data: the data frame _df_movie_selection_ contains all relevant data for the similarity calculation, but the first column contains the film title, which would nog make much sense to put into the similarity object:
```r
library(cluster)
dist_gower <- daisy(df_movie_selection[, -1],
                    metric = "gower",
                    type = list(logratio = 3))
```
The distance object is that converted into a regular matrix, which can feed into the MDS function:
```r
mat_gower <- as.matrix(dist_gower)
```
So let's create the nonmetric MDS solution with the _monoMDS_ function:
```r
mds_nonmetric <- monoMDS(dist_gower)
```
Then a data frame is created so the MDS solution can be plotted with ggplot:
```r
df_mds_nonmetric <- cbind(df_movie_selection, 
                       x = mds_nonmetric$points[,1], 
                       y = mds_nonmetric$points[,2])
```
Also we can review the movies if they fit multiple genres. For this purpose a variable, _genre_, is created where the genre(s) a movie belong to is put in a string:
```r
df_mds_nonmetric %<>% 
  mutate(genre = paste0(ifelse(Animation == 1, "Animation, ", ""),
                        ifelse(Comedy == 1, "Comedy, ", ""), 
                        ifelse(Drama == 1, "Drama, ", ""),
                        ifelse(Documentary == 1, "Documentary, ", ""),
                        ifelse(Romance == 1, "Romance, ", ""),
                        ifelse(Short == 1, "Short, ", ""))) %>% 
  mutate(genre = substr(genre, 1, nchar(genre) - 2)) %>% 
  mutate(genre = factor(genre))
```
It would be great to have the genres displayed in a text label, but if we give each point in the plot a text label we'll end up with too many text labels. To counter that problem we create one point, at the median of _x_ and _y_, with a text label containing the genre. By taking the median of the _x_ and _y_ values per genre combination, it is more likelily the position of that label represents the majority of points.  
```r
df_genres <- df_mds_nonmetric %>%
  group_by(genre, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  summarise(x = median(x), 
            y = median(y))
```
Finally we can create a plot with the MDS solution:
```r
ggplot(df_mds_nonmetric, aes(x, y)) +
  geom_label_repel(data = df_genres, 
                   aes(x, y, label = genre, col = genre)) + 
  geom_jitter(aes(col = genre), alpha = .2)
```

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/mds/mds-nonmetric.png" target="_blank">
<img src="/_pages/tutorials/mds/mds-nonmetric.png" alt="Non-metric MDS" align="center" width="80%" height="80%"/><br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}

## Let's be stubborn

Now, let's see if the metric MDS solution would be worse in this case. For this we first create a metric MDS solution with the _cmdscale_ function:
```r
mds_metric <- cmdscale(dist_gower)
```
Then we do all the steps as with the non-metric MDS solution, to create a data-freame with wich we can create the metric MDS solution plot. The 
```r
ggplot(df_mds_metric, aes(x, y)) +
  geom_label_repel(data = df_genre_metric, 
                   aes(x, y, label = genre, col = genre)) + 
  geom_jitter(aes(col = genre), alpha = .2) 
```

Let's compare the non-metric versus the metric MDS solution. You can see that the metric solution a 'chasm' between two sets, while the non-metric option looks more like a sphere. If you compare the continuity between the "Drama, Romance" and the "Comedy, Drama, Romance" categories, the non-metric version seems more logical than the metric version, which seems to make sense. So doing a non-metric MDS for non interval data, does get you a more optimal MDS solution.

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/mds/mds-metric-vs-nonmetric.png" target="_blank">
<img src="/_pages/tutorials/mds/mds-metric-vs-nonmetric.png" alt="Metric versus non-metric MDS" align="center" width="80%" height="80%"/><br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}
