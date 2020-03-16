# Lecture3

# 上周课程的统计结果


# 纠正一个错误：逻辑运算不满足结合律
!F&F
!(F&F)

# 难点回顾

# v1[v1 %in% v3] 请问这个代码是什么意思？我没有理解
# v1[c(1,3)] 其中c(1,3)为什么可以代表取第几个？

# tmp
# 导入Excel没成功之后跟不上
# as.number之类的那部分
# 导入文件之类的

#--------------------------
# 1. data.frame 赋值与操纵
# 行名

# 自行生成一个dataframe

name <- c("xiaohong","xiaohuang","xiaobai","xiaoju","xiaohua")
ID <- seq(1,5)
color <- c("red","yellow","white","orange","rainbow")
day <- rep("Mon",5)
trip <- data.frame(name,ID,color,day)
row.names(trip)
row.names(trip) <- as.character(seq(11,15))
# 列名
names(trip) <- c("name","id","color","day")
names(trip)[2] <- "ID"
# 选出列
trip$name
# trip <- data.frame(trip) 
# read_excel 读入之后会生成tibble，tibble是一个有更多属性的dataframe
# 第三单元tidyverse的时候会讲到，先留一个坑

# 查看data
View(trip) # 非常不推荐
head(trip,20)
# Fator 数据类型 数字化的字符数据,有两个属性，一个是level，一个是value
levels(trip$name) <- c("xiaohong", "xiaohuang","xiaobai","xiaoju","xiaohua"  )
as.character(trip$name)
# data.frame 默认转化character到factor，疑问：如何改掉这个操作？

# 取出特定行
trip[c(1,3)]
trip[trip$name=="xiaobai"] # 取出第三列
trip[trip$name=="xiaohua"|trip$ID > 3,]

# 去重复
trip_r <- rbind(trip, trip)
duplicated(trip_r)
trip_d <- trip_r[duplicated(trip_r),]

# 删除列
trip$newcol <- "new"
trip <- trip[c("name","ID","color","day")]
names(trip)[names(trip) != "newcol"]
trip[names(trip)[names(trip) != "newcol"]]
# select(trip,-newcol) 第三单元的内容，留一个坑
trip$newcol <- NULL
# 有没有别的办法达到同样的效果？

# 保留完整记录complete.cases
trip$ID[2] <- NA
complete.cases(trip)
trip[complete.cases(trip),]
# 去列是不需要加逗号的
# 如果我想把ID的NA保留，改成999，应该怎么操作
# 1.找到NA
is.na(trip$ID)
# 2.赋值
trip$ID[is.na(trip$ID)] <- 999

#--------------------------
# 2. list 与 matrix 的
lt1 <- list(c(1,2,3),c("x"))
lt1[[2]]

mt1 <- matrix(1:6,2,3)
t(mt1)
# 数值计算经常用到，机器学习的默认的数据结构默认的是mt不是df，但是现在用的比较少

#--------------------------
# 3. 控制流程
# if - else 控制流程，

v1 <- 1:25
v2 <- 1:10
# 判断长度小于15的向量，并输出
# if(逻辑运算){
#         执行语句
# }else(判断语句2){
#         执行语句2
# }

if(length(v1)>length(v2)){
        print(v1)
}else{
        print(v2)
}

x <- 100
y <- 20 

if(x > y){
        print(x)
}else{
        print(y)
}
v3 <- c("b","c")
# for 循环
for(i in v3){
        print(i)
}

# while 循环
i <- 1
while(i < 100){
        print(i)
        i <- i + 1
}
# repeat 循环（课后自学）
# repeat{
#         if(){break}
# }

#练习：输出1~100所有整除3的数

#-------------------------
# 4.函数-先讲案例，然后有时间再细致地讲函数
# 参数，默认参数值
# 返回值
# 全局变量与局部变量，尽量不要隐性的使用全局变量
# 查看帮助/文档
# 函数的调试
# 拯救小红任务中的函数化
is.na(trip$ID)

#-------------------------
# 5.包
# 不要重复造轮子
# 包的安装与加载
# 可以自己写包-数据包，特定功能的包，大杂烩
# 包的学习与使用
# install.packages("readxl")
library(readxl)
trip <- data.frame() # 空文件
# 循环列表就是文件名称
setwd("~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/Lecture2")
filelist <- list.files() # 怎么处理csv文件，留着后面讲
#filelist <- list.files(path = "~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/Lecture2")
for(i in filelist){
        tmp <- read_excel(i, sheet = "Sheet1") # 问题：tmp就是直接赋值的
        trip <- rbind(trip, tmp)
        print(i)
}

write.csv(trip,file = "~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/trip.csv", row.names = F)

#-------------------------
# 6.数据IO
# 读入csv、stata、excel、txt、spss
# 写出csv
# 写出图片（留一个尾巴）
# RData
save.image("~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/lecture2.RData")
save(trip,file = "~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/lecture2_2.RData")
# 读入RData
load("~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/lecture2_2.RData")
load("~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/lecture2.RData")
# 不用记忆导入函数
library(haven)
dta_Data <- read_dta("~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/Lecture3/pres08_ga.dta")
library(readr)
pres_returns <- read_csv("~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/Lecture3/pres_returns.csv")

# write.csv()


#-------------------------
# 课堂练习 
# 拯救小红系列之二：计算绩效工资
# 小红毕业之后如愿以偿成为了一家民营企业100强公司的HR
# 小红每个月都要为他的同事计算绩效奖金，计算的逻辑是这样的：
# 1.每一个产品（product）都有四种类型：A,L,E,R；
# 2.每个产品在每年都会进过一轮质量评估，评估的分数被记录在IF里面；
# 3.每一个工厂（plant）对于不同的产品质量（IF）设立了奖励的标准，
# 这个标准可能是阶梯式的，也可能是滑梯式的；
# 4.同一质量不同类型的产品也可能有不同的奖励标准，奖励标准记录在price2
# 5.集团公司也有自己的奖励标准记录在price1里面

# 请你救救小红吧，一般年纪了，还是个单身狗！
# 帮他计算出来每一个产品的奖金

# 面向过程的编程/面向对象的编程
rm(list = ls())

# 1.输入数据 price.csv和product.csv
setwd("~/Dropbox/dropbox_old/Teaching-Programming/2020/Data/Lecture3")
price <- read_csv("price.csv")
product <- read_csv("product.csv")

# 2.product里面生成两列分别是price1，和price2，分别记录了集团和工厂对这个产品的奖励标准
# 
product$price1 <- ""
product$price2 <- ""

# 3. 根据每个product的plant， type， year， if来判断价格取哪一行
# 4. 判断完成后赋值


for(i in 1:1000){
        p <- product$plant[i]
        y <- product$year[i]
        t <- product$type[i]
        IF <- product$IF[i]
        price1 <- price$price1[price$plant==p & 
                                       price$year ==y & 
                                       price$jif_lower <= IF &
                                       price$jif_upper > IF & 
                                       str_detect(price$type1, t)][1]
        price2 <- price$price2[price$plant==p & 
                                       price$year ==y & 
                                       price$jif_lower <= IF &
                                       price$jif_upper > IF &
                                       str_detect(price$type2, t)][1]
        product$price1[i] <- price1
        product$price2[i] <- price2
        print(i)
}
#小样本案例
product_sample <- product[1:1000,]
for(i in 1:1000){
        if(!is.na(product_sample$price2[i]) & str_detect(product_sample$price2[i],"IF")){
                IF <- product_sample$IF[i]
                product_sample$price2[i] <- eval(parse(text=product_sample$price2[i]))
        }
        print(i)
}


# 两个小抄:
# 1. 数学表达式的提炼神器，例如
# IF = 5
# a <- "(IF*10000+20000)*0.5"
# eval(parse(text=a))

# 2. 判断一个字符是否存在与另一个字符串中，使用str_detect函数
# library(stringr)
# str_detect("A000C","A")
# str_detect("A","A000C")

#------------------------
# 7.R土特产-apply函数族，不一定有时间讲

#-------------------------
# Linux 命令
#-------------------------
# R发邮件



