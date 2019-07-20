##DID 
#root<-"/Users/birdstone/Dropbox/2017-Summer-Teaching-Advnaced Methodology/Angrist1991-data"
setwd(root)
rm(list=ls())
install.packages("plm")
library(plm)
data("EmplUK", package="plm")
data("Produc", package="plm")
data("Grunfeld", package="plm")
data("Wages", package="plm")

head(Grunfeld)
E<-pdata.frame(EmplUK, index=c("firm","year"), drop.index=TRUE, row.names=TRUE)
head(attr(E, "index"))
summary(E$emp)
head(as.matrix(E$emp))

head(lag(E$emp, 0:2))
head(diff(E$emp), 10)
head(lag(E$emp, 2), 10)
head(Within(E$emp))
head(between(E$emp), 4)
head(Between(E$emp), 10)

grun.fe <- plm(inv~value+capital, data = Grunfeld, model = "within",index=c('firm','year'))

grun.re <- plm(inv~value+capital, data = Grunfeld, model = "random",index=c('firm','year'))
summary(grun.re)
summary(grun.fe)
fixef(grun.fe, type = 'dmean')
summary(fixef(grun.fe, type = 'dmean'))
summary(fixef(grun.fe, type = 'dmean'))



##Synthetic Controls method
install.packages('Synth')
library(Synth)
data("basque")
basque[85:89, 1:4]

#The first step is to reorganize the panel dataset into an appropriate format that is suitable 
#for the main estimator function synth()
#At a minimum, synth() requires as inputs the four data matrices

dataprep.out <- dataprep(
    foo = basque,
    predictors = c("school.illit", "school.prim", "school.med",
                     "school.high", "school.post.high", "invest"),
    predictors.op = "mean",
    time.predictors.prior = 1964:1969,
    special.predictors = list(
        list("gdpcap", 1960:1969 , "mean"),
        list("sec.agriculture", seq(1961, 1969, 2), "mean"),
        list("sec.energy", seq(1961, 1969, 2), "mean"),
        list("sec.industry", seq(1961, 1969, 2), "mean"),
        list("sec.construction", seq(1961, 1969, 2), "mean"),
        list("sec.services.venta", seq(1961, 1969, 2), "mean"),
        list("sec.services.nonventa", seq(1961, 1969, 2), "mean"),
        list("popdens", 1969, "mean")),
    dependent = "gdpcap",
    unit.variable = "regionno",
    unit.names.variable = "regionname",
    time.variable = "year",
    treatment.identifier = 17,
    controls.identifier = c(2:16, 18),
    time.optimize.ssr = 1960:1969,
    time.plot = 1955:1997)

#dataprep() returns a list object dataprep.out that contains several elements, among them 
#dataprep.out$X0 and dataprep.out$X1, denoting X0 and X1 respectively. Both of these
#objects are easily interpreted, as variable labels have been retained
dataprep.out$X1
dataprep.out$X0
dataprep.out$Z1

dataprep.out$X1["school.high",] <- dataprep.out$X1["school.high",] +dataprep.out$X1["school.post.high",]
dataprep.out$X1 <- as.matrix(dataprep.out$X1[-which(rownames(dataprep.out$X1) == "school.post.high"),])
dataprep.out$X0["school.high",] <- dataprep.out$X0["school.high",] +dataprep.out$X0["school.post.high",]
dataprep.out$X0 <- dataprep.out$X0[-which(rownames(dataprep.out$X0) == "school.post.high"),]
lowest <- which(rownames(dataprep.out$X0) == "school.illit")
highest <- which(rownames(dataprep.out$X0) == "school.high")
dataprep.out$X1[lowest:highest,] <-(100 * dataprep.out$X1[lowest:highest,]) /sum(dataprep.out$X1[lowest:highest,])
dataprep.out$X0[lowest:highest,] <-100 * scale(dataprep.out$X0[lowest:highest,], center = FALSE,scale = colSums(dataprep.out$X0[lowest:highest,]))

#Running synth()
synth.out <- synth(data.prep.obj = dataprep.out, method = "BFGS")
#Obtaining Results: Tables, Figures, and Estimates
gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
gaps[1:3, 1]
synth.tables <- synth.tab(dataprep.res = dataprep.out,synth.res = synth.out)
names(synth.tables)
synth.tables$tab.pred[1:5, ]
synth.tables$tab.w[8:14, ]

path.plot(synth.res = synth.out, dataprep.res = dataprep.out,
          Ylab = "real per-capita GDP (1986 USD, thousand)", Xlab = "year",
          Ylim = c(0, 12), Legend = c("Basque country","synthetic Basque country"), 
          Legend.position = "bottomright")

gaps.plot(synth.res = synth.out, dataprep.res = dataprep.out,
          Ylab = "gap in real per-capita GDP (1986 USD, thousand)", Xlab = "year",
          Ylim = c(-1.5, 1.5), Main = NA)










