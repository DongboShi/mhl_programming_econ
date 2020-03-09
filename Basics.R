#--------------------------------------
# R语言基础
# 学习目标
# 1.安装R与RStudio
# 2.RStudio的环境配置
# 脚本
# 3.像计算器一样使用R
# 4.数据类型与数据结构
# 5.控制流程
# 6.输入输出
#-------------------------------------
# 1-2.安装R与Rstudio，配置Rstudio的工作环境
#-------------------------------------
# 3. 像计算器一样使用R
# 四则运算
1+1
3.14*256
pi*256
pi
36/6
5-3
2^(1/2)
# 逻辑运算：与或非
3 > 2
3 >= 2
3 >= 4
# a > b ?为什么报错 
3 = 2 # ?为什么报错？
a = 2 # 变量赋值
# 在R语言里，= 表示赋值，不表示相等；== 表示相等
3 == 2
# <, >, >=, <=, ==, !=
3 != 2

# “与”运算 
3 > 2 & 3 != 2
3 > pi & 3 != 2

# “或”运算 |
3 > pi | 3 != 2
# “非”运算 
! 3 > 2

# 结合律
3*(4-2)
3 > 2 & (3 != 2 | 36 == 4)

sum(2,3,4,pi)
min(3,2,5)
max(3,2,5)

5 %% 2
5 %/% 2

#--------------------------------------
# 4.数据类型与数据结构
# 数字型:整数（integer），浮点数（double）、复数（complex）、字符串（character）、逻辑值（logical）
# 数字型 例如 1；2.3
# 字符串 
"abcd"
"阿波次的"
'abcd'
# a > b ?为什么报错 
"aa" > "a"

a = 2 
a <- 2
a <- 2

# alt 

aa <- "name"

# 
aaa <- F
AAA <- T     

# 数据类型的判断与转换
is.numeric(a)
is.character(a)
is.logical(a)
class(a)
class(aa)

# 数字变成字符串
a <- as.character(a)
class(a)
a <- 2
# 字符型转数字型
as.numeric(a)
as.numeric(aa)
# 数字型和逻辑型
b <- T
as.numeric(b)
as.numeric(F)
c <- 3
as.logical(c)
# 逻辑型和字符型
as.logical(aa)
as.character(b)

# 字符很强，所有其他都可以转字符
# 数字和逻辑可以互相转
# 字符-数字，字符-逻辑

# 数据类型的强制换

# 数字型在和字符型做逻辑判断的时候，会被强制转化成字符型
"2" == a

# rm(AAA, aaa)
# ---------------------
# 向量，seq，rep
v1 <- c(1,2,3,4,5)
v2 <- c("a","b","c")

v1 <- seq(1,9,2)
v3 <- rep(1,5)
v4 <- rep("a",5)

v5 <- c(T,F,T)

# 向量拼接
v6 <- c(v1,v2)
class(v6)
# 一个向量，只能储存一种类型的数据
# 向量indexing %in%
v1[3]
c(v1[1],v1[3])

v1[c(1,3)]

# v1 同时也属于v3的元素
v1[c(T,F,T,F,F)]

v1[v1 %in% v3]

# 向量>- 二维化：矩阵或者data.frame

# 作弊读入一个文件作为例子
library(readxl)
df <- read_excel("1037809.xlsx", sheet = "Sheet1")
# data.frame
v2 <- c("a", "b", "c", "d", "e")
df1 <- data.frame(v1,v2)

# 新建一列
df1$v3new <- v3

df2 <- data.frame(v1,v2,v3)

df1[1,1]
df1[1, ]
df1[,1]
df1$v1
# data.frame的行列名称,行名称怎么改？思考题
names(df1) <- c("CL1","CL2","CL3")

# data.frame的拼接
cbind()
rbind()
names(df1) <-  names(df2)
rbind(df1,df2)
cbind(df1,df2)

# 新建列

# list list(a=1,b="Apple",c=TRUE,d=1:3) 下节课回来讲
# append(a,b)
# 课后作业：认知矩阵、数组、list

#---------------------------------------
# 5.控制流程
# if else、else if
# for 循环
# while 循环
# repeat 循环
# 人脑设计一个工作流，告诉电脑怎么做，当然以电脑听懂的语言

# 1.找到要读的文件
# 2.按照文件顺序，每一个读入电脑
# 3.针对每一个读入的文件，把他们合并起来
# 4.储存输出

# 如何让电脑重复同一个动作！循环结构
for(i in seq(1:100)){
        print(i)
}

# 小红的任务
# 执行语句是什么？读入单个文件并且合并
# i 是文件名称

install.packages("readxl")
trip <- data.frame()
rm(trip)
setwd("~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/Lecture2")
filelist <- list.files() # 怎么处理csv文件，留着后面讲
for(i in filelist){
        tmp <- read_excel(i, sheet = "Sheet1") # 问题：tmp就是直接赋值的
        trip <- rbind(trip, tmp)
        print(i)
}

write.csv(trip,file = "trip.csv", row.names = F)

# 课后的自学内容：df的行名称、list，matrix，array
# 包安装的各种问题
# 往年的代码发出来

#---------------------------------------
# 6. 输入和输出
# 工作路径
# 树形结构
# list.files()
# save
# write.csv
#---------------------------------------


# 

