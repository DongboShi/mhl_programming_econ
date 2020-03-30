# Lecture5
# 1. Apply家族
# 1.1 apply
# 矩阵求每一行的和
x<-matrix(1:12,ncol=3)

x <- matrix(1:12, ncol = 3)
# 求每一行的平均数

for(i in 1:4){
        print(mean(x[i,]))
}

apply(x, 1, mean)

apply(x, 2, mean)

# ？求每一行的最大值
apply(x, 1, max)

# 按行循环，让数据框或者矩阵的x1列加1，并计算出x1,x2列的均值
x <- cbind(x1 = 3, x2 = c(4:1, 2:5))

v1 <- x[,1]+1
v2 <- x[,2]
(v1+v2)/2

# for循环实现上面的过程
for(i in 1:8){
        print(mean(c((x[i,1]+1),x[i,2])))
}


# 自定义函数myFUN，
# 第一个参数x为数据，
# 第二、三个参数为自定义参数，可以通过apply的'...'进行传入。
myFUN<- function(x, c1, c2) {
        x[c1] <- x[c1]+1
        mean(x[c2]) 
}
apply(x,1,myFUN,c1='x1',c2=c('x1','x2'))

# apply(x,2,myFUN,c1='x1',c2=c('x1','x2'))错误，行没有名称

# 上述计算for循环如何实现？
# 有别的计算方法吗？

# 1.2 lapply
x <- list(a = 1:10, b = rnorm(6,10,5), c = c(TRUE,FALSE,FALSE,TRUE))
x <- list(a = 1:10, b = rnorm(6,10,5), c = c(TRUE, FALSE, FALSE, TRUE))

# 分别计算每个元素对应该的数据的分位数
lapply(x,fivenum)
#?fivenum
# 1.3 sapply 
x <- data.frame(x1=3, x2=c(2:1,4:5))
x <- data.frame(x1=3, x2 = c(2:1,4:5))

sapply(x, sum) # 返回了一个向量
class(sapply(x, sum))
#apply(x,2,sum)
class(lapply(x, sum))
#lapply(x,sum)
# 如果simplify=FALSE和USE.NAMES=FALSE，那么完全sapply函数就等于lapply函数了
# 对于字符串的向量，还可以自动生成数据名
val<-head(letters)
sapply(val,paste,USE.NAMES=TRUE)

# 1.4 vapply
x <- data.frame(cbind(x1=3, x2=c(2:1,4:5)))
vapply(x,cumsum,FUN.VALUE=c('a'=0,'b'=0,'c'=0,'d'=0))
vapply(x,cumsum,FUN.VALUE = c("a" = 0, "b" =0, "c" = 0, "d" = 0))
sapply(x,cumsum)
vapply(x,cumsum) # error

#------------------------------
# 1.5 mapply
x<-1:10
y<-5:-4
z<-round(runif(10,-5,5)) # runif 自己查
# round
X <- t(rbind(x,y,z))
#apply(X,1,max)
#map 映射
mapply(max,x,y,z)

# 2. 数据操纵 
# # install.packages("devtools")
# devtools::install_github("rstudio/EDAWR")
library(EDAWR)
storms
cases #A subset of data from the World Health Organization Global Tuberculosis Report.










