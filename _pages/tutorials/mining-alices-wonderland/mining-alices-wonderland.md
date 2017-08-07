---
layout: page
title: Mining Alice's Wonderland
permalink: /mining-alices-wonderland/
---
<img src="/_pages/tutorials/mining-alices-wonderland/catterpillar.jpg" alt="alice catterpillar" width="376" height="284" align="right"/> As a kid I was captivated by the strange world of Disney's Alice in Wonderland: nothing seemed to make sense and everything was wonderfully weird and exciting. When I read the 'real' book as an adult, I found out what also gave it's appeal to a kids mind: the strange context with questions being asked in Alice will make you [wonder off...](https://www.youtube.com/watch?v=9Bk9ao6cSFs)

I decided it was time to learn some text mining and learned about the **[gutenbergr](https://cran.r-project.org/web/packages/gutenbergr/vignettes/intro.html) **library. This  library allows you to scrape information about writers, books and even the books itself from the [project Gutenberg](https://www.gutenberg.org/). And since Alice was on there, it was a no-brainer to have [Alice's Adventures in Wonderland](https://www.gutenberg.org/files/11/11-h/11-h.htm) as a try-out.  What I wanted to know: how are the characters in Alice's world viewed? In text mining terms: what are the sentiments associated with the characters?

For this tutorial I've assumed that you're pretty familiar with the **tidyverse** and **ggplot2**. First I'll discuss the concepts that drove the script, after which I'll jump into the technical workout of these concepts. The final script can be found in a link on the end of the tutorial.

# The building blocks

## Sentiments

Two of the most important datasets that are part of the **[tidytext](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html)** package are the _stop_words_ and _sentiments_. The first is useful when removing common words like, and, or or the. The other, _sentiments_ is useful for us to determine the emotions associated with the characters. The sentiment dataset contains 4 columns:

*   lexicon - the dataset contains several lexicons, each having their own characteristic way of  representing sentiments:
    *   [nrc](http://www.nrc-cnrc.gc.ca/eng/rd/ict/emotion_lexicons.html) - This is the lexicon we'll be using. It associates words with 8 basic emotions. These sentiments are found in the _sentiment_ column.
    *   bing - This lexicon divides words in either having negative or positive connotations. Which of it is can be found in the _sentiment_ column.
    *   AFINN - This lexicon also divides words in negative or positive connotations, but takes a scale approach inste ad of the bing binary approach.
*   word - you use this column to join the dataset on
*   sentiment - Depending on the lexicon you're using this is filled with descriptions.
*   score - if you use the AFINN lexicon this column contains the numerical value.

The nrc dataset I'll be using attributes one or more sentiments per word, which makes sense: words can evoke several emotions depending on context. I assume the 'right' sentiments will bubble up by the surrounding word sentiments.

## Characters

<img src="/_pages/tutorials/mining-alices-wonderland/queen.jpg" alt="Off with their heads!" width="238" height="190" align="right"/> This one speaks for itself. A vector of characters is what was needed, and I saw little options that just type all the characters myself. Typing stuff like that makes me understand the Queen of Hearts....

## Paragraphs

The paragraphs are the thing that tie the sentiments to the characters. I assumed that the sentiments that co-appear in the paragraph with characters, tells us something about the character. The sentiment profile then, is partly determined by the relative frequencies in which the sentiments co-appear with a character in paragraphs. Relative frequencies are calculated like this:

{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/mining-alices-wonderland/formula-freq-sentiment.png" alt="Frequency sentiment formula" width="215" height="45" align="middle"/>
{: refdef}

Relative frequencies in itself is not good enough because the book is probably scewed in a certain sentimental direction, which does not help if we want to know what makes a character unique. To counter this I use something I called lift: the relative sentiment frequency of corrected by the relative frequency of the total. As the total I've taken Alice's relative sentiment frequencies. So the lift was calculated like this:

{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/mining-alices-wonderland/formula-lift-sentiment.png" alt="Lift sentiment formula" width="215" height="45" align="middle"/>
{: refdef}

Luckily the ebook had white lines to delimit the paragraphs; sometimes life is easy.

## Plutchik's wheel

<img src="/_pages/tutorials/mining-alices-wonderland/plutchik-wheel.png" alt="Plutchik wheel" width="367" height="356" align="right"/> Remember the lexicons? I don't know whether this is coicidence, but the sentiment terms used in the nrc lexicon fit surprisingly well with [Plutchik's wheel of emotions](https://en.wikipedia.org/wiki/Contrasting_and_categorization_of_emotions#Plutchik.27s_wheel_of_emotions). As it is such a nice fit, I thought I'd use it as the basis of my plots.

As a psychologist, my first thought was: spider-graphs; create a character profile by plotting the value sentiment confidence of a character on each of the emotion scales and connect the dots. To do this I put the confidence value on the x axis, and rotated it to the corresponding emotion petal to find out the x and y coordinates of that sentiment value. For example

If you've seen spider-graphs a few times you know they can be very confusing when comparing multiple profiles: after more then 3 profiles spider-graphs become virtually unreadable. So I'd thought I'd dumb them down a bit by only displaying the center of gravity of each spider graph.

# The script

## Drawing Plutchik's wheel

For this I'll be using the **ggplot2** library's _[geom_polygon_layer](http://ggplot2.tidyverse.org/reference/geom_polygon.html) _. With ggplot2 you can combine seperate ggplots by adding them. Thinking I might need the Plutchik plot again I put it in a  function that does the drawing; the function takes the wheels radius as a parameter. I made the wheel's radius variable to ensure the characters plotted in the wheel are optimally displayed.

```r
plutchik_wheel <- function(radius)
```

A vector is created with the hex colors codes that are used to color the Plutchik's wheel.

```r
plutchik_colors <- c( "#8cff8c", "#ffffb1", "#ffc48c", "#ff8c8c",
                      "#ffc6ff", "#8c8cff", "#a5dbff", "#8cc68c")
```

Plutchik's wheel has 8 spokes, which I'll refer to as petals. To create a closed polygon for each petal, 5 points draw a petal: one from the origin (0, 0), three points on the perimeter of the wheel, and one again at the origin to close the polygon. The points at the perimeter of the wheel are part of the total wheel. So calculate these points we take the radius of the circle, and rotate them by 22.5 degrees (360 degreed / (8 petals * petal edges)). First we create a vector with the rotations needed for one petal:

```r
petal <- rep(c(0, 1:3, 0) ,8)
```

This would repeat the same petal over and over again on the same place, but instead we want the petals drawn next to each other. For this we'll transpose the petal vector so that each petal will have its own unique position:

```r
petal_transpose <- rep(c(0, 2, 2, 2, 0), 8) * rep(c(0:7), each =5)
petal_transposed <- (petal + petal_transpose)
```

Now the transposed petals are converted to radians to calculate the petal coordinates at the next step.

```r
radian_petals <- petal_transposed * 22.5 * pi/180
```

Now we create two vectors for the coordinates; _x_ and _y_:

```r
x <- radius * (petal > 0) * cos(radian_petals)
y <- radius * sin(radian_petals)
```

Then we create a vector for grouping the other vectors by petal, with this we'll be able to color the individual petals.

```r
id <- as.factor(rep(c(1:8), each = 5))
```

Now we've got all ingredients for drawing the petals. Next a factored vector is created with the petal names, with the names positions so the show in the middle of the perimeter. All other positions in the vector have NA as a value so no text will be displayed, this will generate a warning message that 32 values are removed that conating missing values (geom_text).

```r
emotions <- factor(c( NA, NA, "Trust", NA, NA,
                      NA, NA, "Joy", NA, NA,
                      NA, NA, "Anticipation", NA, NA,
                      NA, NA, "Anger", NA, NA,
                      NA, NA, "Disgust", NA, NA,
                      NA, NA, "Sadness", NA, NA,
                      NA, NA, "Surprise", NA, NA,
                      NA, NA, "Fear", NA, NA ),
                    levels = c("Trust", "Joy", "Anticipation", "Anger",
                               "Disgust", "Sadness", "Surprise","Fear"),
                    ordered = TRUE)
```

All the vectors are combined in one data frame that can be used in a ggplot.

```r
tbl_plutchik_wheel <- data.frame(id, x, y, emotions)
```

Lastly a ggplot is created, which can later be used as part of the final plot stack. The custom ggplot theme removes all unnecesary clutter (grids, ticks and titles of the axes and the legend of the colors in the wheel).

```r
wheel <- ggplot() +
  geom_polygon(data = tbl_plutchik_wheel, aes(x, y, fill=id, group=id)) +
  geom_text(data = tbl_plutchik_wheel, aes(x, y, label = emotions)) +
  scale_fill_manual(values = plutchik_colors) +
  theme(axis.line = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.position = "none",
        panel.background = element_rect(fill = "white"))
```

## Getting the book

To retrieve Alice's Adventures in Wonderland we first need to load the **gutenbergr** library.

```r
library(gutenbergr)
```

You can retreive the book by using the _gutenberg_download _function and passing the book ID as a parameter. The ID of [Alice's Adventures in Wonderland](https://www.gutenberg.org/ebooks/11) is 11\. The ID of the ebook is the last number of the URL when browsing for the book on the Project Gutenberg website.

```r
book_alice <- gutenberg_download(11)
```

## Detecting the paragraphs

Besides using the **tidyverse** library for this tutorial, we're going to use two additional libraries:

*   **[tidytext](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html)** - this library brings the tidyverse and text mining together. It allows you to make tidy data-frames to pass on to text mining tools.
*   [**stringr**](https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html) - a library packed with functions for text manipulation.

So let's start by loading the necesarry libraries:

```r
library(tidyverse)
library(tidytext)
library(stringr)
```

In the next section we take the downloaded book and first add some line numbers to it; which we use to skip some irrelevant lines of the book containing the title and such. After which we find out the rows that are just chapter headings, and the count the words in each line. We mark the lines which doesn't contain a chapter header and which have words as paragraphs.

```r
tbl_paragraphs >- book_alice %>%
  mutate(line = row_number()) %>%
  filter(line >= 10 & line < 3338) %>% # Skipping irrelevant lines
  mutate(is_chapter_title = str_detect(text, "CHAPTER")) %>%
  mutate(qty_words = sapply(gregexpr("[[:alpha:]]+", text), function(x) sum(x >; 0))) %>%
  mutate(is_paragraph = !is_chapter_title & qty_words > 0)
```
 
 After this the [_rle_](https://stat.ethz.ch/R-manual/R-devel/library/base/html/rle.html) function is used to find consequtive rows belong to a paragraph and when it is broken by non-paragraph lines. Each row in resulting data-frame tells us how many lines are part of one paragraph, or the number of lines between paragraphs.
 
```r
 tbl_paragraph_id <- data.frame(length = rle(tbl_paragraphs$is_paragraph)[[1]],
                                value = rle(tbl_paragraphs$is_paragraph)[[2]])
```

The we use this data frame to create a new column in the paragraph data frame to set an identifier for each paragraph. With the function _seq_ a number is generated for each set of consequtive lines. The _rep_ function repeats this number for the number of consequtive lines. In the next _mutate_ function the paragraph identifiers are removed if the set of consequtive rows are not part of a paragraph.

```r
tbl_paragraphs %<>% mutate(id_paragraph = rep(seq(1,nrow(tbl_paragraph_id),1),
                                              tbl_paragraph_id$length)) %>%
  mutate(id_paragraph = ifelse(is_paragraph, id_paragraph, NA))
```

Next we'll un-nest all words in each line so each word will become one row and put it in the _tbl_words_ data frame. We use the function _anti_join_ to remove any of the stopwords. Then only "words" are kept that only consist of letters. After this we only keep the words, the paragraph identifier in which they appear, and the frequency of their usage in that paragraph.

```r
tbl_word <- tbl_paragraphs %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by = "word") %>%
  mutate(word = str_extract(word, "[a-z']+")) %>%
  group_by(id_paragraph, word) %>%
  summarise(qty_word = n())
```

## Finding sentiments

We'll use the sentiments data frame from the **tidytext** package to create a custom data frame. But before we do that we'll create our own data frame that specifies how many degrees each sentiment should be rotated to fit it on Plutchik's wheel. The sentiments are then factored ordered by their order in Plutchik's wheel.

```r
sentiment_order <- c("fear", "trust", "joy", "anticipation",
                     "anger", "disgust", "sadness", "surprise")
degrees_sentiment <- c(0, 45, 90, 135, 180, 225, 270, 315)
tbl_sentiments <- data.frame(sentiment_order, degrees_sentiment)

tbl_sentiments %<>%
  rename(sentiment = sentiment_order) %>%
  mutate(sentiment = factor(sentiment, levels = sentiment_order, ordered = TRUE))
  
rm(degrees_sentiment)
```

The custom data frame, _tbl_sentiments_, that we'll create here just uses the nrc lexicon, and leaves out the 'positive' and 'negative' sentiments; which don't make much sense in the wheel. We'll just take the columns of that data frame which are useful to our analysis: words and their sentiments. The sentiments, which are factored variables in the original dataset, are refactored using the order in which they appear in Plutchik's wheel; before they can be refactored they have to be converted to strings to remove previous factoring.

```r
tbl_sentiment_lexicon <- sentiments %>%
  filter(sentiment != "negative" & sentiment != "positive") %>%
  filter(lexicon == "nrc") %>% select(word, sentiment) %>%
  mutate(sentiment = as.character(sentiment)) %>%
  mutate(sentiment = factor(sentiment, levels = sentiment_order, ordered = TRUE))
```

This pepared _tbl_sentiment_lexicon_ data frame is used together with the _tbl_word_ data frame to tie the sentiments to paragraphs. The sentiments are grouped by paragraph and their frequency is counted.

```r
tbl_par_sentiments <- tbl_words %>%
  inner_join(tbl_sentiment_lexicon, by = "word") %>%
  group_by(id_paragraph, sentiment) %>%
  summarise(qty_sentiment = n())
```

When we look at the occurence of sentiments throughout the book, we see that surprise and fear make place for trust. The idea that Alice will get more used to the absurdities of Wonderland the longer she stays there does make sense.
<a href="/_pages/tutorials/mining-alices-wonderland/sentiment_density.png" target="_blank">
<img src="/_pages/tutorials/mining-alices-wonderland/sentiment_density.png" alt="Sentiment density" width="820" height="457" align="middle"/>
<i class='fa fa-search-plus '></i> Zoom</a>

## Finding characters

To find the appearance of the characters in paragraphs the manually filled vector _personea_ is used with the _tbl_word_ data frame. Only the words that match the personea are kept. These are then grouped by paragraph, and their occurence in the paragraphs is counted.

```r
tbl_par_personea <- tbl_words %>%
  mutate(is_person = word %in% personea) %>%
  filter(is_person) %>%
  select(id_paragraph, persona = word, qty_word) %>%
  group_by(id_paragraph, persona) %>%
  summarise(qty_mentions = sum(qty_word))
```

In the plot below, you can see how Alice, unsurprisingly, plays a big role throughout the book.
<a href="/_pages/tutorials/mining-alices-wonderland/person_appearance.png" target="_blank">
<img src="/_pages/tutorials/mining-alices-wonderland/person_appearance.png" alt="Character appearance" width="780" height="465" align="middle"/>
<i class='fa fa-search-plus '></i> Zoom</a>

## Combining persons and sentiments

Before two data frames we just created, tbl_par_personea and _tbl_par_sentiments_, are joined to find out which sentiments are associated with characters, the total number of mentions of a character in the book are counted without creating an intermediary table. This is achieved by using the _mutate_ function instead of the usual _summarise_ function after the _group_by_ function. After the sentiments are matched with the characters by paragraphs, the number of sentiment occurrences are summed per character-sentiment combinations. After this the _ungroup_ function is called to be able to do further grouping. The total sum of sentiment occurences per character is summed to calculate the relative frequency of sentiments. To ensure we have all sentiments are represented for each character we add all missing sentiments with the great _complete_ function. The first argument in this function specifies which group we want to complete (the characters), then we specify which unique values we want to fill put when missing by using the _sentiment_ variable within the _nesting_ function. In the _fill_ parameter we specify the values we want to give to the variables when the new sentiments are added.

```r
tbl_persona_sentiments <- tbl_par_personea %>%
  group_by(persona) %>%
  mutate(qty_paragraphs = n_distinct(id_paragraph)) %>%
  inner_join(tbl_par_sentiments, by ="id_paragraph") %>%
  group_by(persona, sentiment, qty_paragraphs) %>%
  summarise(qty_sentiments = sum(qty_sentiment)) %>%
  ungroup() %>%
  group_by(persona) %>%
  mutate(qty_sentiment_persona = sum(qty_sentiments)) %>%
  ungroup() %>%
  mutate(perc_sentiments = qty_sentiments/qty_sentiment_persona) %>%
  complete(persona, nesting(sentiment), fill = list(qty_sentiments = 0,
                                                    qty_paragraphs = 0,
                                                    qty_sentiment_persona = 0,
                                                    perc_sentiments = 0))
```

The characters that appear very few times in the book run the risk of having sentiment profiles that are out of whack. They are filtered out:

```r
tbl_persona_significant <- tbl_persona_sentiments %>%
  group_by(persona) %>%
  summarise(qty_sentiments = sum(qty_sentiments)) %>%
  filter(qty_sentiments > 35)
  
tbl_persona_sentiments %<>%
  filter(persona %in% tbl_persona_significant$persona)
```

## A character's sentiment profile

To determine the unqiueness of the sentiment profile we use the lift measure; we will measure how much each sentiment for a character is over- or underrepresented in comparison to alice. So we first put the relative sentiment frequencies of alice in the data frame _tbl_alice_sentiments_ to join them with the sentiments of all characters. Based on the sentiment lift we also calculate another measure, which I'll call impact, that shows how much the sentiment deviates from Alice's profile, irrespective whether it's over or underrepresented. This measure will later be used in the visualisation.

```r
tbl_alice_sentiments <- tbl_persona_sentiments %>%
  filter(persona == "alice") %>%
  select(sentiment, perc_alice = perc_sentiments)
  
tbl_persona_sentiments %<>%
  inner_join(tbl_alice_sentiments, by = "sentiment") %>%
  mutate(lift_sentiment = perc_sentiments / perc_alice) %>%
  mutate(impact = abs(lift_sentiment - 1))
```

In this first attempt to show the sentiment profiles we quickly see it's too crowded:

<a href="/_pages/tutorials/mining-alices-wonderland/person_sentiment_1.png" target="_blank">
<img src="/_pages/tutorials/mining-alices-wonderland/person_sentiment_1.png" alt="Sentiment profile mess" width="780" height="397" align="center"/>
<i class='fa fa-search-plus '></i> Zoom</a>

So facetting the graph by character makes it all removes all clutter. Now we can read all the seperate character profiles and compare them, but where is Plutchik's wheel? To achieve this we're just going to do a bit more.

<a href="/_pages/tutorials/mining-alices-wonderland/sentiment_profiles.png" target="_blank">
<img src="/_pages/tutorials/mining-alices-wonderland/sentiment_profiles.png" alt="Sentiment profile, not the best" width="780" height="397" align="center"/>
<i class='fa fa-search-plus '></i> Zoom</a>

## Building the graph

To draw the sentiment lift on Plutchik's wheel we have to rotate the lift values like we did in drawing the wheel itself for the _plutchik_wheel_ function. Now we have the outer limit on the center of each petal, we also have to get the points of the border of each petal. For that we repeat the previous data frame three times and combine then in one data frame:

* For the left hand border we rotate the value 22.5 degrees counter-clockwise.
* One for the center we keep it as is.
* And for the right hand border we rotate the value 22.5 degrees clockwise.

```r
tbl_sentiment_outline <- rbind(tbl_sentiments %>% mutate(degrees_sentiment = degrees_sentiment - 22.5),
                               tbl_sentiments,
                               tbl_sentiments %>% mutate(degrees_sentiment = degrees_sentiment + 22.5))
```

Rotate petals of each sentiment lift so the coordinates correspond to the sentiment

```r
tbl_sentiment_petal <- tbl_persona_sentiments %>%
  inner_join(tbl_sentiment_outline, by = "sentiment") %>%
  mutate(x_base = cos(degrees_sentiment * pi/180),
         y_base = sin(degrees_sentiment * pi/180),
         x_lift = lift_sentiment * cos(degrees_sentiment * pi/180),
         y_lift = lift_sentiment * sin(degrees_sentiment * pi/180))
```

Set the points of forming each petal so they line up (base and lift) and draw a polygon

```r
tbl_sentiment_petal <- rbind(tbl_sentiment_petal %>%
                               mutate(point_order = degrees_sentiment + 45) %>%
                               select(persona, sentiment, point_order, impact, x = x_lift, y = y_lift),
                             tbl_sentiment_petal %>%
                               mutate(point_order = -1 * (degrees_sentiment + 45)) %>%
                               select(persona, sentiment, point_order, impact, x = x_base, y = y_base)) %>%
                       arrange(persona, sentiment, point_order)
```

Determing sentiment circle radius

```r
max_radius <- max(sqrt(tbl_sentiment_petal$x ^ 2 + tbl_sentiment_petal$y ^ 2))
```

Drawing the wheel and stacking the sentiment petals unto it

```r
plutchik_wheel(max_radius) +
  geom_polygon(data = tbl_sentiment_petal, aes(x, y, col = persona, group = sentiment, alpha = impact), fill = "slategrey") +
  geom_point(data = tbl_person_center, aes(x = x_center, y = y_center, col = persona))  +
  facet_wrap(~persona, ncol = 5) +
  scale_color_manual(values = personea_colors) +
  scale_fill_manual(values = plutchik_colors) +
  guides(col = FALSE) +
  labs(list(alpha = "Impact"))
```

# The Result

<a href="/_pages/tutorials/mining-alices-wonderland/sentiment-wheels.png" target="_blank">
<img src="/_pages/tutorials/mining-alices-wonderland/sentiment-wheels.png" alt="Sentiment profile" width="780" height="397" align="center"/>
<i class='fa fa-search-plus '></i> Zoom</a>


## And a stupid version

I'm not sharing all stupid thoughts I had creating this, but one stands out in it's simplicity and could not resist showing it.
When I first thought of drawing the wheel, I thought I'd draw spider graphs on it. Then I quickly realised it would become too crowded for interpretation. Then I thought I could just as well take the center of gravity for each spider graph. After struggling to do this I finally realised you can not take a mean of the sentiments. When you look at the wheel you quickly realise that fear is not the opposite of anger, nor is surprise of anticipation and so on. None the less I'll explain the process of making this non-sensical chart.

First we're going to isolate person center of gravity by calculating the x and y coordinates of each sentiment lift. Then we'll calculate the center of gravity of a spider graph by taking the mean of x coordinates and y coordinates.

```r
tbl_person_center <- tbl_persona_sentiments %>%
  inner_join(tbl_sentiments, by = "sentiment") %>%
  mutate(x_lift = lift_sentiment * cos(degrees_sentiment * pi/180),
         y_lift = lift_sentiment * sin(degrees_sentiment * pi/180)) %>%
  group_by(persona) %>%
  summarise(x_center = mean(x_lift),
            y_center = mean(y_lift))
```

Determing sentiment circle radius

```r
max_radius <- max(sqrt(tbl_person_center$x_center ^ 2 + tbl_person_center$y_center ^ 2)) * 1.2
```

The ggplot of profiles

```r
plutchik_wheel(max_radius) +
  geom_point(data = tbl_person_center, aes(x = x_center, y = y_center, col = persona)) +
  geom_label_repel(data = tbl_person_center,
                   aes(x_center, y_center, label = persona),
                   alpha = 0.6,
                   fill = "white",
                   color = 'black',
                   segment.color = "black"
  ) +
  scale_color_manual(values = personea_colors) +
  guides(col = FALSE)
```
<a href="/_pages/tutorials/mining-alices-wonderland/sentiment-centers.png" target="_blank">
<img src="/_pages/tutorials/mining-alices-wonderland/sentiment-centers.png" alt="Sentiment centers" width="100%" height="100%" align="center"/>
<i class='fa fa-search-plus '></i> Zoom</a>


The total script can be downloaded from [here](https://gist.github.com/mark-me/d080979ce8beb595faf1dcab38b6e392)
