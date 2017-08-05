---
layout: page
title: Creating your own project template
permalink: /project-template/
---

A lot of times you are using the same stuff doing the same things across projects. Wouldn't it be nice if a lot of this could be done by default? It would save you time and bring consistency in your projects. In this tutorial I'll show how to use a script that makes a template for this. I'll also show you what is in the script so you can adapt it to suit your own needs.

# What the script does

In this script the main function is open-project. When you call this function it will do the following in the file system:

1.  Create a base directory for the project
2.  Within this directory create sub directories for:
    *   Input - a directory for all input data
    *   Output data - a directory where you put the output of your analysis data checks.
    *   Presentation - assuming you want to make a presentation, you can put all presentation related stuff in here
3.  A script called main.r which you can use that the basis of your project.

In R itself it will:

1.  Create variables you can use when referring to in/output files or other scripts:
    *   _dir_input_ - Directory containing input files
    *   _dir_output_data_ - Directory containing script output
    *   _dir_project_ - Base directory of the project
2.  Loads libraries, and will install them when they're not available on your system.
3.  Creates some functions that I thought were handy
    *   _df_to_clipboard()_ - this function allows you you copy data-frames to your clipboard so they can easily be pasted in Excel.
    *   _format_euro_currency()_ – converts a number to a string formatted euro-style.
    *   _format_number()_ - converts the number to a presentable number (with dots and commas in the right places (at least: when you live in the correct region).
    *   _ggchis_mosaic()_ - A mosaic plot incorporating a Chi-squared test, I commonly use to express differences between groups. I want to thank Rick Scavetta of [Science Craft](http://www.science-craft.com/) for his wonderful course at [DataCamp](https://www.datacamp.com/courses/data-visualization-with-ggplot2-2) where I got this plot from.

# Saving the script

To start off with you can [save the project.r script](https://github.com/mark-me/The-R-Pages/blob/master/project.r) in your the default working directory. If you have no idea what I'm talking about you can find this through the options screen: ![working_directory_setting](https://markzwart.files.wordpress.com/2017/05/working_directory_setting.png) Probably your default working directory is different than mine. The ~ sign refers to the home directory. In Windows the home directory is not a familiar concept, but is is the My Documents directory instead. If you're a control freak like me, you want a different working directory than the default. If you have chosen another than the default you should also adjust the script to make it work. For an explanation if <span style="color:#ff0000;">TODO</span>

# Creating a project

To create a project you start by opening and executing the project.r file. By doing this you make the function _open_project_ available. You can then execute this function by passing two values to it:

*   The name of the project
*   The sub directory for your the project base directory and sub directories

Let's say I want to create a project called 'Test project' in the sub directory 'R Scripts' of my default working directory. This would translate in the following function call: [code lang="r"]open_project("Test project", "~/R Scripts")[/code] Now the directories are created, and a script called 'main.r' is put in the project base directory '~/R Scripts/Test project'.

# Using your project

You can start using your project by opening the main.r file. You can give the file any name you want. When you open the file you'll see the following two statements: [code lang="r"] source("~/R Scripts/project.r") # Loads and executes project script open_project("Test project", "~/R Scripts") # Creates standard variables and functions [/code] The _open_project()_ call will not create file file this time, but just open it. Now you can start by creating your project within this file.

## Reading and writing data

When you read input files, such as CSV files, you can use the _paste0()_ function to create a file string like so: [code lang="r"] paste0(dir_input, "/", "filename.csv") [/code]

# Explaining the script
