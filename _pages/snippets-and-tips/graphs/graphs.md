---
layout: page
title: Graphs
comments: true
permalink: /graph-tips/
---

* TOC
{:toc}

# Saving plots for publication

<img src="/_pages/snippets-and-tips/graphs/90s-pie-chart.jpg" width="220" height="180" align="right"/> 

It's all fun and games playing around with R for a while, but after some period I found out I actually had to get stuff out there: they call it work. I always thought the plots from R looked awesome, but working on my work laptop with Windows I found that the quality of the images was a bit dissapointing: I could see rough edges, giving the pictures a look like they came from the 90's. So for a presentation I wanted to up my game: making them look beautiful includes making them pixel perfect. To do this you can surround your graph syntax by using the function _png_ to precede your plot syntax and the _dev.off_ function after the plot syntax like this:
```r
png(filename="Std_PNG.png", 
    units = "cm", 
    width = 5, 
    height = 4, 
    pointsize = 12, 
    res = 300)
my_sc_plot(data)
dev.off()
```
In the _png_ function you pass the name you want to give your file to the _filename_ argument (no shit Sherlock), the _units_ argument can set the measurement level of the _width_ and _weight_ parameters. In this case I use centimeters (cm) since I'm using the output for a European PowerPoint file; so in this case the _width_ and _weight_ parameters specify the with and height of the output file in centimeters. The _res_ argument is key for making them '[pixel perfect](https://en.wikipedia.org/wiki/Pixel_Perfect)', the number you put here is the number of pixels you want tho squeeze in a square inch: the higher the better, but there is a limit. Play around with it to find your optimum.

# ggplot

ggplot has a lot of nice extensions: [http://www.ggplot2-exts.org/gallery/](http://www.ggplot2-exts.org/gallery/).

## Axis formatting

ggplot axes labelling quickly end up with scientific notations... Not something I really like. You can force ggplot to display 'normal' numbers by adding this to your plot statement:

```r
scale_y_continuous(labels = format_format(big.mark = ".",
                                          decimal.mark = ",",
                                          scientific = FALSE))
```

If you use currency in your plot you probably want the axis to represent this. If you use the function below, you can use that function when formatting an axis. You can add the function to your axis layout like this:

```r
scale_y_continuous(label=euro_format)
```
## Bar plots

The most commoly used kind of plot must be the bar plot. Here are some things I had struggles with.

Generally the data set we use is not aggregated, but we still want a count of the rows in it. One of the problems I came across is: how do I plot a percentage of the whole population on one bar? Bar plots where the bars represent percentage of the whole population are created with _geom_bar_ like this:
```r
geom_bar(aes(y = (..count..)/sum(..count..)))
```

```r
geom_label(aes(y = cumsum(perc) - perc / 2,
               label = percent(perc))) 
```

## Pie charts

'Empty' theme:
```r
blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text =  element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )
```
```r
diamonds %>% 
  group_by(cut) %>% 
  summarise(n = n()) %>% 
  mutate(perc = n / sum(n)) %>% 
  mutate(label = paste0(cut, " - ", percent(perc))) %>% 
  arrange(desc(perc)) %>%
  ggplot(df_pie, aes(x = "", y = perc)) +
    geom_bar(aes(fill = reorder(cut, perc)), 
             width = 1, 
             stat = "identity", 
             col = "white") + 
    geom_label_repel(x = 1.2,
                     aes(y = cumsum(perc) - perc / 2,
                         label = label, 
                         col = reorder(cut, perc)), 
                     size = 5) +
    coord_polar(theta = "y", start = 0) +
    guides(col = FALSE, fill = FALSE) +
    blank_theme
```

## Creating your own theme

Sooner or later you want to standardize your lay-out of the graphs: all graphs should use the same set of colours, all graphs should have this turned on, that turned off, this made more dark etcetera. I do this by first choosing one of the standard themes from the **[ggtheme](http://ggplot2.tidyverse.org/reference/ggtheme.html)** library and tweaking that. In this case

## Combining graphs

Sometimes you want two ggplots together in one picture, by putting them side by side or in a matrix of graphs. You can do this using the **[gridExtra](https://cran.r-project.org/web/packages/gridExtra/vignettes/arrangeGrob.html)** library. In this example I was putting two plots _p_miss_vars_ and _p_miss_pattern_ side by side:
```r
grid.arrange(p_miss_vars, p_miss_pattern, nrow = 1)
```

# Word clouds

The [**wordcloud** library](https://cran.r-project.org/web/packages/wordcloud/wordcloud.pdf) can be used like the following:

```r
wordcloud(text, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
```

The random.order variable specifies whether the most frequent word is plot first, or whether words are plot randomly. Passing the brewer.pal() function to the color parameter tells the wordcloud to use 8 colours from the RColorbrewer [Dark2](http://colorbrewer2.org/#type=qualitative&scheme=Dark2&n=3) palette:
<img src="/_pages/snippets-and-tips/graphs/wordcloud_kerst.png" alt="Wordcloud 'kerst'" align="center"/>

The [wordcloud2 library](https://cran.r-project.org/web/packages/wordcloud2/vignettes/wordcloud.html) offers more advanced formatting, even allowing you to define the shape of the [wordcloud](http://www.r-graph-gallery.com/2016/12/09/the-wordcloud2-library/). The down-side? Slow as.... This example below, is coming from my tutorial [Mining Alice's Wonderland](/mining-alices-wonderland/). Here a transparent PNG is used, in which the words of "Alice's Adventures in Wonderland" is projected.

<img src="/_pages/tutorials/mining-alices-wonderland/rabbit-cloud.png" alt="Shaped word cloud" align="center"/>

# Network graphs

Networked graphs can be created using the **ggraph** library. I've created a [tutorial](/network-graphs-ggraph/) with two examples of networked graphs, one of which looks like this:
{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/network-graphs-with-ggraph/ggraph-hierarchical.png" target="_blank">
<img src="/_pages/tutorials/network-graphs-with-ggraph/ggraph-hierarchical.png" alt="" width="800" height="565" align="center"/>
<br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}

# ggmap

With the [ggmap library](https://cran.r-project.org/web/packages/ggmap/ggmap.pdf) you can plot data on a Google Map or OpenStreetMap amongst others.

```r
library(ggmap)
```

First you get the map picture from one of the services:

```r
map_belgium <- get_map(location="belgium", zoom=7, maptype='terrain', source='google', color='color')
```

Most map graphing tools make you fill in longitudes and latitudes in advance, but this library allows you to use the map provider's own search capabilities to add the longitudes and latitudes. Google Maps does limit the number of requests by 2.500 per call, so you might have to do some grouping. For example: I made a map of all Belgian companies, of which I happily used all company addresses to get the coordinates. Google thought I was overreacting making so many coordinate requests, so instead I aggregated the companies to countries and towns to perform the search:

```r
tbl_towns <- tbl_market_base %>% # Aggregate the market to country/town
  group_by(country, town) %>%
  summarise(qty_companies = n())

coord <- geocode(paste0(tbl_towns$country, ", ", tbl_towns$town)) # Get coordinates
```

I pushed the enriched data back on the company data

```r
tbl_towns <- cbind(tbl_towns,coord) %<>%
  left_join(tbl_towns, by=c("country","town"))
```
and created this map:

```r
ggmap(map_belgium) +
  geom_point(data=tbl_market_base, aes(x = lon, y = lat, colour=code_language ))
```

<img src="/_pages/snippets-and-tips/graphs/ggmap.png" alt="ggmap with Google" align="center"/>

# (Map) Rasters

Countries can be divided in administrative districts. These can be accessed and plotted using the **raster** library. Country maps can easily be plotted using this code:

```r
library(raster)
netherlands <- getData('GADM', country='NLD', level=1) plot(netherlands)
```

The level parameter determines the granularity of the administrative areas used. This above example shows the subdivision of The Netherlands in provinces. If we increase the level parameter by one we drill down to 'gemeentes'

<img src="/_pages/snippets-and-tips/graphs/map_raster1.png" alt="" align="center"/>

```r
netherlands <- getData('GADM', country='NLD', level=2)
```

As you might expect, the country parameter specifies the country you want to view. The country parameter should be specified using the ALPHA 3 ISO code: [http://www.nationsonline.org/oneworld/country_code_list.htm](http://www.nationsonline.org/oneworld/country_code_list.htm)

<img src="/_pages/snippets-and-tips/graphs/map_raster2.png" alt="" align="center"/>

# World map

The library **[rworldmap](https://cran.r-project.org/web/packages/rworldmap/rworldmap.pdf)** lets' you easily plot statistics in world maps as long as you van ISO coded country codes in your data set. Below we load the library, and 'join' the data frame _df_country_votes_ with the _pam_cluster_ variable and the ISO2 coded _country_code_ variable to our world map:
```r
library(rworldmap)

mapped_data <- joinCountryData2Map(df_country_votes, 
                                   joinCode = "ISO2", 
                                   nameJoinColumn = "country_code", 
                                   suggestForFailedCodes = TRUE)
```
The palette _cbbPalette_ is created to fill our colors on the world map. The _mapCountryData_ function is called supplying the data set _mapped_data_ you've just created. The string _pam_cluster_ is passed to the _nameColumnToPlot_ parameter to make the colors match up with the cluster. Note that the _colourPalette_ parameter gets the slightly weird subset of the _cbbPalette_ colors by using the argument cbbPalette[1:length(pam_fit$medoids)]; this is done so the numbers of colors in the palette matches the number of clusters. Otherwise the colors will be interpolated, which could give you results you're not quite happy with. 

{:refdef: style="text-align: center;"}
<a href="/_pages/tutorials/clustering-mds/unvotes-map-clusters.png" target="_blank">
<img src="/_pages/tutorials/clustering-mds/unvotes-map-clusters.png" alt="World map of UN votes" width="100%" height="100%" align="center"/><br>
<i class='fa fa-search-plus '></i> Zoom</a>
{: refdef}
