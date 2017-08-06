---
layout: page
title: Script structuring
permalink: /script-structuring/
---
# Marking sections in a script

When R scripts become longer, you'll find you want to make subdivisions in the scripts so you can easily navigate it, avoiding endless scrolling. You can mark sections by creating a section by starting a comment like normal (#), typing a section tile and following that by a series of '-' signs like this:

```r 
# Section title -------
```

This allows you to fold your code (hide code, showing only the section header), or jump through the script Code folding: 
![code_folding](/snippets-and-tips/code_folding.png) 
![code_folding2](/snippets-and-tips/code_folding2.png) 

Section navigation: 
![code_navigation](/snippets-and-tips/code_navigation.png)

# Calling scripts from scripts

Whenever you tend to re-use script in several instances, you might want to place it in a seperate file you can call from within the script you intend to execute. You can call a script using the _source(filename)_ function For example this could be employed when you create multiple analysis scripts on the same set of input files. Frequently, reading and transforming data is generic for all analyses: data needs to be read and transformed to it meets R needs: dates need to be R dates, numbers need to be recognized as such, values might need to be factored, empty values need to be handled and so on. It makes sense to put all this data-set related statements in a separate script. Calling the script in the analysis script will result in the creation of variables, data-sets and functions so they are made available in the analysis script itself.

# Setting working directories

When working on a project, you probably want all your files to be in a folder you made for that project. If you set the working directory in a script, all following file calls are presumed to be files within that directory.

*   _setwd(dir)_ - setting the working directory
*   _getwd()_ - getting the current working directory

The default directory is your 'My Documents' directory. When changing the working directory, keep in mind that R uses foward slashes (/) instead of the Windows standard of backward slashes (\). If the working directory is a subfolder of your 'My documents' folder use the ~ as the start of your working directory call to _setwd_; in this way other users can use the exact replica of the script as long as they use the same folder conventions. And example:

```r
setwd("~/R scripts/My Project/")
```
