---
layout: page
title: Importing and exporting data
comments: true
permalink: /importing-exporting/
---

* TOC 
{:toc}

# Flat files

## readr

For quite some time I've used the _read.csv_, _read.csv2_, _read.table_ functions and the like from the **[utils](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/00Index.html)** library. But recently I found the **[readr](https://www.rdocumentation.org/packages/readr)** library with comparable functions, but with much faster file processing, more intelligence in column type guessing (including date/time) and more 'graceful' failing when some of the type guessing does not the desired effect. Another plus point is that the function returns a [tibble](/data-types/#data-structures) instead of a data frame.

There are 7 flat file reading functions in this library, but the 4 I will most likely use are:

* _read_csv_ and _read_csv2_ - comma separated (CSV) files, for the American and European standards respectively.
* _read_tsv_ - tab separated files
* _read_delim_ - generic function for delimited files, which gives you most control.
* _read_fwf_ - fixed width files

The 'graceful' failing is very useful: it gives me a good way to debug importing, which is a problem that always seems to hount me. Next to the imported data, the returned tibble also contains data about the guessed column types and the problems it encountered during processing. It stores this data in the [attributes](/data-types/#extra-metadata) "spec" and "problems". You can find out what these are by giving the commands (assuming the import was done to the data frame _df_):
```r
attr(df, "spec") 
attr(df, "problems")
```
Mostly my problem revolves around too little scanning while guessing the column type. You can adjust how many rows any of the **readr** functions takes into consideration when guessing by passing a value larger than 1000 to the _guess_max_ parameter.

# Excel

## openxlsx

The **[openxlsx](https://www.rdocumentation.org/packages/openxlsx/)** library does not depend on Java (which others do), but might require some extra steps to transform dates. Reading an Excel file is done like this:
```r
tbl_iris <- read.xlsx("iris.xlsx", sheet = 1)
```
Empty rows and columns are skipped automatically. The default sheet read is the first, you can change this by passing and index or sheetname to the _sheet_ parameter.

And writing:
```r
write.xlsx(iris, "iris.xlsx")
```
Now when you do this for the first time in a Windows environment it could be telling you zipping up the workbook fails. It fails because it can't find a zipping tool. Luckily R Studio provides a whole range of utilities, inclusing this. You can install these, along with the 'zip' tool by executing: 
```r
installr::install.rtools()
```
This will launch an installer for which you shouldn't need any administrative rights. The installer will put the tools within the c:\Rtools directory. I'm assuming that, like me, you took the default option, if not, make sure you edit the following statement, which should be added to your script to be able to save _xlsx_ files. 
```r
Sys.setenv("R_ZIPCMD" = "c:/Rtools/bin/zip.exe")
```

## XLConnect

The **[XLConnect](https://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf)** library is dependent on Java. Make sure you have a Java installed that is the same bit version (32/64 bit) as the R server you're using. When using Excel files, you first have to connect to the file. For example: 
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
df_to_clipboard <- function(df, row.names = FALSE, col.names = TRUE, ...) {
    write.table(df, "clipboard-16384", sep = "\t",
      row.names = row.names,
      col.names = col.names,
      ...
    )
  }
``` 
and using it like this
```r
df_to_clipboard(data_frame)
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

Most of the time, all data called in a script is loaded and calculated on the fly. But sometimes, when handling especially large data sets that seldom change, it might be preferable to store data in temporary files that are quick to access and came fully transformed beforehand. 

## fst files

The fst library is one of the candidates comes in handy. The **[fst](http://www.fstpackage.org/)** library enables you to save data from R in a binary format that loads really quickly, and loads that data fully R prepared Writing fst files is done with (where 100 is the compression rate (0 is not compression, 100 is most compressed)): 
```r
write.fst(data_frame, "file_name.fst", 100)
```
Reading fst files (and immediate conversion to _tbl_): 
```r
data_frame <- tbl_df(read.fst("file_name.fst"))
```
The current version (writing this on September 6th, 2017), the CRAN version has a bug where dates are saved as numbers (the developer has fixed this), which made me switch to the RDS format which is part of the R base.

## RDS files

A native format for storing objects quickly is RDS. You can write a (compressed) file like this:
```r
saveRDS(data_frame, "file_name.RDS")
```
Reading it:
```r
data_frame <- readRDS("file_name.RDS")
```

# Transforms on import

## Cleaning column names

Often times the column names of a file are messy; they contain '?', '%', spaces or other strange signs. With the **[janitor](https://www.rdocumentation.org/packages/janitor)** library you can fix this in one command by calling the _clean_names_ function. This function, which is can be used by piping the data frame through the function, will convert all strange signs to underscored, and will make all letters lower case.

## Removing blank columns and rows

Excel sheets have a tendency to contain empty rows and/or colums. The **janitor** library also has two handy functions to fix this: _remove_empty_rows_ and _remove_empty_cols_. If we combine the three above functions it would look something like this:
```r
tbl_imported %<>%
  clean_names() %>%
  remove_empty_rows() %>%
  remove_empty_cols() 
```

# Date conversion

The **[lubridate](https://www.rdocumentation.org/packages/lubridate)** library is fantastic for date/time handling. Functions like _ymd_, _dmy_, _mdy_ and the like make converting string dates to real date or time formats a breeze. But recently I had a case that left me stumped: most dates converted in the formated like 01JAN1823 convereted like a gem, except all dates falling in the months March, May and October... What the hell is going on here? After doing all kinds of stupid workarounds, with too much code for my taste, it finally dawned on me: in my langauge, Dutch, the three months are the only ones having a different abbreviation that English... Looking at the help page I found out the conversion functions take the system locale as default, but it could be overridden by using the function's _locale_ argument:
```r
dmy(date_start, locale = Sys.setlocale("LC_TIME", "English") )
```
Now my previous NA results for the three months finally resulted in dates.
