# AutomobileInsurancePortfolio_Pricing-Strucuture
## Objective
**Group project developed for Data Science for Actuaries Class of the PostGrad degree, Data Science for Finance, at NOVA IMS.**

Assuming the role of an actuary working for Insurance company, the project consisted on evaluating last year's claims data of the company's Automobile Insurance portfolio

## Statistical Data Analysis
### Detailed descriptive statistical data analysis of the Number of Claims of Third-Party Liability on Automobile Insurance

The portfolio dimension has 50.000 policies in total. The data is in one table divided in four headers, “n” (row name in database) “ncontract” (number of Contract), “coverage” (Type of the policy) and “cost” (the cost for insurance company of the claim).
It has been observed that almost 95% of the sample do not present any claim. The number of claims in the sample was 2490 policies that have register at least 1 claim, with some of them presented more the one claim. In the sample of claims, 99,40% had one or two claims and only 0,6% presented more of them 3 claims.

It was observed that only one policy had presented 16 claims. It was defined as an outlier, because of the bigger claim in comparison with the sample. To compare, the maximum number observed in database of claims was no more than four. The two figures below show a high concentration of claims in between one or two claims.

We have applied some statistical distribution to the claims in the database and it was observed a mean of 0.05394 and a variance of 0.06423176. Then we tried to do the statistical tests without the outlier. It was observed a mean of 0.05362, almost the same number, and a variance of 0.0591472. Here was obtained a small change, making the variance lower but still different from the mean.

### Detailed descriptive statistical data analysis of Claim Severity of Third-Party Liability on Automobile Insurance.
Analysing Claim Severity data, 2697 occurrences were observed. By extracting the cost of these
claims, with minimum and maximum costs of 0.01€ and 75.000€ were, respectively, obtained.
Since a cost of 0.01€ does not represent an effective cost (might be interpreted as a database
insertion mistake), we proceeded to remove these values from the sample. Only costs above 1€
were, therefore, considered. After this data filter, the sample totalled 1.921 claims. Figure 3 shows the data distribution.

The statistic data presents an average claim cost of 1.718,19€ and standard deviation of
3.451,74€, that is two times bigger than the mean. The distribution of the Quartiles shows that 99% of occurrences were concentrated until 16.060,00€.

In Figure 1 it is possible to have a visual concentration of the claim cost. The data presented a high concentration of the costs between 1€ and 20.000€, with some occurrences until 40.000€.
The Data has two claims above 55.000€ that could be considered outliers.
Figure 4 presents a histogram of the claim costs distribution. Here, we can observe the
characteristics of a highly skewed distribution with a very long tail.

### Distributions to the Number of claims and Claim Severity
To define the claim frequency more accurately, it was removed from the sample the contract
that presented 16 claims in one year. All the other contracts which presented no more than 4
claims were considered.

**Poisson Distribution**

We started by test fitting our data to a Poisson distribution. The results can be observed in Table 5 and Figure 5.
As observed visually and confirmed by the very low p-value, we concluded that the Poisson
Distribution did not fit the sample.

**Gamma Distribution**

Then, it was performed a fit test to a Gamma Distribution. The results are below presented, in
Table 6. As we can state, the test could not fit a Gamma-Distribution to our sample data and, therefore, it was rejected.

**Inverse-Gaussian Distribution**

We proceeded to test if the Inverse-Gaussian could fit in the sample, with the follow results:
Once again, following the results shown in Table 7, Table 8 and Table 9 we can reject that an
Inverse Gaussian distribution fits our sample.

**Negative Binomial Distribution**

We moved forward to test if our sample data followed a Negative Binomial distribution.
As we can infer from the statistical test results (Table 10, Table 11 and Table 12) as well as by Figure 6 a Negative Binomial Distribution fits our data.

**Upper bound to a distribution**

To fit a distribution for the Claim Severity, we performed a statistical analysis of the sample.
Thus, to fit a good distribution, an upper bound was defined to the distribution.
It was observed that 95% of claims were below 5.100€, therefore the superior limit defined was
6.000€. After this procedure our sample remained with 1846 observed contracts, meaning that
we left out 75 claims that had a cost superior of 6.000€.

**Mean Value and Standart Deviation for removed claims**

The Mean and Standard Deviation of the removed claims are shown in Table 13, with its
distribution presented in Figure 8. To this excluded data, the insurer should try to fit a distribution afterwards, and include it in the final model, since each policyholder should pay the same pure premium according to their risk profile. Since these high claims are, in our sample, rare events they should influence the pure premium.

## Pricing Structure
### Model assumptions and choices
We defined ‘’common” claims as costs below 6000 €.

First, we identified the variables that are numerical and analysed them individually to group them in levels (age of the driver, age of the vehicle). Claim frequency follows a negative binomial thus we computed a regression in which we used age of the driver, zone, power, age of the vehicle, brand and fuel as explanatory variables to infer the claim frequency.
Our standard insured characteristics (intercept) are presented in Table 14. From these preliminary results we might disregard some of these variables to test if they are significant, or not, for explaining the claim frequency.

### Statistical Tests
The power of the car is an explanatory variable that may be insignificant to explain the number of claims since most levels have high p-values (Figure 11) . To test its significance, we regressed a new model with all the variables except power.
The results obtained shows that the other explanatory variables remained significant with the removal of this variable, therefore the power was excluded from our model.

The zone is an explanatory variable that we consider significant to our model, but when analysing the zone initial levels, we decided to group zone B to our intercept, since it has a very high p-value (0.9593), statistically we do not reject the null hypothesis that zone B is equal to zone A.

Grouping zone B to another zone other than the intercept would not make sense, since all the other zone groups already prove to be significant to explain the claim frequency.
We also decided to group zones E and F, despite being individually significant, presented similar coefficients and impact positively the number of claims. We considered that its desirable to have more observations in only one zone, than to have different zones but with less observations each.

Afterwards, we regressed a new model with the new intercept (group A and B) and the new group E and F and concluded that the remaining zones became more statistically significant.

Our initial grouping for the age of a vehicle was built based on logical reasons. For instance, after the 4th year is when a car’s value mostly depreciates and cars with more than 25 years can be considered as classics, factor which might change its value.

Based on those initial groups, we regressed the model and observed that only one group (from 4 years to 11) was significantly different to the intercept. By trying to aggregate different groups, we couldn’t find a level (other than 4-11) that would explain the claim frequency.

Rationally, a car with more than 11 years should not have the same impact on the claim frequency as a car with less than 4 years, so joining all the levels of age other than the range 4-11 to the intercept was not a logical option. Hence, we excluded the variable “Age of Vehicle” of the model and tested a new regression without it, observing an improved model, with the same p-value and a better standard of error (from 0.077 to 0.0765), with all the other explanatory remaining significant.

Since all the explanatory variables of our model continued significant, we can conclude that the variable excluded was not contributing to explain the claim frequency.

Our starting point for this variable was dividing the age range in groups that would make some logical sense, for example from young, to young adults, adults, and elderly people.
Next, we tested the model to see what groups were significant and those that were not, through trial and error, we created new levels that would improve the model:

  - We joined the age category of 21-25 to the intercept (18-21), since both had less observations when separate, with a large number of claims. Logically, the number of claims is more frequent in younger people, with less driving experience, and both groups can include individuals that have recently obtained their driver’s license.
  - We also combined groups 31-41 and 41-51, since both had similar coefficient estimates and similar impact, magnitude wise.

Testing the model with these new levels, we obtained variables with more significance.

We started by analysing which brands could be grouped with the intercept, by selecting the ones with higher p-values:
  - We joined the brands 2 with the intercept, mainly because of high p-value (0.62131) but also for the logical reason that we were grouping mainly French vehicles brands (Nissan although Japanese, is owned 43% by Renault).
  - Then, we also grouped the new intercept (brands 1 and 2) with brands 4, since a high p value (0.48089) means that we cannot reject the null hypothesis that this group contributes differently to the intercept to explain the claim frequency.
  - With this new intercept, composed by brands 1, 2 and 4, the remaining brand groups became more statistically significant.

We grouped Brands 10, 11 and 13, creating a group that includes mainly expensive car brands, since both had similar coefficients and magnitude (both positive). Together, this group became more significant.

Initially, we grouped brands 14 and 6, that individually were not relevant and had similar betas and magnitude (both negative). Together they became more relevant, but not enough to be significant, so we combined this new group with brand 12 – that was already significant – and this resulted in a group of brands significant to our model.

Finally, we combined brands 3 and 5, since brand 5 was already significant and both had similar coefficient estimates.
With the grouping task completed, we now have an explanatory variable - car brand, with all levels having a p-value below 2,5%.

The initial output Table 11 already provided a statistically significant variable, therefore is considered in our model.

Finally, we achieved our final model for the Claim Frequency that presents the results in Figure 17

### Standard Insured profile and claim frequency estimation
The Standard Insured for Claim Frequency (Intercept) is characterized by a person with age between 18 to 25 years, that drives a diesel car of brands 1, 2 or 4, in zone A or B, with a population density of 1 to 100 population/km2.
The Claim Frequency obtained for our standard insured was 0.1690092 claims.

Based on the estimates of our final model we inferred the following characteristics for the highest and lowest risk profiles.

### Generalized Linear Model and Statistical tests
We defined ‘’common” claims as costs below 6000 €.
b. Detail and justify your model assumptions and choices
First, we identified the variables that are numerical and analyzed them individually to group
them in levels (group, age of the driver, age of the vehicle). We used the same group levels as
the ones identified to model Claim Frequency, considering that, in the end, we aim to achieve a
pricing structure combining both claim frequency and claim severity.
Claim severity follows a gamma distribution.
Our standard characteristics (intercept) goes as follow:
  - Zone: A
  - Age: [18,25)
  - Power: 4
  - Vehicle age: [0, 4[
  - Brand: 1 (Renault, Nissan)
   - Fuel: D (Diesel)
   
From these preliminary results we might disregard some of these variables as they might be
significant, or not, for explaining the claim costs.

The zone is a variable that, although considered significant to explain the Claim frequency, when analysing the initial levels, we observed that zone D was almost significant (p-value of 0.103479), and zones B and F had similar coefficient estimates.
We tried to group zone F and B, but together they did not become more significant that they were when separated. Since it would not make sense to join all the levels that were not statistically different from the intercept, leaving just zone D, we removed the zone from our model.

When testing the model without this variable, all the other variables remained significant, so we reached to the conclusion that the zone was not contributing to explain the claim costs.

The Power and Vehicle age weren’t both significant enough to explain the claim severity.

Age of the Driver and Brands, we followed the same logic and grouping strategy as in the claim frequency model.

Our model estimates show us that claim cost estimate are indifferent to the type of fuel (p-value 0.98996), hence we removed it as an explanatory variable.
Finally, we achieved our final model for the Claim Severity, that presents the results in Figure 19

### Standard Insured profile and claim severity estimatation
The Standard Insured for Claim Severity (Intercept) is characterized by a person with age
between 18 to 25 years, that drives a car of brands 1, 2 or 4.
The Claim Cost obtained for our standard insured was 1404.52€.

Based on the estimates of our final model we inferred the following characteristics for the
highest and lowest risk profiles:

### Final Pricing Strucuture
After identifying the appropriate models to explain Claim Frequency and Claim Costs, which
reflects the tariff factors that influence the explanatory variables, we obtained the pure
premiums, considering as “common” claims, costs below 6.000€, which are reflected in Table 17.

While modeling this pricing structure it was considered the independence between the claim
frequency and the claim costs to later achieve the final tariff.

Taking into account these results, we obtained a base premium for our Standard Insured of
236,96€.
The highest insured’s risk profile obtained consists of an individual with the same characteristics
as our standard insured, with the exception of the zone of residence, which would be zone E.
Therefore, our highest premium to be paid, considering this profile, would be 422,30€.
As for the lowest insured’s risk profile, we reached to the conclusion that it consists of an
individual with the same characteristics of our standard insured and with age 81 to 101 years
old instead of 18 to 25 years old (our standard insured). Hence, the tariff applied to this profile
is 73,28€.

Concerning our definition of “Large” claims, we considered claim costs above 6.000€, which
consisted in 75 occurrences.
Considering the same standard insured, we fitted a binomial GLM distribution to the “large”
claims and obtained the following output (Figure 20):

Using this distribution and considering the highest insured’s risk profile (on claim costs) we calculated the probability of an individual with these characteristics having a large claim (>6.000€) and obtained a value of 0.038. As one can observe the probability of having a large claim, even considering the highest risk profile is extremely low, which can therefore be considered as a “bad luck” event. Consequently, we consider that these events should not penalize the common claims’ pure premium and therefore should be diluted among the common claim pricing structure.

**Hope you find this project interesting**
