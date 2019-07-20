#http://www.sthda.com/english/wiki/survival-analysis-basics
#http://www.sthda.com/english/wiki/cox-proportional-hazards-model
install.packages(c("survival", "survminer"))
library("survival")
library("survminer")
data("lung")
head(lung)
#inst: Institution code
#time: Survival time in days
#status: censoring status 1=censored, 2=dead
#age: Age in years
#sex: Male=1 Female=2
#ph.ecog: ECOG performance score (0=good 5=dead)
#ph.karno: Karnofsky performance score (bad=0-good=100) rated by physician
#pat.karno: Karnofsky performance score as rated by patient
#meal.cal: Calories consumed at meals
#wt.loss: Weight loss in last six months

#The function survfit() [in survival package] can be used to compute kaplan-Meier survival estimate. Its main arguments include:a survival object created using the function Surv()
#and the data set containing the variables.To compute survival curves, type this:
fit <- survfit(Surv(time, status) ~ sex, data = lung)
print(fit)
# Summary of survival curves
summary(fit)
# Access to the sort summary table
summary(fit)$table
#Visualize survival curves
d <- data.frame(time = fit$time,
                n.risk = fit$n.risk,
                n.event = fit$n.event,
                n.censor = fit$n.censor,
                surv = fit$surv,
                upper = fit$upper,
                lower = fit$lower)
head(d)

#Visualize survival curves

ggsurvplot(fit,
           pval = TRUE, conf.int = TRUE,
           risk.table = TRUE, # Add risk table
           risk.table.col = "strata", # Change risk table color by groups
           linetype = "strata", # Change line type by groups
           surv.median.line = "hv", # Specify median survival，Allowed values include one of c(“none”, “hv”, “h”, “v”)
           ggtheme = theme_bw(), # Change ggplot2 theme
           palette = c("#E7B800", "#2E9FDF"))

ggsurvplot(
    fit,                     # survfit object with calculated statistics.
    pval = TRUE,             # show p-value of log-rank test.
    conf.int = TRUE,         # show confidence intervals for 
    # point estimaes of survival curves.
    conf.int.style = "step",  # customize style of confidence intervals
    xlab = "Time in days",   # customize X axis label.
    break.time.by = 200,     # break X axis in time intervals by 200.
    ggtheme = theme_light(), # customize plot and risk table with a theme.
    risk.table = "abs_pct",  # absolute number and percentage at risk.
    risk.table.y.text.col = T,# colour risk table text annotations.
    risk.table.y.text = FALSE,# show bars instead of names in text annotations
    # in legend of risk table.
    ncensor.plot = TRUE,      # plot the number of censored subjects at time t
    surv.median.line = "hv",  # add the median survival pointer.
    legend.labs = 
        c("Male", "Female"),    # change legend labels.
    palette = 
        c("#E7B800", "#2E9FDF") # custom color palettes.
)

#The survival curves can be shorten using the argument xlim as follow:
ggsurvplot(fit,
           conf.int = TRUE,
           risk.table.col = "strata", # Change risk table color by groups
           ggtheme = theme_bw(), # Change ggplot2 theme
           palette = c("#E7B800", "#2E9FDF"),
           xlim = c(0, 600))

#to plot cumulative events, type this:
ggsurvplot(fit,
           conf.int = TRUE,
           risk.table.col = "strata", # Change risk table color by groups
           ggtheme = theme_bw(), # Change ggplot2 theme
           palette = c("#E7B800", "#2E9FDF"),
           fun = "event")
#To plot cumulative hazard, type this:
ggsurvplot(fit,
           conf.int = TRUE,
           risk.table.col = "strata", # Change risk table color by groups
           ggtheme = theme_bw(), # Change ggplot2 theme
           palette = c("#E7B800", "#2E9FDF"),
           fun = "cumhaz")
#Kaplan-Meier life table: summary of survival curves
res.sum <- surv_summary(fit)
head(res.sum)
attr(res.sum, "table")

#Fit complex survival curves
#Fit (complex) survival curves using colon data sets
fit2 <- survfit( Surv(time, status) ~ sex + rx + adhere,
                 data = colon )
#Visualize the output using survminer. 
#The plot below shows survival curves by the sex variable 
#faceted according to the values of rx & adhere.

ggsurv <- ggsurvplot(fit2, fun = "event", conf.int = TRUE,
                     ggtheme = theme_bw())

ggsurv$plot +theme_bw() + 
    theme (legend.position = "right")+
    facet_grid(rx ~ adhere)



###############################################################
##Cox Proportional-Hazards Model
###############################################################
#coxph(formula, data, method)
data("lung")
head(lung)

res.cox <- coxph(Surv(time, status) ~ sex, data = lung)
res.cox
summary(res.cox)
#To apply the univariate coxph function to multiple covariates at once, type this:
covariates <- c("age", "sex",  "ph.karno", "ph.ecog", "wt.loss")
univ_formulas <- sapply(covariates,
                        function(x) as.formula(paste('Surv(time, status)~', x)))
univ_models <- lapply( univ_formulas, function(x){coxph(x, data = lung)})
univ_results <- lapply(univ_models,
                       function(x){ 
                           x <- summary(x)
                           p.value<-signif(x$wald["pvalue"], digits=2)
                           wald.test<-signif(x$wald["test"], digits=2)
                           beta<-signif(x$coef[1], digits=2);#coeficient beta
                           HR <-signif(x$coef[2], digits=2);#exp(beta)
                           HR.confint.lower <- signif(x$conf.int[,"lower .95"], 2)
                           HR.confint.upper <- signif(x$conf.int[,"upper .95"],2)
                           HR <- paste0(HR, " (", 
                                        HR.confint.lower, "-", HR.confint.upper, ")")
                           res<-c(beta, HR, wald.test, p.value)
                           names(res)<-c("beta", "HR (95% CI for HR)", "wald.test", 
                                         "p.value")
                           return(res)
                           #return(exp(cbind(coef(x),confint(x))))
                       })
res <- t(as.data.frame(univ_results, check.names = FALSE))
as.data.frame(res)

##Multivariate Cox regression analysis

res.cox <- coxph(Surv(time, status) ~ age + sex + ph.ecog, data =  lung)
summary(res.cox)

#Visualizing the estimated distribution of survival times
ggsurvplot(survfit(res.cox), color = "red",data=lung,
           ggtheme = theme_minimal())
sex_df <- with(lung,
               data.frame(sex = c(1, 2), 
                          age = rep(mean(age, na.rm = TRUE), 2),
                          ph.ecog = c(1, 1)
               )
)
sex_df

fit <- survfit(res.cox, newdata = sex_df)
ggsurvplot(fit, conf.int = TRUE, legend.labs=c("Sex=1", "Sex=2"),data=lung,
           ggtheme = theme_minimal())


##########time dependent covariates
cgd0[1:4,]
dim(cgd0)
newcgd<-tmerge(data1 = cgd0[,1:13],data2 = cgd0, id = id, tstop = futime)
newcgd<-tmerge(newcgd, cgd0, id = id, infect = event(etime1))
newcgd<-tmerge(newcgd, cgd0, id = id, infect = event(etime2))
newcgd<-tmerge(newcgd, cgd0, id = id, infect = event(etime3))
newcgd<-tmerge(newcgd, cgd0, id = id, infect = event(etime4))
newcgd<-tmerge(newcgd, cgd0, id = id, infect = event(etime5))
newcgd<-tmerge(newcgd, cgd0, id = id, infect = event(etime6))
newcgd<-tmerge(newcgd, cgd0, id = id, infect = event(etime7))
newcgd<-tmerge(newcgd, newcgd, id = id, enum = cumtdc(tstart))

dim(newcgd)

coxph(Surv(tstart,tstop,infect) ~ treat + inherit + steroids + cluster(id), newcgd)

jasa$subject<-1:nrow(jasa)
tdata <- with(jasa, data.frame(subject = subject, 
                               futime = pmax(.5, fu.date - accept.dt),
                               txtime = ifelse(tx.date == fu.date,
                                               (tx.date - accept.dt)- .5,
                                               (tx.date - accept.dt)),
                               fustat = fustat))
sdata <- tmerge(jasa, tdata, id = subject,
                death = event (futime, fustat),
                trt = tdc(txtime),
                options = list(idname = 'subject'))
attr(sdata, 'tcount')
sdata$age <- sdata$age -48
sdata$year <- (as.numeric(sdata$accept.dt - as.Date('1967-10-01'))/365.25)
coxph(Surv(tstart,tstop,death) ~ age*trt + surgery + year,
      data = sdata, ties = 'breslow')

########pbc data
temp <- subset(pbc,id <= 312,select = c(id:sex,stage))
pbc2 <- tmerge(temp, temp, id = id, death = event(time, status))
pbc2 <- tmerge(pbc2, pbcseq, id = id, ascites = tdc(day, ascites),
               bili = tdc(day, bili), albumin = tdc(day, albumin),
               protime = tdc(day, protime), alk.phos = tdc(day, alk.phos))
fit1 <- coxph(Surv(time, status == 2) ~ log(bili) + log(protime), pbc)
fit2 <- coxph(Surv(tstart, tstop, death == 2) ~ log(bili) + log(protime), pbc2)
rbind('baseline fit' = coef(fit1),
      'time dependent' = coef(fit2))
attr(pbc2, 'tcount')













