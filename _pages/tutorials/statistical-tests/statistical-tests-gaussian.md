---
layout: page
title: Statistical tests for Guassian variables
comments: true
permalink: /statistical-tests-gaussian/
---

This tutorial is the last in a series of four. This part shows you how to apply and interpret the tests for ratio variables with a normal (Gaussian) distribution. [This link](/statistical-tests/) will get you back to the first part of the series.

A **ratio** variable has values like interval variables, but here there is an absolute 0 point. 0 Kelvin is an example: there is no temperature below 0 Kelvin, which also means that the 700 degrees Kelvin is twice as hot as 350 degrees Kelvin. 



## Descriptive

Sometimes you just want to describe one variable. Although these types of descriptions don't need statistical tests, I'll describe them here since they should be a part of interpreting the statistical test results. Statistical tests say whether they change, but descriptions on distibutions tell you in what direction they change.

### Central tendency

Calculating means is straightforward: just use the _mean_ function:
```r
mean(chickwts$weight)
```
Output:
```
[1] 261.3099
```
Median is usually a better measure for central tendency, but if the variable is truly normally distributed, it should yield about the same result:
```r
median(chickwts$weight)
```
Output:
```
[1] 258
```
Seems pretty close to being normally distributed. But if you want to be sure, you can follow the procedure as discussed in the section [Normality check](/statistical-tests-gaussian/#normality-check)

### Distribution spread

Variance

The standard deviation of the mean (SD) is the most commonly used measure of the spread of values in a distribution. This is easily done with R's _sd_ function:
```r
sd(chickwts$weight)
```

### Putting it together

Box plot

Violin plot

## One sample

One sample tests are done when you want to find out whether your measurements differ from some kind of theorethical distribution. For example: you might want to find out whether you have a dice that doesn't get the random result you'd expect from a dice. In this case you'd expect that the dice would throw 1 to 6 about 1/6th of the time.

### Normality check

<img src="/_pages/tutorials/statistical-tests/seal-crazy.png" width="195" height="180" align="right"/>

Before you can do any of the tests below, you have to check whether the variable's distribution is anywhere near the Gaussian distribution. Here I'll show you how to see if the variables that you intend to test are normally distributed. For this I've created two examples: one with and one without normal distribution. For these checks I'll use three methods to inspect normality: two graphical ones, giving you intuition of the normality, and 'hard' method of a statistic normality test outputting a p-value.

For first example I will take a normally distributed value. Since I am lazy, instead of searching for a normally distibuted value in an existing data set, I'll create a distribution of 500 normally distributed values with the function _rnorm_:
```r
var_test <- rnorm(500,10,1)
```

With the first graph I want to get a sence of the distribution of the variable. This graph shows you now many observations each value has with a histogram:
```r
hist(var_test)
```
Output:
{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/statistical-tests/histogram-normal.png" alt="Image text" width="444" height="450" align="middle"/>
{: refdef}
This histogram shows a pretty nice bell-curve like shape, which supports that distribution might be normal.

Another method for checking normality visually which is regularly used is a quantile-quantile (q-q) plot. This plot is a graphical technique for determining if two data sets come from populations with a common distribution by plotting the quantiles of the first data set against the quantiles of the second data set. In this case we just put one data-set as input, while the other is the theorethical normal distribution. The r function _qqnorm_ does exactly that: puts a dataset and compares it to a normal distribution. The function _qqline_ adds the null-hypothesis line, which is the line the qqnorm plot would follow if the data was normally distributed. 
```r
qqnorm(y = var_test)  
qqline(y = var_test)
```
Output:
{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/statistical-tests/qq-plot-normal.png" alt="Image text" width="444" height="450" align="middle"/>
{: refdef}
In this Q-Q plot the distribution of points follow the null-hypothesis line almost completely: it tells us the data is normally distributed. The deviations on the end tells us the end of our data's bell curve are a little more pronounced than expected, but this is not a problem for statistical methods relying on normality of data.

The last method is a statistical test called the [Shapiro-Wilk test](https://en.wikipedia.org/wiki/Shapiro%E2%80%93Wilk_test). This can be checked with R's _shapiro.test_ function:
```r
shapiro.test(var_test)
```
Output:
```
	Shapiro-Wilk normality test

data:  var_test
W = 0.99706, p-value = 0.5099
```
The p-value, which is much larger than 0.05, tells me the null hypothesis of normally distributed can be maintained. 

For the example of a non-normal distribution I'm going to use the miles per gallon statistic from the **mtcars** data set:
```r
var_test <- mtcars$mpg
```
I've ran all the commands below to get this output:
{:refdef: style="text-align: center;"}
<img src="/_pages/tutorials/statistical-tests/plots-non-normal.png" alt="Image text" width="675" height="450" align="middle"/>
{: refdef}
```
	Shapiro-Wilk normality test

data:  var_test
W = 0.87627, p-value = 7.412e-10
```
It is clear from the histogram that this is _not_ a normal distribution, since it looks nowhere near a bell shape. I could have stopped here, but to be complete: let's interpret the rest. The Q-Q plot hits the expected distribution two times, but most of the points are way off the straght line. You can see the large left part of the histogram being reflected in the large left tail in the Q-Q plot. The Shapiro Wilk's test p-value of 7.412e-10 (much lower than 0.05) also tells me the null hypothesis that this is a normally distributed value should be abandoned.  

### One sample t-test

## Two unrelated samples

Unrelated sample tests can be used for analysing marketing tests; you apply some kind of marketing voodoo to two different groups of prospects/customers and you want to know which method was best. 

### Unpaired t-test

## Two unrelated samples

The related samples tests are used to determine whether there are differences before and after some kind of treatment. It is also useful when seeing when verifying the predictions of machine learning algorithms.

### Paired t-test

## Association between 2 variables

Tests of association determine what the strength of the movement between variables is. It can be used if you want to know if there is any relation between the customer's amount spent, and the number of orders the customer already placed. 

### Pearson correlation
