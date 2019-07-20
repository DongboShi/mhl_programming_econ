#regrssion discontinuiry
root<-"/Users/birdstone/Dropbox/2017-Summer-Teaching-Advnaced Methodology"
setwd(root)
rm(list=ls())
install.packages("rdd")
library(rdd)

x<-runif(1000,-1,1)
cov<-rnorm(1000)
y<-3+2*x+3*cov+10*(x>=0)+rnorm(1000)
data<-as.data.frame(cbind(y,x))
rd<-RDestimate(y~x,data=data)
summary(rd)
##plot 
plot(rd)

 


