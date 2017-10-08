---
layout: page
title: Statistical tests
comments: true
permalink: /statistical-tests/
---

This tutorial is one in a series of four. The goal of this whole tutorial shows you how to choose your test and how to apply nd interpret them. This first part will tell you which one to choose, the other three parts are about applying and interpreting the tests.

| Goal | Categorical | Ordinal | Gaussian | 
| :--- | :-------- | :--------- | :------------------- |
| Descriptive | [Proportion](/statistical-tests/#proportion), [Mode](/statistical-tests/#mode) | [Mode](/statistical-tests/#mode), Median, Interquartile Range | [Mean, SD](/statistical-tests/#mean-sd) |
| 1 Sample | [Chi-square](/statistical-tests/#chi-square-goodness-of-fit-test), [Binominal test](/statistical-tests/#binominal-test) | [Wilcoxon text](/statistical-tests/#wilcoxon-test) | [One sample t-test](/statistical-tests/#one-sample-t-test) |
| 2 Unrelated samples | [Chi-square](/statistical-tests/#two-sample-chi-square-test) | [Mann-Whitney test](/statistical-tests/#mann-whitney-test) | [Unpaired t-test](/statistical-tests/#unpaired-t-test) |
| 2 Related samples | [McNemar's test](/statistical-tests/#mcnemars-test) | Wilcoxon test | [Paired t-test](/statistical-tests/#paired-t-test) |
| Association 2 variables | [Contigency coefficients](/statistical-tests/#contigency-coefficients) | [Spearman correlation](/statistical-tests/#spearman-correlation) | [Pearson correlation](/statistical-tests/#pearson-correlation) |

Statistical test allow us to draw conclusions about the distribution of a population, comparisons between populations or relations between variables. The exact test you use is determined by two things:

* The goal you're trying to reach a conclusion about
* The level of measurement of a variable.

This tutorial shows you how to choose your test for the conclusion you're trying to reach and how to apply them.

# Types of conclusions

Sometimes you just want to describe one variable. Although these types of descriptions don't need statistical tests, I'll describe them here since they should be a part of interpreting the statistical test results. Statistical tests say whether they change, but descriptions on distibutions tell you in what direction they change.

One sample tests are done when you want to find out whether your measurements differ from some kind of theorethical distribution. For example: you might want to find out whether you have a dice that doesn't get the random result you'd expect from a dice. In this case you'd expect that the dice would throw 1 to 6 about 1/6th of the time.

Two sample tests come in two flavors: unrelated and related samples. Unrelated sample tests can be used for analysing marketing tests; you apply some kind of marketing voodoo to two different groups of prospects/customers and you want to know which method was best. The related samples tests are used to determine whether there are differences before and after some kind of treatment. It is also useful when seeing when verifying the predictions of machine learning algorithms.

Tests of association determine what the strength of the movement between variables is. It can be used if you want to know if there is any relation between the customer's amount spent, and the number of orders the customer already placed. 

# Levels of measurement

A variable can be categorized as one of the following levels of measurements, in order of increasing information value:

* A **categorical** variable values are just names, that indicate no ordering. An example is fruit: you've got apples and oranges, there is no order in these. A special case is a binominal is a variable that can only assume one of two values, true or false, heads or tails and the like. Churn and prospect/customer variables are more specific examples of binominal variables.
* An **ordinal** variable contains values that can be ordered like ranks and scores. You can say that one value higher than the other, but you can't say one value is 2 times more important. An example of this is army ranks: a General is higher in rank than a Major, but you can't say a General outranks a Major 2 times.
* A **interval** variable has values that are ordered, and the difference between has meaning, but there is no absolute 0 point, which makes it difficult to interpret differences in terms of absolute magnitude. Money value is an example of an interval level variable, which may sound a bit counterintuitive. Money can take negative values, which makes it impossible to say that someone with 1 million Euros on his bank account has twice as much money as someone that has 1 million Euros in debt. The [Big Mac Index](https://en.wikipedia.org/wiki/Big_Mac_Index) is another case in point.
* A **ratio** variable has values like interval variables, but here there is an absolute 0 point. 0 Kelvin is an example: there is no temperature below 0 Kelvin, which also means that the 700 degrees Kelvin is twice as hot as 350 degrees Kelvin. Quantities are the only example in my field that I know of. 

The level of measurement of the variable determines which type of test you can use. The main distinction between tests are the parametric versus nonparametric tests. Parametric tests make assumptions about the defining properties of the variable's distribution of the population. Mostly they assume that the variable is normally distributed for the population. In my experience in Marketing they never are (please let me know if you have an example in which it is the case). So for me, this rules out parametric tests. 

# Putting it all together

The previous sections should have given you enough rope to find out what kind of test you need: by knowing what the type of conclusion is you want to reach, and found out which level measurement your variable is at, you can find out the test by making the correct crossing in the table below: 

| Goal | Categorical | Ordinal | Gaussian | 
| :--- | :-------- | :--------- | :------------------- |
| Descriptive | [Proportion](/statistical-tests/#proportion), [Mode](/statistical-tests/#mode) | [Mode](/statistical-tests/#mode), Median, Interquartile Range | [Mean, SD](/statistical-tests/#mean-sd) |
| 1 Sample | [Chi-square](/statistical-tests/#chi-square-goodness-of-fit-test), [Binominal test](/statistical-tests/#binominal-test) | [Wilcoxon text](/statistical-tests/#wilcoxon-test) | [One sample t-test](/statistical-tests/#one-sample-t-test) |
| 2 Unrelated samples | [Chi-square](/statistical-tests/#two-sample-chi-square-test) | [Mann-Whitney test](/statistical-tests/#mann-whitney-test) | [Unpaired t-test](/statistical-tests/#unpaired-t-test) |
| 2 Related samples | [McNemar's test](/statistical-tests/#mcnemars-test) | Wilcoxon test | [Paired t-test](/statistical-tests/#paired-t-test) |
| Association 2 variables | [Contigency coefficients](/statistical-tests/#contigency-coefficients) | [Spearman correlation](/statistical-tests/#spearman-correlation) | [Pearson correlation](/statistical-tests/#pearson-correlation) |


# Categorical variables

## Descriptive

### Proportion

There are many ways to do this but, for no particular reason, I've chosen to do this with the **dplyr** framework:
```r
iris %>% 
  group_by(Species) %>% 
  summarise (n = n()) %>%
  mutate(proportion = n / sum(n))
```
This shows the proportion of each species of iris (33% for each):
```
# A tibble: 3 x 3
     Species     n proportion
      <fctr> <int>      <dbl>
1     setosa    50  0.3333333
2 versicolor    50  0.3333333
3  virginica    50  0.3333333
```

### Mode

There is no standard function to calculate the mode that I know of (if you know one, please leave a comment), so I created called _calc_mode_:
```r
calc_mode <- function(x){ 
  table_freq = table(x)
  max_freq = max(table_freq)
  if (all(table_freq == max_freq))
    mod = NA
  else
    if(is.numeric(x))
      mod = as.numeric(names(table_freq)[table_freq == max_freq])
  else
    mod = names(table_freq)[table_freq == max_freq]
  return(mod)
}
```
In the case where there is one value with the highest frequency that value will be returned:
```r
> table(diamonds$cut)
     Fair      Good Very Good   Premium     Ideal 
     1610      4906     12082     13791     21551 

> calc_mode(diamonds$cut)
[1] "Ideal"
```
In case all values have the same frequency _NA_ will be reported as the mode
```r
> table(iris$Species)
    setosa versicolor  virginica 
        50         50         50 

> calc_mode(iris$Species)
[1] NA
```
When there are multiple values with the same frequency, all those will be returned
```r
> table(mtcars$mpg)
10.4 13.3 14.3 14.7   15 15.2 15.5 15.8 16.4 17.3 17.8 18.1 18.7 19.2 19.7   21 21.4 21.5 22.8 24.4   26 27.3 30.4 32.4 33.9 
   2    1    1    1    1    2    1    1    1    1    1    1    1    2    1    2    2    1    2    1    1    1    2    1    1 

> calc_mode(mtcars$mpg)
[1] 10.4 15.2 19.2 21.0 21.4 22.8 30.4
```

## One sample

### Chi-Square Goodness of Fit test

With the [Chi-Square Goodness of Fit Test](http://www.stat.yale.edu/Courses/1997-98/101/chigf.htm) you test whether your data fits an hypothetical distribution you'd expect. Let's take the example of dice. First you have a data set you've collected by throwing a dice 100 times, recording the number of times each is up, from 1 to 6:
```r
throws <- c(18, 16, 15, 17, 16, 18)
```
Then we fill a vector which expected probabilities of each side being thrown:
```r
exp_throws <- c(rep(1/6, 6))
```
Then the function _[chisq.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/chisq.test.html)_ to test whether this dice isn't tampered with, or needs to be replaced:
```r
chisq.test(throws, p = exp_throws)
```
Resulting in:
```
Chi-squared test for given probabilities

data:  throws
X-squared = 0.44, df = 5, p-value = 0.9942
```
Where the p-value of .9942 tells us we can trust this dice when we want to play a fair game. If you store the result in a variable, you can access the p.value property; this might come in handy if you want to use the result of the test later on in your script.

### Binominal test

With the [binominal test](https://en.wikipedia.org/wiki/Binomial_test) you test whether one value is higher or lower in occurence than expected.

The binominal test is used when there is only two outcomes: succes or failure. While this doesn't mean the variable can only have two values, but only one of the values could be considered succes. If a few values are considered a succes, I would recommend creating a new variable in which you recode the values into a logical values of successes and failures.

The test in R is done by using the function _[binom.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/binom.test.html)_. Suppose we think about 75% of our customers are male (the things we think about...), we have no data on it, so we start collecting it by randomly calling 100 of them and registring their gender. We find that 70 of the customers were male. Do we now reject our initial hypothesis of 75%? Let's find piece of mind, and answer this pressing question:
```r
binom.test(70, 100, p = .75, alternative = "two.sided")
```
The output:
```
data:  70 and 100
number of successes = 70, number of trials = 100, p-value = 0.2491
alternative hypothesis: true probability of success is not equal to 0.75
95 percent confidence interval:
 0.6001853 0.7875936
sample estimates:
probability of success 
                   0.7 
```
The miserable p-value of .2491 tells us we can hold on to our hypothesis than 75% of our customers are male. Like with the Chi-squared test, you can access the p.value property if you store the _binom.test_ function's result in a variable.

## Two unrelated samples

### Two sample Chi-Square test

<img src="/_pages/tutorials/statistical-tests/debbie-harry.jpg" alt="Me" width="129" height="170" align="right"/>

The two sample Chi-square test can be used to compare two groups for categorical variables. A typical marketing application would be A-B testing. But because I want to give an example, I'll take a R dataset about hair color. I'm very, very interested if the sexes differ in hair color. For this I use the **[HairEyeColor](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/HairEyeColor.html)** data-set, which very usefully specifies whether hair is painted or not. I must prepare it so the frequencies of the sexes are in two columns, and I need to remove the _Hair_ color column for the _chisq.test_ function to be able to process it.
```r
tbl_hair_sex <- as.data.frame(HairEyeColor) %>% 
  group_by(Hair, Sex) %>% 
  summarise(qty = sum(Freq)) %>% 
  ungroup() %>% 
  spread(key = Sex, value = qty) %>% 
  select(Male, Female)
```
Then the function is applied:
```
chisq.test(tbl_hair_sex)
```
The output:
```
	Pearson's Chi-squared test

data:  tbl_hair_sex
X-squared = 7.9942, df = 3, p-value = 0.04613
```
The p value is below 0.05 and tells us that there is a difference in hair color between men and women in the sample. When you look at the data, you would see that this is mostly caused by the the female students have proportionally blonder hair.

## Two related samples

### McNemar’s test

<img src="/_pages/tutorials/statistical-tests/cravat.jpg" alt="Me" width="170" height="222" align="right"/>

**[McNemar's test](https://en.wikipedia.org/wiki/McNemar%27s_test)** is used to see whether observations differ in values on two sets of variables. It's useful for comparing results of questionaires for the same person across a period of time.

In his classic book _[The Decline of Good Taste](https://www.gutenberg.org/ebooks/search/?query=The+decline+of+good+taste)_ Dr. Edward McAuliffe lamented the ascent of the frivolous bow-tie to the expense of the refined [cravat](https://mccannbespoke.co.uk/how-to-wear-a-cravat/). Being the reputed scientist he was, he didn't go by feeling but relentlessly carried out two questionnaires to the same 2.000 men with 2 years in between. The men were asked if they wouldd rather wear a bow-tie or a cravat. Here I recreate the results:
```r
tbl_cravat <- data.frame(first_result = c(rep("Cravat", 1500), 
                                          rep("Bow-tie", 500)), 
                         second_result = c(rep("Cravat", 1100), 
			                   rep("Bow-tie", 700), 
					   rep("Cravat", 200)))

tbl_data %<>%
  group_by(first_result, second_result) %>% 
  summarise(qty = n()) %>% 
  ungroup() %>%
  spread(key = second_result, value = qty) %>% 
  select(Approve, Disapprove)
```
To test whether their opinions changed we can apply the data frame to the _[mcnemar.test](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/mcnemar.test.html)_ function.
```r
mcnemar.test(as.matrix(tbl_data))
```
Output:
```
	McNemar's Chi-squared test with continuity correction

data:  as.matrix(tbl_data)
McNemar's chi-squared = 66.002, df = 1, p-value = 4.505e-16
```
Seeing the p value is so low, we can assume the general sentiment toward the cravat changed. And seeing the direction of the fashion evolution we will mourn together with Dr. McAuliffe about this great loss in gentlemanly traditions...

## Association between 2 variables

### Contigency coefficients or Cramer's V	

The contingency coefficient makes use of the Chi-Square. Since we've already did  Chi-square test on the **[HairEyeColor](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/HairEyeColor.html)**, we'll do the same here, but the Chi-square test result is stored in a list to use it in the final contingency correlation:
```r
res_chisq <- chisq.test(tbl_hair_sex)
```
Then we calculate the contingency coefficient like this:
```r
sqrt(res_chisq$statistic/min(nrow(tbl_hair_sex) + res_chisq$statistic))
```
Output:
```
X-squared 
0.8163986 
```
You can ignore the name X-squared here, since it has no meaning here. The coefficient is pretty high, so there is a strong association between sex and hair color.

The contingency coefficient is [critiqued](https://accendoreliability.com/contingency-coefficient/) for not reaching it's outer limits of -1 and +1. This is where [Cramer's V](https://en.wikipedia.org/wiki/Cram%C3%A9r%27s_V) comes in: the values come between 0 and 1. The value is calculated by taking the square root of chi-square divided by sample size, n, times m. m is the smaller of (rows - 1) or (columns - 1).
```r
sqrt((res_chisq$statistic/nrow(tbl_hair_sex)) / min(nrow(tbl_hair_sex) - 1, ncolumn(tbl_hair_sex) - 1))
```

# Ordinal variables

## Descriptive

### Median, Interquartile Range

## One sample

### Wilcoxon test

## Two unrelated samples

### Mann-Whitney test

## Two unrelated samples

## Association between 2 variables

### Spearman correlation

# Gaussian variables

## Descriptive

### Mean, SD

## One sample

### One sample t-test

## Two unrelated samples

### Unpaired t-test

## Two unrelated samples

### Paired t-test

## Association between 2 variables

### Pearson correlation
