#dplyr
#http://db.rstudio.com/dplyr/
#install.packages("dbplyr")
install.packages('RMySQL')
#install.packages('RSQLite')
#install.packages('nycflights13')
#install.packages('odbc')
#install.packages('devtools')
devtools::install_github("r-dbi/odbc")
library(dplyr)
library(RMySQL)
library(odbc)

con <- DBI::dbConnect(RMySQL::MySQL(), 
                      host = "localhost",
                      user = "sipa",
                      password = rstudioapi::askForPassword("sipa2017"))


dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbListTables(con)
dbListFields(con, "mtcars")
dbReadTable(con, "mtcars")
# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)
dbClearResult(res)

##########################################################



con <- DBI::dbConnect(RSQLite::SQLite(), path = ":memory:")
copy_to(con, nycflights13::flights, "flights",
        temporary = FALSE, 
        indexes = list(
            c("year", "month", "day"), 
            "carrier", 
            "tailnum",
            "dest"
        )
)
flights_db <- tbl(con, "flights")
flights_db %>% select(year:day, dep_delay, arr_delay)
flights_db %>% filter(dep_delay > 240)
flights_db %>% 
    group_by(dest) %>%
    summarise(delay = mean(dep_time))

tailnum_delay_db <- flights_db %>% 
    group_by(tailnum) %>%
    summarise(
        delay = mean(arr_delay),
        n = n()
    ) %>% 
    arrange(desc(delay)) %>%
    filter(n > 100)


tailnum_delay_db
#Behind the scenes, dplyr is translating your R code into SQL. 
#You can see the SQL it’s generating with show_query():
tailnum_delay_db %>% show_query()

tailnum_delay <- tailnum_delay_db %>% collect()
tailnum_delay <- tailnum_delay_db %>% explain()


library(DBI)
# Create an ephemeral in-memory RSQLite database
con <- dbConnect(RSQLite::SQLite(), dbname = ":memory:")
dbListTables(con)
dbWriteTable(con, "mtcars", mtcars)
dbListTables(con)
dbListFields(con, "mtcars")
dbReadTable(con, "mtcars")
# You can fetch all results:
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
dbFetch(res)
dbClearResult(res)

# Or a chunk at a time
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
while(!dbHasCompleted(res)){
    chunk <- dbFetch(res, n = 5)
    print(nrow(chunk))
}
dbClearResult(res)

dbDisconnect(con)
install.packages('devtools')
devtools::install_github("rstats-db/DBI")


names(bim_data) <- c("Player","B_Squ",'F_Squ',"OH_Squ",
                     "DDL","S_DDL","S_Pre", "P_Pre", 
                     "P_Jerk",'S_Sna','P_Sna',
                     'S_Cle','P_Cle',"B_Pre",
                     "Thruster",'S_PUP','K_PUP',
                     "S_H_PSP", "K_H_PSP","S_TTB","K_TTB",
                     "S_R_MU","K_RMU","K_B_MU","S_CTB","K_CTB")
                     
corrplot(corr=cor(bim_data[,2:26]),method = "color")                                     
                                   
                                


















