---
layout: page
title: Graphs - ggplot
comments: true
permalink: /graph-tips-ggplot/
---

# Extensions 

ggplot has a lot of nice extensions: [http://www.ggplot2-exts.org/gallery/](http://www.ggplot2-exts.org/gallery/).

# Axis formatting

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

# Point plots

Sometimes you need labels indicating which point in the plot stands for what. Using the _geom_label_ and _geom_text_ functions cause overlapping so the texts become illegible. The **[ggrepel](https://cran.r-project.org/web/packages/ggrepel/vignettes/ggrepel.html)** library provides the _geom_label_repel_ function which prevents exactly that. It makes sure each label dodges others whenever possible.
```r
ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point() +
  geom_label_repel(aes(label = rownames(mtcars))) 
```

{:refdef: style="text-align: center;"}
<img src="/_pages/snippets-and-tips/graphs/ggrepel.png" alt="ggrepel" align="center"/>
{: refdef}

# Bar plots

The most commoly used kind of plot must be the bar plot. Here are some things I had struggles with.

## Percentage of rows per variable

Generally the data set we use is not aggregated, but we still want a count of the rows in it. One of the problems I came across is: how do I plot a percentage of the whole population on one bar? Bar plots where the bars represent percentage of the whole population are created with _geom_bar_ like this:
```r
geom_bar(aes(y = (..count..)/sum(..count..)))
```
To show the percentage labels within the stacked bar, the _geom_label_ function must have it's own _y_ aesthetic so they are well alligned. The percentage value _perc_ is a value between 0 and 1, but is displayed like a proper percentage by passing it to the _percentage_ function from the **[scales](https://www.rdocumentation.org/packages/scales)** library.
```r
geom_label(aes(y = cumsum(perc) - perc / 2, label = percent(perc))) 
```
## Dodged bar plots with value labels

Whenever I wanted value labels on side by side bar-plots I got a headache: how do you make sure the texts are dodged as well? Below I've made an example based on the _Titanic_ data set. I had to convert it to a data frame before I could use it in a ggplot. The trick of the text dodgingg is in the setting the _position_ parameter of the _geom_text_ function to ```position_dodge(width = 1)```. The _vjust_ parameter let's you play around with the text's position around it's _y_ aesthetic; setting it's value to -.25 puts the text above the bar, while setting it to 1.5 puts it on the inside end of the bar.
```r
titanic <- as.data.frame(Titanic)

titanic %>% 
  group_by(Class, Survived) %>% 
  summarise(Freq = sum(Freq)) %>% 
ggplot(aes(x = Class, y = Freq, fill = Survived)) + 
  geom_col(position = "dodge") +
  geom_text(aes(label = Freq), 
            position = position_dodge(width = 1), vjust = -0.25)
```

{:refdef: style="text-align: center;"}
<img src="/_pages/snippets-and-tips/graphs/bar-plot-dodge.png" alt="ggrepel" align="center"/>
{: refdef}

# Pie charts

Creating a pie chart is not a straightforward process in the ggplot framework, since Tufte deemed them [bad](http://speakingppt.com/2013/03/18/why-tufte-is-flat-out-wrong-about-pie-charts/), they aren't worth proper attention. Standard parts of a ggplot are axes, which aren't usefull for pie charts. So to display pie charts cleanly we need to create an  'Empty' theme:
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
Let's make and example of the [diamonds](http://ggplot2.tidyverse.org/reference/diamonds.html) data set. The _coord_polar_ function in this code is what turns a bar plot into a pie chart. 

* First the _diamond_ data set is prepared by aggerating it by _cut_ and counting the rows, then the percentage, _perc_ is calculated. The _cut_ variable and _perc_ are put together in a label seperated by a newline ```rmutate(label = paste0(cut, "\n", percent(perc)))```; this label will be used to display on top of the bar char. The data frame is descendingly ordered by the percentage so the labels will correctly align to the plot. The data is fed into the _ggplot_ function. 
* The _geom_col_ function aesthetic's color fill is done by cut, but the order is determined by the percentage by ```r reorder(cut, perc)```. The parameter _width_ is set to 1 so the pie chart has no hole in the middle. 
* For adding the labels the _geom_label_'s _x_ is set to 1.2 to ensure the label is put somewhat on the outside of the plot. The _col_ aesthetic, like the _fill_ of the _geom_col_ is ordered by the _perc_ variable so the colors line up. 
* The _coord_polar_ function turns the bar chart into a pie chart by setting the _theta_ to "y" so the y-axis is the circumference of the pie.
* I've turned off the fill and color legends, using the _guides_ function, since all information is displayed in the labels
* Lastly the newly created _blank_theme_ is added to remove all the bloat.

```r
diamonds %>% 
  group_by(cut) %>% 
  summarise(n = n()) %>% 
  mutate(perc = n / sum(n)) %>% 
  mutate(label = paste0(cut, "\n", percent(perc))) %>% 
  arrange(desc(perc)) %>%
  ggplot(aes(x = "", y = perc)) +
    geom_col(aes(fill = reorder(cut, perc)), 
             width = 1, 
             col = "white") + 
    geom_label(x = 1.2,
               aes(y = cumsum(perc) - perc / 2,
                   label = label, 
                   col = reorder(cut, perc)), 
               size = 5) +
    coord_polar(theta = "y", start = 0) +
    guides(col = FALSE, fill = FALSE) +
    blank_theme
```
{:refdef: style="text-align: center;"}
<img src="/_pages/snippets-and-tips/graphs/pie-plot.png" alt="Pie plot" align="center"/>
{: refdef}

# Creating your own theme

Sooner or later you want to standardize your lay-out of the graphs: all graphs should use the same set of colours, all graphs should have this turned on, that turned off, this made more dark etcetera. I do this by first choosing one of the standard themes from the **[ggtheme](http://ggplot2.tidyverse.org/reference/ggtheme.html)** library and tweaking that. In this case

To add your own color the you simply create your own vector of hexadecimal color codes. If you don't have a set you can generate one using a picture by using the site [canva](https://www.canva.com/color-palette/) or [similar sites](https://www.google.nl/search?q=creating+color+theme+from+picture).
```r
col_theme <- c("#483D7A", "#8FC4FF", "#1B4229", "#7B6C5B", "#9A5F89")
```
You can use this vector in the _scale_color_manual_ and _scale_fill_manual_ functions to use it there for the color and fill of your graphs aesthetics:
```r
scale_color_manual(values = col_theme) +
scale_fill_manual(values = col_theme)
```

# Combining graphs

Sometimes you want two ggplots together in one picture, by putting them side by side or in a matrix of graphs. You can do this using the **[gridExtra](https://cran.r-project.org/web/packages/gridExtra/vignettes/arrangeGrob.html)** library. In this example I was putting two plots _p_miss_vars_ and _p_miss_pattern_ side by side:
```r
grid.arrange(p_miss_vars, p_miss_pattern, nrow = 1)
```
