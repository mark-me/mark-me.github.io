---
layout: page
title: Importing and exporting data
comments: true
permalink: /importing-exporting/
---

* TOC 
{:toc}

# Excel

Accessing Excel files can be done using the **[XLConnect](https://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf)** library. The library depends on Java. Make sure you have a Java installed that is the same bit version (32/64 bit) as the R server you're using. When using Excel files, you first have to connect to the file. For example: 

```r
data_book <- loadWorkbook("data-file.xlsx")
```
Reading a worksheet can be done like so: 

```r
tbl_data <- tbl_df(readWorksheet(data_book, sheet = "Data"))
```

## Copying data frames into Excel

Especially when I began using R, I sometimes had to fall back on Excel to do some quick checks. You can put data frames (or tbls) on the clipboard by creating this function: 

```r
write_clipboard <- function(x,row.names=FALSE,col.names=TRUE,...) {
  write.table(x,"clipboard",sep="\t",row.names=row.names,col.names=col.names,...) 
} 
``` 
and using it like this

```r
write_clipboard(data_frame)
```

# Twitter

You can scrape Twitter using R by making use to the **[twitteR](https://www.rdocumentation.org/packages/twitteR)** library. First you have to get authentication tokens for your Twitter account. Don't ask me how to do that anymore, lost in the mists that I call memory,but you should be able to find out yourself. Using that token information you should first set up authentication, like this: 

```r
api_key <- "Xx89asxcsdjy48k" 
api_secret <- "ASG789sf7d6sfhjJashjkskL0IS90aiSjklsa" 
access_token <- "ydyshjkgfhsdgfr78ETFDHVXCHZUXT6AER5WERQ2U" 
access_token_secret <- "93478023RHDASJKF7tGHJh8odqsghksdjsdfht7t" 
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)
```

After which you can retrieve tweets: 

```r
tweets <- searchTwitter("Trump", n=400, lang="nl")
```

The searchTwitter function returns the data in a difficult to read list format. This can be changed to an easy to use data frame like so: 

```r
df_tweet <- twListToDF(tweets)
```

After this, read up on the subject of [Text mining](#TheRPages-Textmining) you can display tweet content in Word clouds.

# Google Sheets

With the library **[googlesheets](https://cran.r-project.org/web/packages/googlesheets/vignettes/basic-usage.html)** you can access... Google sheets. After you've loaded the library gain access to your Google Drive by issueing the command that gives a file listing of all the files you have in your google drive: 

```r
(google_sheets <- gs_ls())
```

This opens the browser where it asks you to grant permission for R to access your Google Drive. After you've confirmed you'll get a list with all the Sheet files. You can open one of these using: 

```r
sheet <- gs_title("file name")
```

You can read a sheet's data by using: 

```r
tbl_sheet <- gs_read(sheet, ws = "sheet name")
```

where ws can be used to reference a sheet by index or by name (the above example is done by name).

# Temporary files

Most of the time, all data called in a script is loaded and calculated on the fly. But sometimes, when handling especially large data sets that seldom change, it might be preferable to store data in temporary files that are quick to access and came fully transformed beforehand. This is when the fst library comes in handy. The **[fst](http://www.fstpackage.org/)** library enables you to save data from R in a binary format that loads really quickly, and loads that data fully R prepared Writing fst files is done with: 

```r
write.fst(data frame, "file_name.fst", 100)
```

Reading fst files (and immediate conversion to _tbl_):where 100 is the compression rate (0 is not compression, 100 is most compressed)

```r
tbl_df(read.fst("file_name.fst"))
```

# Standard transforms on import

Often times the column names of a file are messy; they contain '?', '%', spaces or other strange signs. With the **[janitor](https://www.rdocumentation.org/packages/janitor)** library you can fix this in one command by calling the _clean_names_ function. This function, which is can be used by piping the data frame through the function, will convert all strange signs to underscored, and will make all letters lower case.

Excel sheets have a tendency to contain empty rows and/or colums. The **janitor** library also has two handy functions to fix this: _remove_empty_rows_ and _remove_empty_cols_. If we combine the three above functions it would look something like this:

```r
tbl_imported %<>%
  clean_names() %>%
  remove_empty_rows() %>%
  remove_empty_cols() 
```
