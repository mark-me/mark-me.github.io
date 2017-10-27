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

### Mean

### Standard deviation

### Sum of squared errors

## One sample

One sample tests are done when you want to find out whether your measurements differ from some kind of theorethical distribution. For example: you might want to find out whether you have a dice that doesn't get the random result you'd expect from a dice. In this case you'd expect that the dice would throw 1 to 6 about 1/6th of the time.

### Normality check

<img src="/_pages/tutorials/statistical-tests/seal-crazy.png" width="195" height="180" align="right"/>

Before you can do any of the tests below, you have to check whether the distribution is anywhere near the Gaussian distribution. Here I'll show you how to see if the variables that you intend to test are normally distributen. For this I've created two examples: one with and one without normal distribution. For these checks I'll use three methods to inspect normality: two graphical ones, and one test outputting a p-value.

For first example I will take a normally distributed value. Since I am lazy, instead of searching for a normally distibuted value in an existing data set, I'll create a distribution of 500 normally distributed with the function _rnorm_:
```r
var_test <- rnorm(500,10,1)
```

With the first graph I want to get a sence of the distribution of the variable. This graph shows you now many observations each value has with a histogram:
```r
hist(var_test)
```
Output:

This histogram shows a pretty nice bell-curve like shape, which supports that distribution might be normal.

Another method for checking normality visually which is regularly used is a Q-Q plot. This plot 
```r
plot(var_test)
qqnorm(y = var_test)  
qqline(y = var_test)
```
Output:

This shows

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
