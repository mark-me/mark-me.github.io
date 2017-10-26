---
layout: page
title: Statistical tests for ordinal variables
comments: true
permalink: /statistical-tests-ordinal/
---

## Descriptive

Sometimes you just want to describe one variable. Although these types of descriptions don't need statistical tests, I'll describe them here since they should be a part of interpreting the statistical test results. Statistical tests say whether they change, but descriptions on distibutions tell you in what direction they change.

### Ordinal median

The median, the value or quantity lying at the midpoint of a frequency distribution, is the appropriate  central tendency measure for ordinal variables. Ordinal variables are implemented in R as factor ordered variables. Strangely enough the standard R function _median_ doesn't support ordered factor variables, so here's a function that you can use to create this:
```r
median_ordinal <- function(x) {
  d <- table(x)
  cfd <- cumsum(d / sum(d))
  idx <- min(which(cfd >= .5))
  return(levels(x)[idx])
}
```
Which you can use on the [diamond](http://ggplot2.tidyverse.org/reference/diamonds.html) dataset from the **ggplot2** library on it's cut variable, which has the following distribution: 

| cut |n()  | prop | cum_prop |
| --- | --: | ---: | ------:  |
| Fair | 1.610 | 3% | 3% |
| Good| 4.906 | 9% | 12% |
| Very Good | 12.082 | 22% | 34% |
| Premium | 13.791 | 26% | 60% |
| Ideal | 21.551| 40% | 100% |

With this distribution I'd expect the **Premium** cut would be the median. Our function call,
```r
median_ordinal(diamonds$cut)
```
shows extactly that:
```
[1] "Premium"
```

### Ordinal interquartile range

The [InterQuartile Range](https://en.wikipedia.org/wiki/Interquartile_range) (IQR) is implemented in the _IQR_ function from base R, like it's _median_ counterpart, does not work with ordered factor variables. So again, we're out on our own again to create a function for this:
```r
IQR_ordinal <- function(x) {
  d <- table(x)
  cfd <- cumsum(d / sum(d))
  idx <- c(min(which(cfd >= .25)), min(which(cfd >= .75)))
  return(levels(x)[idx])
}
```
This returns, as expected:
```
[1] "Very Good" "Ideal" 
```

## One sample

One sample tests are done when you want to find out whether your measurements differ from some kind of theorethical distribution. For example: you might want to find out whether you have a dice that doesn't get the random result you'd expect from a dice. In this case you'd expect that the dice would throw 1 to 6 about 1/6th of the time.

### Wilcoxon one sample test

<img src="/_pages/tutorials/statistical-tests/diamonds-are-forever.jpg" width="136" height="180" align="right"/>

With the Wilcoxon one sample test, you test whether your ordinal data fits an hypothetical distribution you’d expect. In this example we'll examine the _diamonds_ data set included in the **ggplot2** library. We'll test a hypothesis that the diamond cut quality is centered around the middle value of "Very Good" (our null hypothesis). First let's see the total number of factor levels of the cut quality:
```r
library(ggplot2)
levels(diamonds$cut)
```
Output:
```
[1] "Fair"      "Good"      "Very Good" "Premium"   "Ideal"
```
The r function for the Wilcoxon one-sample test doesn't take non-numeric variables. So we have to convert the vector cut to numeric, and 'translate' our null hypothesis to numeric as well. As we can derive from the _level_ function's output the value "Very Good" corresponds to the number 3. We'll pass this to the _wilcox.test_ function like this:
```r
wilcox.test(as.numeric(diamonds$cut), 
            mu=3,
            conf.int=TRUE ) 
```	 
Output:
```
	Wilcoxon signed rank test with continuity correction

data:  as.numeric(diamonds$cut)
V = 781450000, p-value < 2.2e-16
alternative hypothesis: true location is not equal to 3
95 percent confidence interval:
 4.499983 4.499995
sample estimates:
(pseudo)median 
      4.499967
```
We can see that our null hypothesis doesn't hold. The diamond cut quality doesn't center around "Very Good". Somewhat non-sensical we also passed TRUE to the argument _conf.int_, to the function, but this also gave the pseudo median, so we are able to interpret what the cut quality does center around: "Premium" (the level counterpart of the numeric value 4.499967).

## Two unrelated samples

Two unrelated sample tests can be used for analysing marketing tests; you apply some kind of marketing voodoo to two different groups of prospects/customers and you want to know which method was best. 

### Mann-Whitney U test

The [Mann–Whitney U test](https://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test) can be used to test whether two sets of unrelated samples are equally distributed. Let's take our trusted **mtcars** data set: we can test whether automatic and manual transmission cars differ in gas mileage. For this we use the _wilcox.test_ function:
```r
wilcox.test(mpg ~ am, data=mtcars)
```
Output:
```
        Wilcoxon rank sum test with continuity correction 
 
data:  mpg by am 
W = 42, p-value = 0.001871 
alternative hypothesis: true location shift is not equal to 0 
```
Since the p-value is well below 0.05, we can assume the cars differ in gas milage between automatic and manual transmission cars. This plot shows us the differences:
```r
mtcars %>% 
  mutate(am = ifelse(am == 1, "Automatic", "Manual")) %>% 
  ggplot() +
    geom_density(aes(x = mpg, fill = am), alpha = 0.8)
```
{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/statistical-tests/cars-mpg-am.png" alt="Image text" width="491" height="450" align="middle"/>
{: refdef}
The plot tells us, since the null hypothesis doesn't hold, it is likely the manual transmission cars have lower gas milage.

### Kolmogorov-Smirnov test

<img src="/_pages/tutorials/statistical-tests/smirnov.png" width="49" height="180" align="right"/>

The [Kolmogorov-Smirnov test](https://en.wikipedia.org/wiki/Kolmogorov%E2%80%93Smirnov_test) tests the same thing as the Mann-Whitney U test, but has a much cooler name; the only reason I included this test here. And I drop the name in certain circles, which will result in snickers of approval for obvious reasons.
```r
automatic <- (mtcars %>% filter(am == 1))$mpg
manual <- (mtcars %>% filter(am == 0))$mpg
ks.test(automatic, manual)
```
Output:
```
	Two-sample Kolmogorov-Smirnov test

data:  automatic and manual
D = 0.63563, p-value = 0.003911
alternative hypothesis: two-sided
```

## Two related samples

Related samples tests are used to determine whether there are differences before and after some kind of treatment. It is also useful when seeing when verifying the predictions of machine learning algorithms.

### Wilcoxon Signed-Rank Test
 
The [Wilcoxon Signed-Rank Test](https://en.wikipedia.org/wiki/Wilcoxon_signed-rank_test) is used to see whether observations changed direction on two sets of ordinal variables. It's usefull, for example, when comparing results of questionaires with ordered scales for the same person across a period of time.

## Association between 2 variables

Tests of association determine what the strength of the movement between variables is. It can be used if you want to know if there is any relation between the customer's amount spent, and the number of orders the customer already placed. 

### Spearman correlation
