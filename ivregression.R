#load data of angrist 1991
#root<-"/Users/birdstone/Dropbox/2017-Summer-Teaching-Advnaced Methodology/Angrist1991-data"
setwd(root)
rm(list=ls())
install.packages("readstata13")
library(readstata13)
data<-read.dta13("NEW7080.dta")
data<-subset(data,select=-c(v3,v7,v8,v14,v15,v17,v22,v23,v26))
names(data)<-c("AGE","AGEQ","EDUC","ENOCENT","ESOCENT","LWKLYWGE","MARRIED","MIDATL","MT","NEWENG",
               "CENSUS","QOB","RACE","SMSA","SOATL","WNOCENT","WSOCENT","YOB")

data$COHORT<-20.29
data$COHORT[data$YOB<=39&data$YOB >=30]<-30.39
data$COHORT[data$YOB<=49&data$YOB >=40]<-40.49

data$AGEQ[data$CENSUS==80]<-data$AGEQ[data$CENSUS==80]-1900
data$AGEQSQ<-data$AGEQ*data$AGEQ

data$YR20<-0  
data$YR20[data$YOB%in%c(1920,30,40)]<-1
data$YR21<-0  
data$YR21[data$YOB%in%c(1921,31,41)]<-1
data$YR22<-0  
data$YR22[data$YOB%in%c(1922,32,42)]<-1
data$YR23<-0  
data$YR23[data$YOB%in%c(1923,33,43)]<-1
data$YR24<-0  
data$YR24[data$YOB%in%c(1924,34,44)]<-1
data$YR25<-0  
data$YR25[data$YOB%in%c(1925,35,45)]<-1
data$YR26<-0  
data$YR26[data$YOB%in%c(1926,36,46)]<-1
data$YR27<-0  
data$YR27[data$YOB%in%c(1927,37,47)]<-1
data$YR28<-0  
data$YR28[data$YOB%in%c(1928,38,48)]<-1
data$YR29<-0  
data$YR29[data$YOB%in%c(1929,39,49)]<-1

#Generate QOB dummies
data$QTR1<-0
data$QTR1[data$QOB==1]<-1
data$QTR2<-0
data$QTR2[data$QOB==2]<-1
data$QTR3<-0
data$QTR3[data$QOB==3]<-1
data$QTR4<-0
data$QTR4[data$QOB==4]<-1

#Generate YOB*QOB dummies
data$QTR120<-data$QTR1*data$YR20
data$QTR121<-data$QTR1*data$YR21
data$QTR122<-data$QTR1*data$YR22
data$QTR123<-data$QTR1*data$YR23
data$QTR124<-data$QTR1*data$YR24
data$QTR125<-data$QTR1*data$YR25
data$QTR126<-data$QTR1*data$YR26
data$QTR127<-data$QTR1*data$YR27
data$QTR128<-data$QTR1*data$YR28
data$QTR129<-data$QTR1*data$YR29

data$QTR220<-data$QTR2*data$YR20
data$QTR221<-data$QTR2*data$YR21
data$QTR222<-data$QTR2*data$YR22
data$QTR223<-data$QTR2*data$YR23
data$QTR224<-data$QTR2*data$YR24
data$QTR225<-data$QTR2*data$YR25
data$QTR226<-data$QTR2*data$YR26
data$QTR227<-data$QTR2*data$YR27
data$QTR228<-data$QTR2*data$YR28
data$QTR229<-data$QTR2*data$YR29

data$QTR320<-data$QTR3*data$YR20
data$QTR321<-data$QTR3*data$YR21
data$QTR322<-data$QTR3*data$YR22
data$QTR323<-data$QTR3*data$YR23
data$QTR324<-data$QTR3*data$YR24
data$QTR325<-data$QTR3*data$YR25
data$QTR326<-data$QTR3*data$YR26
data$QTR327<-data$QTR3*data$YR27
data$QTR328<-data$QTR3*data$YR28
data$QTR329<-data$QTR3*data$YR29

data<-subset(data,COHORT<20.30)


##linaer regression
lm_model<-lm(LWKLYWGE~EDUC+RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
             SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ,data=data)
summary(lm_model)

##manual 2sls
firststage<-lm(EDUC~RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
                   SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ+
                   QTR120+QTR121+QTR122+QTR123+QTR124+QTR125+QTR126+QTR127+QTR128+QTR129+
                   QTR220+QTR221+QTR222+QTR223+QTR224+QTR225+QTR226+QTR227+QTR228+QTR229+
                   QTR320+QTR321+QTR322+QTR323+QTR324+QTR325+QTR326+QTR327,data=data)
summary(firststage)
data$EDUC_FIT<-fitted(firststage)
secondstage<-lm(LWKLYWGE~EDUC_FIT+RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
                    SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ,data=data)
summary(secondstage)

##ivreg
library(AER)
iv_model<-ivreg(LWKLYWGE~EDUC+RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
                           SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ|
                    RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
                    SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ+
                    QTR120+QTR121+QTR122+QTR123+QTR124+QTR125+QTR126+QTR127+QTR128+QTR129+
                    QTR220+QTR221+QTR222+QTR223+QTR224+QTR225+QTR226+QTR227+QTR228+QTR229+
                    QTR320+QTR321+QTR322+QTR323+QTR324+QTR325+QTR326+QTR327+QTR328+QTR329
                    ,data=data)
summary(iv_model)

##diagnose of ivmodel
summary(iv_model,diagnostics=TRUE)

##Is the model endogeneous?
#direct test
#run 1st stage regression to get residuals
data$re<-residuals(firststage)
#add the residuals to 2nd regression
endo_test<-lm(LWKLYWGE~EDUC+re+RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
                  SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ,data=data)
summary(endo_test)
library(sandwich)
coeftest(endo_test)
##correllation test
#direct test by linear regression to see the p value. Someone insistes F>10 is needed to caim a strong enough IV.
#However Angrist deosn't care about that.
summary(lm(EDUC~QTR120+QTR121+QTR122+QTR123+QTR124+QTR125+QTR126+QTR127+QTR128+QTR129+
               QTR220+QTR221+QTR222+QTR223+QTR224+QTR225+QTR226+QTR227+QTR228+QTR229+
               QTR320+QTR321+QTR322+QTR323+QTR324+QTR325+QTR326+QTR327+QTR328+QTR329,data=data))

##https://www.r-bloggers.com/detecting-weak-instruments-in-r/
library(mvtnorm)
firststage_n<-lm(EDUC~RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
       SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ,data=data)
#y1<-lm(EDUC~RACE+MARRIED+SMSA,data=data)
#y2<-lm(EDUC~RACE,data=data)
#waldtest(y1, y2)
waldtest(firststage, firststage_n)$F[2]
waldtest(firststage, firststage_n, vcov = vcovHC(firststage, type="HC0"))$F[2]


####################################################
# now lets get some F-tests robust to clustering
# generate cluster variable
dat$cluster = 1:n
# repeat dataset 10 times to artificially reduce standard errors
dat = dat[rep(seq_len(nrow(dat)), 10), ]
# re-run first-stage regressions
fs = lm(y1 ~ x1 + z1, data = dat)
fn = lm(y1 ~ x1, data = dat)
# simple F-test
waldtest(fs, fn)$F[2]
# ~ 10 times higher!
# F-test robust to clustering
waldtest(firststage, firststage_n, vcov = clusterVCV(data, firststage, cluster1="YOB"))$F[2]
#function cluster VCV
clusterVCV <- function(data, fm, cluster1, cluster2=NULL) {
    require(sandwich)
    require(lmtest)
    
    # Calculation shared by covariance estimates
    est.fun <- estfun(fm)
    inc.obs <- complete.cases(data[,names(fm$model)])
    
    # Shared data for degrees-of-freedom corrections
    N  <- dim(fm$model)[1]
    NROW <- NROW(est.fun)
    K  <- fm$rank
    
    # Calculate the sandwich covariance estimate
    cov <- function(cluster) {
        cluster <- factor(cluster)
        
        # Calculate the "meat" of the sandwich estimators
        u <- apply(est.fun, 2, function(x) tapply(x, cluster, sum))
        meat <- crossprod(u)/N
        
        # Calculations for degrees-of-freedom corrections, followed 
        # by calculation of the variance-covariance estimate.
        # NOTE: NROW/N is a kluge to address the fact that sandwich uses the
        # wrong number of rows (includes rows omitted from the regression).
        M <- length(levels(cluster))
        dfc <- M/(M-1) * (N-1)/(N-K)
        dfc * NROW/N * sandwich(fm, meat=meat)
    }
    
    # Calculate the covariance matrix estimate for the first cluster.
    cluster1 <- data[inc.obs,cluster1]
    cov1  <- cov(cluster1)
    
    if(is.null(cluster2)) {
        # If only one cluster supplied, return single cluster
        # results
        return(cov1)
    } else {
        # Otherwise do the calculations for the second cluster
        # and the "intersection" cluster.
        cluster2 <- data[inc.obs,cluster2]
        cluster12 <- paste(cluster1,cluster2, sep="")
        
        # Calculate the covariance matrices for cluster2, the "intersection"
        # cluster, then then put all the pieces together.
        cov2   <- cov(cluster2)
        cov12  <- cov(cluster12)
        covMCL <- (cov1 + cov2 - cov12)
        
        # Return the output of coeftest using two-way cluster-robust
        # standard errors.
        return(covMCL)
    }
}

##gmm errors with our data(to be overcome)
#install.packages('plyr')
#install.packages('gmm')
library(plyr)
library(gmm)
##this is from R-bloggers("author diffuseprior")
sum2 = function(x){
    s<-0
    for (i in 1: length(x)){
        s<-s+x[i]
    }
}
gmmcl = function(formula1, formula2, data, cluster){
    library(plyr) ; library(gmm)
    # create data.frame
    data$id1 = 1:dim(data)[1]
    formula3 = paste(as.character(formula1)[3],"id1", sep=" + ")
    formula4 = paste(as.character(formula1)[2], formula3, sep=" ~ ")
    formula4 = as.formula(formula4)
    formula5 = paste(as.character(formula2)[2],"id1", sep=" + ")
    formula6 = paste(" ~ ", formula5, sep=" ")
    formula6 = as.formula(formula6)
    frame1 = model.frame(formula4, data)
    frame2 = model.frame(formula6, data)
    dat1 = join(data, frame1, type="inner", match="first")
    dat2 = join(dat1, frame2, type="inner", match="first")
    # matrix of instruments
    Z1 = model.matrix(formula2, dat2)
    
    # step 1
    gmm1 = gmm(formula1, formula2, data = dat2, 
               vcov="TrueFixed", weightsMatrix = diag(dim(Z1)[2]))
    # clustering weight matrix
    cluster = factor(dat2[,cluster])
    u = residuals(gmm1)
    estfun = sweep(Z1, MARGIN=1, u,'*')
    u = apply(estfun, 2, function(x) tapply(x, cluster, sum))  
    S = 1/(length(residuals(gmm1)))*crossprod(u)
    # step 2
    gmm2 = gmm(formula1, formula2, data=dat2, 
               vcov="TrueFixed", weightsMatrix = solve(S))
    return(gmm2)
}

formula_first<-EDUC~RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
    SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ
formula_second<-~QTR120+QTR121+QTR122+QTR123+QTR124+QTR125+QTR126+QTR127+QTR128+QTR129+
    QTR220+QTR221+QTR222+QTR223+QTR224+QTR225+QTR226+QTR227+QTR228+QTR229+
    QTR320+QTR321+QTR322+QTR323+QTR324+QTR325+QTR326+QTR327+
    RACE+MARRIED+SMSA+NEWENG+MIDATL+ENOCENT+WNOCENT+ 
    SOATL+ESOCENT+WSOCENT+MT+YR20+YR21+YR22+YR23+YR24+YR25+YR26+YR27+YR28+AGEQ+AGEQSQ
summary(gmmcl(formula_first, formula_second , data = data2, cluster = "YOB"))

#data2 = rbind(data,data)
#data<-data2
#formula1<-formula_first
#formula2<-formula_second










