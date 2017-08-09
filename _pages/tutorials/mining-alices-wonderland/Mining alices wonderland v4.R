# Loading libraries ----
library(tidyverse)
library(gutenbergr)
library(tidytext)
library(stringr)
library(ggplot2)
library(ggthemes)
library(ggrepel)
library(magrittr)
library(wordcloud2)

# Characters ----
personea <- c("alice", "queen", "king", "rabbit", "turtle", "gryphon", "hatter", "dormouse", "cat", "duchess",
              "caterpillar", "mouse", "cook", "hare", "knave", "mouse", "dodo", "pigeon", "bill", "frog-footman") 
personea_colors <- c("#771155", "#AA4488", "#CC99BB", "#114477", "#4477AA", "#77AADD", "#117777", "#44AAAA", 
                     "#77CCCC", "#117744", "#44AA77", "#88CCAA", "#777711", "#AAAA44", "#DDDD77", "#774411", 
                     "#AA7744", "#DDAA77", "#771122", "#AA4455", "#DD7788")

# Sentiments data-set ----
sentiment_order <- c("fear", "trust", "joy", "anticipation", "anger", "disgust", "sadness", "surprise")
degrees_sentiment <- c(0, 45, 90, 135, 180, 225, 270, 315)
tbl_sentiments <- data.frame(sentiment_order, degrees_sentiment)
tbl_sentiments %<>%
  rename(sentiment = sentiment_order) %>% 
  mutate(sentiment = factor(sentiment, levels = sentiment_order, ordered = TRUE))
rm(degrees_sentiment)

# Hex codes for coloring the wheel ----
plutchik_colors <- c( "#8cff8c", "#ffffb1", "#ffc48c", "#ff8c8c", "#ffc6ff","#8c8cff", "#a5dbff", "#8cc68c")

# Function that returns a ggplot of the Plutchik wheel ----
plutchik_wheel <- function(radius) {
  id <- as.factor(rep(c(1:8), each = 5))  # Grouping of the polygon by petal
  petal <- rep(c(0, 1:3, 0), 8)           # 
  petal_transpose <- rep(c(0, 2, 2, 2, 0), 8) * rep(c(0:7), each =5)
  radian_petals <- (petal + petal_transpose) * 22.5 * pi/180
  emotions <- factor(c( NA, NA, "Trust", NA, NA, NA, NA, "Joy", NA, NA, NA, NA, "Anticipation", NA, NA, NA, NA, "Anger", NA, NA, NA, NA, "Disgust", NA, NA, NA, NA, "Sadness", NA, NA, NA, NA, "Surprise", NA, NA, NA, NA, "Fear", NA, NA ), levels = c("Trust", "Joy", "Anticipation", "Anger", "Disgust", "Sadness", "Surprise","Fear"), ordered = TRUE)
  x <- radius * (petal > 0) * cos(radian_petals)  # Calculate x coordinates
  y <- radius * sin(radian_petals)                # Calculate y coordinates 

  tbl_plutchik_wheel <- data.frame(id, x, y, emotions)
  
  wheel <- ggplot() + 
    geom_polygon(data = tbl_plutchik_wheel, aes(x, y, fill=id, group=id), alpha = 0.8) +
    geom_text(data = tbl_plutchik_wheel, aes(x, y, label = emotions), size = 3) +
    scale_fill_manual(values = plutchik_colors) +
    guides(fill = FALSE) +
    theme(
      axis.line = element_blank(), 
      axis.text.x = element_blank(), 
      axis.text.y = element_blank(),
      axis.ticks = element_blank(), 
      axis.title.x = element_blank(), 
      axis.title.y = element_blank(), 
      panel.background = element_rect(fill = "white"),
      strip.background = element_rect(color = "black", fill="white", size = 0.1)
    ) 
  
  return(wheel)
}

# Excel-like proper function for fixing names
proper <- function(text) {
  paste0(toupper(str_sub(text, 1, 1)), str_sub(text, 2))
}

# Downloading the book ----
book_alice <- gutenberg_download(11)

# Split the book in paragraphs ----
tbl_paragraphs <- book_alice %>% 
  mutate(line = row_number()) %>%
  filter(line >= 10 & line < 3338) %>%            # Skipping irrelevant lines
  mutate(is_chapter_title = str_detect(text, "CHAPTER")) %>%  # Detect chapter titles
  mutate(qty_words = sapply(gregexpr("[[:alpha:]]+", text), function(x) sum(x > 0))) %>% # Count words in a line 
  mutate(is_paragraph = !is_chapter_title & qty_words > 0)      # Mark lines that are not chapter titles and contain words as part of a sections

# Use rle function to find consecutive is_paragraph groups
tbl_paragraph_id <- data.frame(length = rle(tbl_paragraphs$is_paragraph)[[1]], 
                             value = rle(tbl_paragraphs$is_paragraph)[[2]])

# Add paragraph id to each paragraph
tbl_paragraphs %<>% 
  mutate(id_paragraph = rep(seq(1,nrow(tbl_paragraph_id),1), tbl_paragraph_id$length)) %>% 
  mutate(id_paragraph = ifelse(is_paragraph, id_paragraph, NA))

rm(tbl_paragraph_id)

# Use nrc lexicon
tbl_sentiment_lexicon <- sentiments %>% 
  filter(sentiment != "negative" & sentiment != "positive") %>%
  filter(lexicon == "nrc") %>%
  select(word, sentiment) %>%
  mutate(sentiment = as.character(sentiment)) %>% 
  mutate(sentiment = factor(sentiment, levels = sentiment_order, ordered = TRUE))

# Retrieve words from paragraphs ----
tbl_words <- tbl_paragraphs %>%
  unnest_tokens(word, text) %>%                         # Make a new row for each words encountered in the text
  anti_join(stop_words, by = "word") %>%                # Remove stop words 
  filter(word != "illustration") %>%                    # Remove all words that are references to figures
  mutate(word = str_extract(word, "[a-z']+")) %>%       # Get only words that consists only of characters
  group_by(id_paragraph, word) %>% 
  summarise(qty_word = n())                             # Count the frequency of words

# Wordcloud ----
tbl_word_freq <- tbl_words %>% 
  mutate(is_person = word %in% personea) %>%            # Mark words that are characters
  filter(!is_person) %>% 
  group_by(word) %>% 
  summarise(freq = sum(qty_word))

setwd("/home/mark/Downloads/Dropbox/Werk/R Scripts/Alice in Wonderland")

wordcloud2(data.frame(tbl_word_freq), figPath = "chesire-cat.png", size = 1.5, color = "black")

rm(tbl_word_freq)
  
# Paragraph persona relations ----
tbl_par_personea <- tbl_words %>%
  mutate(is_person = word %in% personea) %>%            # Mark words that are characters
  filter(is_person) %>% 
  select(id_paragraph, persona = word, qty_word) %>% 
  group_by(id_paragraph, persona) %>% 
  summarise(qty_mentions = sum(qty_word))

# Ordering persons by their first menation in the book
personea_order <- (tbl_par_personea %>% 
                     filter(!is.na(id_paragraph)) %>% 
                     group_by(persona) %>% 
                     summarise(id_paragraph_first = min(id_paragraph)) %>%
                     arrange(id_paragraph_first))$persona

# Applying that order to the persona factor
tbl_par_personea %<>% 
  ungroup() %>% 
  mutate(persona = gdata::reorder.factor(persona, new.order=personea_order))

rm(personea_order)
  
# Graph showing the persona's appearance throughout the book ----
tbl_par_personea %>% 
  filter(!is.na(id_paragraph)) %>% 
  ggplot(aes(x = id_paragraph, y = 1, col = persona)) + 
    geom_point(alpha = 0.4) +
    facet_grid(persona ~ ., switch = "y") +
    labs(list( x = "Paragraph", y = "")) +
    scale_color_manual(values = personea_colors) +
    guides(col = FALSE) + 
    theme(strip.text.y = element_text(angle=180),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.major.y=element_blank(),
          panel.grid.minor.y=element_blank())

# Paragraph sentiments relations ----
tbl_par_sentiments <- tbl_words %>% 
  inner_join(tbl_sentiment_lexicon, by = "word") %>% 
  group_by(id_paragraph, sentiment) %>%
  summarise(qty_sentiment = n())

# Graph showing the sentiments throughout the book ----
tbl_par_sentiments %>% 
  filter(!is.na(id_paragraph)) %>%
  group_by(id_paragraph) %>%
  mutate(perc_semtiment = qty_sentiment/sum(qty_sentiment)) %>% 
  ggplot(aes(x = id_paragraph, weight = perc_semtiment, col = sentiment, fill = sentiment)) + 
    geom_density(alpha = 0.4, position = "fill") +
    #geom_label(aes(x = mean(id_paragraph), y = perc_semtiment, label = factor(sentiment))) +
    labs(list(x = "Paragraph", y = "% of paragraph", fill = "Sentiment")) +
    scale_color_manual(values = plutchik_colors) +
    scale_fill_manual(values = plutchik_colors) +
    guides(col = FALSE) + 
    theme(strip.text.y = element_text(angle=180),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          panel.background = element_rect(fill = NA),
          panel.grid.major = element_line(colour = "grey"),
          panel.grid.major.y=element_blank(),
          panel.grid.minor.y=element_blank())

# Combining the persons and sentiments ----
tbl_persona_sentiments <- tbl_par_personea %>% 
  group_by(persona) %>% 
  mutate(qty_paragraphs = n_distinct(id_paragraph)) %>% 
  inner_join(tbl_par_sentiments, by ="id_paragraph")  %>% # Join sentiments with persons
  group_by(persona, sentiment, qty_paragraphs) %>% 
  summarise(qty_sentiments = sum(qty_sentiment)) %>% 
  ungroup() %>% 
  group_by(persona) %>% 
  mutate(qty_sentiment_persona = sum(qty_sentiments)) %>% 
  ungroup() %>% 
  mutate(perc_sentiments = qty_sentiments/qty_sentiment_persona) %>% 
  complete(persona, 
           nesting(sentiment), 
           fill = list(qty_sentiments = 0, qty_paragraphs = 0, qty_sentiment_persona = 0, perc_sentiments = 0))

tbl_persona_significant <- tbl_persona_sentiments %>% 
  group_by(persona) %>% 
  summarise(qty_sentiments = sum(qty_sentiments)) %>% 
  filter(qty_sentiments > 35)

tbl_persona_sentiments %<>% 
  filter(persona %in% tbl_persona_significant$persona)

rm(tbl_persona_significant)

# Calculate the lift in comparison to Alice ----
tbl_alice_sentiments <- tbl_persona_sentiments %>%
  filter(persona == "alice") %>% 
  select(sentiment, perc_alice = perc_sentiments)
  
tbl_persona_sentiments %<>% 
  inner_join(tbl_alice_sentiments, by = "sentiment") %>% 
  mutate(lift_sentiment = perc_sentiments / perc_alice) %>% 
  mutate(impact = abs(lift_sentiment - 1))

# Graph lines persona emotions ----
ggplot(tbl_persona_sentiments, aes(x = sentiment, y = lift_sentiment, col = persona)) +
  geom_point() +
  geom_line(aes(group = persona)) +
  scale_color_manual(values = personea_colors) +
  labs(list(x = "Sentiment", y = "Sentiment lift", col = "Persona")) +
  facet_wrap(~persona, ncol = 3) +
  guides(col = FALSE) +
  theme(panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey"))

# Drawing the Plutchick wheel with sentiment profiles ----

# Repeat sentiment 3 times for the middle and border points of a sentiment
tbl_sentiment_outline <- rbind(tbl_sentiments %>% mutate(degrees_sentiment = degrees_sentiment - 22.5),
                               tbl_sentiments,
                               tbl_sentiments %>% mutate(degrees_sentiment = degrees_sentiment + 22.5))

# Rotate petals of each sentiment lift so the coordinates correspond to the sentiment
tbl_sentiment_petal <- tbl_persona_sentiments %>% 
  inner_join(tbl_sentiment_outline, by = "sentiment") %>% 
  mutate(x_base = cos(degrees_sentiment * pi/180),
         y_base = sin(degrees_sentiment * pi/180),
         x_lift = lift_sentiment * cos(degrees_sentiment * pi/180),
         y_lift = lift_sentiment * sin(degrees_sentiment * pi/180)) 

# Set the points of forming each petal so they line up (base and lift) and draw a polygon
tbl_sentiment_petal <- rbind(tbl_sentiment_petal %>% 
                              mutate(point_order = degrees_sentiment + 45) %>% 
                              select(persona, sentiment, point_order, impact, x = x_lift, y = y_lift),
                            tbl_sentiment_petal %>% 
                              mutate(point_order = -1 * (degrees_sentiment + 45)) %>% 
                              select(persona, sentiment, point_order, impact, x = x_base, y = y_base)) %>% 
                        arrange(persona, sentiment, point_order)

# Determing sentiment circle radius 
max_radius <- max(sqrt(tbl_sentiment_petal$x ^ 2 + tbl_sentiment_petal$y ^ 2)) 

# The ggplot of profiles
plutchik_wheel(max_radius) +
  geom_polygon(data = tbl_sentiment_petal, aes(x, y, col = persona, group = sentiment, alpha = impact), fill = "slategrey") +
  geom_point(data = tbl_person_center, aes(x = x_center, y = y_center, col = persona))  +
  facet_wrap(~persona, ncol = 5) +
  scale_color_manual(values = personea_colors) + 
  scale_fill_manual(values = plutchik_colors) + 
  guides(col = FALSE) +
  labs(list(alpha = "Impact")) 

# Drawing the Plutchick wheel with sentiment centers ----
# Isolate person centers
tbl_person_center <- tbl_persona_sentiments %>%
  inner_join(tbl_sentiments, by = "sentiment") %>% 
  mutate(x_lift = lift_sentiment * cos(degrees_sentiment * pi/180),
         y_lift = lift_sentiment * sin(degrees_sentiment * pi/180)) %>% 
  group_by(persona) %>% 
  summarise(x_center = mean(x_lift), 
            y_center = mean(y_lift))

# Determing sentiment circle radius 
max_radius <- max(sqrt(tbl_person_center$x_center ^ 2 + tbl_person_center$y_center ^ 2)) * 1.2

# The ggplot of profiles
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

