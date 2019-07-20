library(stringr)
metaChar = c("$","*","+",".","?","[","^","{","|","(","\\")
grep(pattern="$", x=metaChar, value=TRUE)
strsplit(x="strsplit.aslo.uses.regular.expressions", split=".")
strsplit(x="strsplit.aslo.uses.regular.expressions", split="\\.")
str_extract_all(string = "my cridit card number: 34901358932236",pattern = "\\d")
test_vector<-c("123","456","321")
str_extract_all(test_vector,"3")
str_extract_all(test_vector,"^3")
str_extract_all(test_vector,"[^3]")

str_extract_all(string = c("regular.expressions\n","\n"), pattern ="\\.")
a<-c("regular.+expressions\n","\n")

test_vector2<-c("AlphaGo实在厉害！","alphago是啥","阿尔法狗是一条很凶猛的狗。")
str_extract_all(string = test_vector2, pattern ="AlphaGo|阿尔法狗")

str_extract_all(string = c("abc","ac","bc"),pattern = "ab?c")
str_extract_all(string = c("abababab","abc","ac"),pattern = "(ab)*")
str_extract_all(string = c("abababab","abc","ac"),pattern = "(ab)+")
str_extract_all(string = c("ababc","ac","cde"),pattern = "(ab)?c")
str_extract_all(string = c("abc","ac","cde"),pattern = "ab?c")
str_extract_all(string = c("abababab","ababc","ababababc"),pattern = "(ab){2,3}")
test<-'cs20r'
str_locate(test,'r')
str_c("control",1:3,sep = "_")
substr("abcdef", start = 2, stop = 4)
str_sub("abcdef",start = 2, end = 4)
substring("abcdef", first = 1:6, last = 2:7)
str_sub("abcdef",start = 1:6, end = 1:6)
text_weibo<- c("#围棋人机大战# 【人工智能攻克围棋 AlphaGo三比零完胜李世石】","谷歌人工智能AlphaGo与韩国棋手李世石今日进行了第三场较量","最终AlphaGo战胜李世石，连续取得三场胜利。接下来两场将沦为李世石的“荣誉之战。")
str_match_all(text_weibo,pattern = "#.+#")
str_match_all(text_weibo, pattern = "[a-zA-Z]+")

# str_extract_all，返回的列表中的元素为向量
str_extract_all(text_weibo,pattern = "\\D")

str_extract_all(text_weibo, pattern = "[a-zA-Z]+")
strtrim(c("abcde", "abcde", "abcde"),width =  c(1, 5, 10))
str_pad(string = c("abcde", "abcde", "abcde"),width =  c(1,5,10),side = "right")
string <- "Each character string in the input is first split into\n paragraphs (or lines containing whitespace only). The paragraphs are then formatted by breaking lines at word boundaries."
strwrap(x = string, width = 30)
str_wrap(string = string,width = 30)
cat(str_wrap(string = string, width = 30))

x<- c("元素为向量")
grep(pattern = "I",x = x)
str_detect(x,'素')










