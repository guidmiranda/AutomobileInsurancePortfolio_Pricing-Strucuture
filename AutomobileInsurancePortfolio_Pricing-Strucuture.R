##########################################################################
#     Part I #
##########################################################################

# 1) Detailed Descriptive Statistical Data Analysis of Number of Claims

# ------------------------------------------------------------------------

rm(list=ls(all=TRUE))

#Auto Data
portfolio=read.table(choose.files(),header=TRUE,sep=";")#choose autodata.txt
names(portfolio)

#Claims Data New 

claims=read.table(choose.files(),header=TRUE,sep=";")  #choose claimsdatanew
head(claims)

#Choosing 3rd party liability

TPclaims=claims[claims$coverage=="1RC",]

#Claims Distribution

T=table(TPclaims$ncontract)
T1=as.numeric(names(T))
T2=as.numeric(T)
n1 = data.frame(ncontract=T1,nclaims=T2)
I = portfolio$ncontract%in%T1
T1=portfolio$ncontract[I==FALSE]
n2 = data.frame(ncontract=T1,nclaims=0)
number=rbind(n1,n2)
data<-table(number$nclaims)


#Frequency
baseFREQ = merge(portfolio,number)

N<-baseFREQ$nclaims 
E<-baseFREQ$exposition 





#Statistical Analysis - Number of Claims

#Mean and Variance all portfolio
mean(number$nclaims)
var(number$nclaims)

#Removing the policy with 16 claims and performing statistics
number_filtered <-number[order(number$nclaims),]
number_filtered <- number_filtered[-nrow(number_filtered),]

mean(number_filtered$nclaims)
var(number_filtered$nclaims)


#Graphs of Number of Claims

hist(number$nclaims)
hist(number$nclaims,main="Histogram of Claims Frequency", col="blue")


boxplot(number$nclaims)
boxplot(number$nclaims,col="green",horizontal=T, main="Boxplot of Claim Frequency", xlab="Number of Claims")



# ------------------------------------------------------------------------

# 2) Detailed Descriptive Statistical Data Analysis of Claim Severity

# Severity
baseSEV=merge(portfolio,TPclaims) #adds extra collumn the amount of cost of the claim. Where y is the cost
nrow(baseSEV)

# Removing Costs below 1 since they represent claims in which the insured was not the responsible for the claim or represent database mistake

baseSEV=baseSEV[baseSEV$cost>1,]
nrow(baseSEV)

# min, max
min(baseSEV$cost)  #Maybe this 0.01 cent is a mistake and should account for example above 5???
max(baseSEV$cost)

# mean, standard deviation, variation coefficient
meanCOST<-print(mean(baseSEV$cost))
sdCOST<-print(sd(baseSEV$cost))
vcCOST<-print(sdCOST/meanCOST)   #CR: How many times the stdev is in relation to the mean. In this case is 2.

# quantiles, boxplot

quantile(baseSEV$cost,prob=c(0.5,0.9,0.95,0.99))
boxplot(baseSEV$cost, main="Claim Costs BoxPlot",horizontal=TRUE, col="dodgerblue")
# highly right skewed, 2 highly severe outliers

# histogram

#CR: Highly skewed. Normal regression is an absurd. Very long large tail.

breakshist=seq(0,max(baseSEV$cost)+1,by=1000)
histCOST<-hist(baseSEV$cost, breaks=breakshist,main="Claim Costs", col="dodgerblue",xlab="Cost", ylab="",ylim=c(0,1000))

# ------------------------------------------------------------------------

# 3) Fit distributions to the Number of Claims and Claim Severity

# Number of Claims

#Filtered Data

number_filtered

#1. Test for a Poisson Distribution
library(MASS);library(vcd)

fitdistr(x,"poisson")
model.poisson=goodfit(number_filtered$nclaims,type="poisson",method="ML")
model.poisson
summary(model.poisson)

plot(model.poisson,main="Fitting a Poisson distribution",xlab="Nº of claims", ylab="Sqrt(Frequency)")

#2. Test for a Gamma Distribution

library(goft)
gamma_fit(number_filtered$nclaims)
gamma_test(number_filtered$nclaims)

#3. Test for an Inverse-Gaussian

ig_fit(number_filtered$nclaims)
ig_test(number_filtered$nclaims) 


#Fitting a Negative Binomial 

library(MASS);library(vcd)

fitdistr(number_filtered$nclaims,"negative binomial")
model.nb=goodfit(number_filtered$nclaims,type="nbinomial",method="ML")
model.nb
summary(model.nb)

plot(model.nb,main="Fitting a Negative Binomial distribution",xlab="Nº of claims", ylab="Sqrt(Frequency)")



# Claim Severity

#Quantile/Quartile

#1
library(Rcmdr)


#2
quantile(baseSEV$cost,prob=c(0.5,0.9,0.95,0.99))
boxplot(baseSEV$cost, main="Claim Costs BoxPlot",horizontal=TRUE, col="dodgerblue")
# highly right skewed, 2 highly severe outliers

# Setting lower and upper limits for claim amounts (lower=0 , upper=6.000)
limInf=0
limSup=6000
step=1000

baseSEV_withlim<-baseSEV[baseSEV$cost<limSup,]
nrow(baseSEV) #total database
nrow(baseSEV_withlim) #limited database
nrow(baseSEV)-nrow(baseSEV_withlim)
# removed 74 claims from data
# we should include them in the tariff structure at the end

boxplot(baseSEV_withlim$cost, main="Claim Costs BoxPlot",horizontal=TRUE, col="dodgerblue")

#Testing Continuous Distributions

#1. Test LogNormal distribution

#LogNormal#
lnorm_test(baseSEV_withlim$cost) 
#Reject Log Normal - p-value low


# 2. Test Inverse Gaussian distribution
ig_fit(baseSEV_withlim$cost)
ig_test(baseSEV_withlim$cost) 
#Reject


# 3. Test Pareto distribution
gp_fit(baseSEV_withlim$cost, method="amle")
gp_test(baseSEV_withlim$cost,B=999) 


#4. Test Gamma distribution

gamma_fit(baseSEV_withlim$cost)
gamma_test(baseSEV_withlim$cost) 
#P value of 0.80. Gamma distribution is a good fit!!!!


#3c) Mean and Variance of erased values

# Setting lower and upper limits for claim amounts (lower=0 , upper=6.000)
limInf2=6000
limSup2=75000
step2=1000

baseSEV_removed<-baseSEV[baseSEV$cost>=limInf2,]

#Mean and Variance
mean(baseSEV_removed$cost)
var(baseSEV_removed$cost)
sd(baseSEV_removed$cost)

#Histogram

breakshist2=seq(0,limSup2+1,by=step)
histCOST2<-hist(baseSEV_removed$cost,main="Claim Cost", col="dodgerblue",xlab="Cost", ylab="", ylim=c(0,50))

#Boxplot

boxplot(baseSEV_removed$cost, main="Claim Costs BoxPlot",horizontal=TRUE, col="dodgerblue")


##########################################################################
#     Part II #
##########################################################################

#1. 

# ------------------------------------------------------------------------
#              ORGANIZING DATA INTO APPROPRIATE VARIABLES
# ------------------------------------------------------------------------



interactiongraphic=function(title="Claim Frequency vs Age of the Driver",name="agedriver", lev=c(17,21,24,29,34,44,64,84,100),
                            contin=TRUE){
  
  if(contin==TRUE){X=cut(baseFREQ[,name],lev)}
  if(contin==FALSE){X=as.factor(baseFREQ[,name])}
  E=baseFREQ$exposition
  Y=baseFREQ$nclaims
  FREQ=levels(X)
  mea=variance=n=rep(NA,length(FREQ))
  for(k in 1:length(FREQ)){
    mea[k]=weighted.mean(Y[X==FREQ[k]]/E[X==FREQ[k]],E[X==FREQ[k]])
    variance[k]=weighted.mean((Y[X==FREQ[k]]/E[X==FREQ[k]]-mea[k])^2,E[X==FREQ[k]])
    n[k]=sum(E[X==FREQ[k]])
  }
  
  w=barplot(n,names.arg=FREQ,col="light blue", axes=FALSE,xlim=c(0,1.2*length(FREQ)+0.5))
  mid=w[,1]
  axis(2)
  par(new=TRUE)
  IC1=mea+1.96/sqrt(n)*sqrt(variance)
  IC2=mea-1.96/sqrt(n)*sqrt(variance)
  globalmean=sum(Y)/sum(E)
  
  plot(mid,mea,main=title,ylim=range(c(IC1,IC2)),type="b",col="red",axes=FALSE,xlab="",ylab="",xlim=c(0,1.2*length(FREQ)+0.5))
  segments(mid,IC1,mid,IC2,col="red")
  segments(mid-0.1,IC1,mid+0.1,IC1,col="red")
  segments(mid-0.1,IC2,mid+0.1,IC2,col="red")
  points(mid,mea,pch=19,col="red")
  axis(4)
  abline(h=globalmean,lty=2,col="red")
  
  mtext("Exposition",2,line=2,cex=1.2,col="light blue")
  mtext("Annual Frequency",4,line=-2,cex=1.2,col="red")
}


#Age of the Driver
interactiongraphic()

agedriver_lev<-c(18,22,26,31,41,51,61,71,81,101)
baseFREQ$agecut<-cut(baseFREQ$agedriver,breaks=agedriver_lev,right=FALSE)


# Power of Vehicle
interactiongraphic(title="Claim Frequency vs Power of Vehicle",name="power",contin=FALSE)



# Age of vehicle
interactiongraphic(title="Claim Frequency vs Age of Vehicle",name="agevehicle",contin=FALSE)

agevehicle_lev<-c(0,4,11,21,30,101)
baseFREQ$vehcut<-cut(baseFREQ$agevehicle,breaks=agevehicle_lev,right=FALSE)


# p-values of all risk factors
library(MASS)

model_nb<-glm.nb(nclaims~zone+as.factor(power)+vehcut+
                   agecut+as.factor(brand)+fuel+offset(log(exposition)),data=baseFREQ)
summary(model_nb)


#Test model without variable power

model_no_pow<-glm.nb(nclaims~zone+vehcut+
                       agecut+as.factor(brand)+fuel+offset(log(exposition)),data=baseFREQ)

summary(model_no_pow)



#1 Group zone B with zone A/ Group zone E with zone F

interactiongraphic(title="Claim Frequency vs Zone of residence",name="zone",contin=FALSE)



baseFREQ$zone2=baseFREQ$zone
baseFREQ$zone2[baseFREQ$zone%in%c("A","B")]="A"
baseFREQ$zone2[baseFREQ$zone%in%c("E","F")]="E"



model_no_pow2<-glm.nb(nclaims~zone2+vehcut+
                       agecut+as.factor(brand)+fuel+offset(log(exposition)),data=baseFREQ)

summary(model_no_pow2)




#Removing the age of the vehicle as explanatory variable


model_no_pow2_no_vhage<-glm.nb(nclaims~zone2+
                        agecut+as.factor(brand)+fuel+offset(log(exposition)),data=baseFREQ)

summary(model_no_pow2_no_vhage)




#testing for groups on the age of the driver

#grouping the first two levels

agedriver_lev<-c(18,25,31,51,61,71,81,101)
baseFREQ$agecut<-cut(baseFREQ$agedriver,breaks=agedriver_lev,right=FALSE)



model_no_pow2_no_vhage<-glm.nb(nclaims~zone2+
                                 agecut+as.factor(brand)+fuel+offset(log(exposition)),data=baseFREQ)

summary(model_no_pow2_no_vhage)




#testing to group brands

interactiongraphic(title="Claim Frequency vs Brand of the car",name="brand",contin=FALSE)


baseFREQ$brand2=baseFREQ$brand
baseFREQ$brand2[baseFREQ$brand%in%c("1","2","4")]="1"
baseFREQ$brand2[baseFREQ$brand%in%c("10","11","13")]="10"
baseFREQ$brand2[baseFREQ$brand%in%c("6","14","12")]="6"
baseFREQ$brand2[baseFREQ$brand%in%c("3","5")]="5"


model_frequency<-glm.nb(nclaims~zone2+
                                 agecut+as.factor(brand2)+fuel+offset(log(exposition)),data=baseFREQ)

summary(model_frequency)



# c) 

predict(model_frequency,newdata=data.frame(agecut="[18,25)",zone2="A",brand2="1",fuel="D" ,exposition=1),type="response")


#d) 
#Highest claim
predict(model_frequency,newdata=data.frame(agecut="[18,25)",zone2="E",brand2="10",fuel="D" ,exposition=1),type="response")

#lowest claim
predict(model_frequency,newdata=data.frame(agecut="[81,101)",zone2="A",brand2="6",fuel="E" ,exposition=1),type="response")



#2 CLAIM COSTS

#grouping the variables the same way as in claim frequency

#Age of the Driver

agedriver_lev<-c(18,25,31,51,61,71,81,101)
baseSEV_withlim$agecut<-cut(baseSEV_withlim$agedriver,breaks=agedriver_lev,right=FALSE)



# Age of vehicle

agevehicle_lev<-c(0,4,11,21,30,101)
baseSEV_withlim$vehcut<-cut(baseSEV_withlim$agevehicle,breaks=agevehicle_lev,right=FALSE)


# p-values of all risk factors
library(MASS)

model_gamma<-glm(cost~zone+as.factor(power)+vehcut+agecut+as.factor(brand)+fuel,family=Gamma(link="log"),data=baseSEV_withlim)
summary(model_gamma)


#Trying to join zones


baseSEV_withlim$zone2=baseSEV_withlim$zone
baseSEV_withlim$zone2[baseSEV_withlim$zone%in%c("B","F")]="B"

model_gamma_zone<-glm(cost~zone2+as.factor(power)+vehcut+agecut+as.factor(brand)+fuel,family=Gamma(link="log"),data=baseSEV_withlim)
summary(model_gamma_zone)

#drop zone as explanatory variable --> USE MODEL_GAMMA

model_gamma_nozone <- glm(cost~as.factor(power)+vehcut+agecut+as.factor(brand)+fuel,family=Gamma(link="log"),data=baseSEV_withlim)
summary(model_gamma_nozone)


#Grouping power levels

baseSEV_withlim$power2=baseSEV_withlim$power
baseSEV_withlim$power2[baseSEV_withlim$power%in%c("4","15")]="4"
baseSEV_withlim$power2[baseSEV_withlim$power%in%c("6","9")]="6"
baseSEV_withlim$power2[baseSEV_withlim$power%in%c("7","8","10")]="7"


model_gamma_nozone <- glm(cost~as.factor(power2)+vehcut+agecut+as.factor(brand)+fuel,family=Gamma(link="log"),data=baseSEV_withlim)
summary(model_gamma_nozone)


#Drop power as explanatory variable

model_gamma_nozone_nopow <- glm(cost~+vehcut+agecut+as.factor(brand)+fuel,family=Gamma(link="log"),data=baseSEV_withlim)
summary(model_gamma_nozone_nopow)



#Drop Vehicle age as explanatory variable

model_gamma_nozone_nopow_novhage <- glm(cost~agecut+as.factor(brand)+fuel,family=Gamma(link="log"),data=baseSEV_withlim)
summary(model_gamma_nozone_nopow_novhage)



#Brand Levels 

##Grouping Brand 3 with intercept since it has a high p-value

baseSEV_withlim$brand2=baseSEV_withlim$brand
baseSEV_withlim$brand2[baseSEV_withlim$brand%in%c("1","2","4")]="1"
baseSEV_withlim$brand2[baseSEV_withlim$brand%in%c("10","11","13")]="10"
baseSEV_withlim$brand2[baseSEV_withlim$brand%in%c("6","14","12")]="6"
baseSEV_withlim$brand2[baseSEV_withlim$brand%in%c("3","5")]="5"



model_gamma_nozone_nopow_novhage_newbrands <- glm(cost~agecut+as.factor(brand2)+fuel,family=Gamma(link="log"),data=baseSEV_withlim)
summary(model_gamma_nozone_nopow_novhage_newbrands)


#Drop Fuel as explanatory variable

model_severity <- glm(cost~agecut+as.factor(brand2),family=Gamma(link="log"),data=baseSEV_withlim)
summary(model_severity)


#d) 
predict(model_severity,newdata=data.frame(agecut="[18,25)",brand2="1",exposition=1),type="response")

#Highest Claim
predict(model_severity,newdata=data.frame(agecut="[18,25)",brand2="10",exposition=1),type="response")

#Lowest Claim
predict(model_severity,newdata=data.frame(agecut="[25,31)",brand2="5",exposition=1),type="response")




#EXPORT TO EXCEL


capture.output(summary(model_frequency),file = "Model_freq_output.xls")

capture.output(summary(model_severity),file = "Model_sev_output.xls")

# ------------------------------------------------------------------------

# 4) Large Claims



# Fit a Logistic Regression to Large Claims

# Creating "large" variable for defininig the reporting of a big claim
baseSEV$large=baseSEV$cost>6000
tail(baseSEV$large)


# Fitting the Logistic Regression

baseSEV$agecut<-cut(baseSEV$agedriver,breaks=agedriver_lev,right=FALSE)
baseSEVbrand2=baseSEV$brand
baseSEV$brand2[baseSEV$brand%in%c("1","2","4")]="1"
baseSEV$brand2[baseSEV$brand%in%c("10","11","13")]="10"
baseSEV$brand2[baseSEV$brand%in%c("6","14","12")]="6"
baseSEV$brand2[baseSEV$brand%in%c("3","5")]="5"

 


reglogit_large<-glm(large~agecut+as.factor(brand2),family=binomial(link="logit"),data=baseSEV)
summary(reglogit_large)


# Observing the odds Ratio
exp(coefficients(reglogit_large))


# Predict the probability of reporting a large claim for a given insured profile
insured1<-data.frame(agecut="[18,25)",brand2=10)
ins1_pred<-print(predict(reglogit_large,newdata=insured1,type="response"))





