---
layout: page
title: Graphs
permalink: /graph-tips/
---

* TOC 
{:toc}

# ggplot

ggplot has a lot of nice extensions: [http://www.ggplot2-exts.org/gallery/](http://www.ggplot2-exts.org/gallery/) ggplot axes labelling quickly end up with scientific notations... Not something I really like. You can force ggplot to display 'normal' numbers by adding this to your plot statement: 

```r
scale_y_continuous(labels = format_format(big.mark = ".", 
                                          decimal.mark = ",", 
                                          scientific = FALSE))
```

If you use currency in your plot you probably want the axis to represent this. If you use the function below, you can use that function when formatting an axis. You can add the function to your axis layout like this: 

```r
scale_y_continuous(label=euro_format)
```

Bar plots where the bars represent percentage of the whole population: 
```r
geom_bar(aes(y = (..count..)/sum(..count..)))
```

# Word clouds

The [**wordcloud** library](https://cran.r-project.org/web/packages/wordcloud/wordcloud.pdf) can be used like the following: 

```r
wordcloud(text, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
```

The random.order variable specifies whether the most frequent word is plot first, or whether words are plot randomly. Passing the brewer.pal() function to the color parameter tells the wordcloud to use 8 colours from the RColorbrewer [Dark2](http://colorbrewer2.org/#type=qualitative&scheme=Dark2&n=3) palette: 
<img src="/_pages/snippets-and-tips/wordcloud_kerst.png" alt="Wordcloud 'kerst'" align="center"/> 

The [wordcloud2 library](https://cran.r-project.org/web/packages/wordcloud2/vignettes/wordcloud.html) offers more advanced formatting, even allowing you to define the shape of the [wordcloud](http://www.r-graph-gallery.com/2016/12/09/the-wordcloud2-library/). The down-side? Slow as.... This example below, is coming from my tutorial [Mining Alice's Wonderland](/mining-alices-wonderland/)

<img src="/_pages/tutorials/mining-alices-wonderland/rabbit-cloud.png" alt="Shaped word cloud" align="center"/> 

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

<img src="/_pages/snippets-and-tips/ggmap.png" alt="ggmap with Google" align="center"/> 

# (Map) Rasters

Countries can be divided in administrative districts. These can be accessed and plotted using the **raster** library. Country maps can easily be plotted using this code: 

```r
library(raster) 
netherlands <- getData('GADM', country='NLD', level=1) plot(netherlands) 
```

The level parameter determines the granularity of the administrative areas used. This above example shows the subdivision of The Netherlands in provinces. If we increase the level parameter by one we drill down to 'gemeentes' 

<img src="/_pages/snippets-and-tips/map_raster1.png" alt="" align="center"/> 

```r
netherlands <- getData('GADM', country='NLD', level=2)
```

As you might expect, the country parameter specifies the country you want to view. The country parameter should be specified using the ALPHA 3 ISO code: [http://www.nationsonline.org/oneworld/country_code_list.htm](http://www.nationsonline.org/oneworld/country_code_list.htm)

<img src="/_pages/snippets-and-tips/map_raster2.png" alt="" align="center"/> 
