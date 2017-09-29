---
layout: page
title: Statistical tests
comments: true
permalink: /statistical-tests/
---

Statistical test allow us to draw conclusions about the distribution of a population, comparisons between populations or relations between variables. The exact test you use is determined by two things:

* The goal you're trying to reach a conclusion about
* The level of measurement of a variable.

This tutorial shows you how to choose your test for the conclusion you're trying to reach and how to apply them.

# Type of conclusion

Sometimes you just want to describe one variable, but mostly you use it to show which direction a population differs in in comparison to a theorethical distribution or in comparison to another group.

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


| Goal | Categorical | Ordinal | Normally distributed | 
| :--- | :-------- | :--------- | :------------------- |
| Describe one group | [Proportion](/nonparametric-tests/#Proportion), Mode | Mode, Median, Interquartile Range | Mean, SD |
| 1 Sample | Chi-square, Binominal test | Wilcoxon text | One sample t-test |
| 2 Unrelated samples | Chi-square | Mann-Whitney test | Unpaired t-test |
| 2 Related samples | McNemar's test | Wilcoxon test | Paired t-test |
| Association 2 variables | Contigency coefficients | Spearman correlation | Pearson correlation |



# Binominal variables

## Describe one group

### Proportion


### Mode

## One sample

