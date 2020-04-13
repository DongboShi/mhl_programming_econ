# install.packages("ggplot2")
# remotes::install_github("GuangchuangYu/nCov2019")
# install.packages("shadowtext")
# install.packages("ggplotify")
# 如果失败的话直接从这里下载，然后本地安装
# https://api.github.com/repos/GuangchuangYu/nCov2019/tarball/master

# Warning in untar2(tarfile, files, list, exdir, restore_times) :
#         skipping pax global extended headers
# ERROR: dependency ‘downloader’ is not available for package ‘nCov2019’
# * removing ‘/Library/Frameworks/R.framework/Versions/3.6/Resources/library/nCov2019’
# install.packages("downloader")

library(nCov2019)
library(ggplot2)
library(shadowtext)
library(dplyr)
library(ggplotify)


#---------------------------------------------------------
# data 
#-------------------------------------------------------
d <- load_nCov2019()
dd <- d['global'] %>% 
        as_tibble %>%
        rename(confirm=cum_confirm) %>%
        filter(confirm > 100 & country != "China") %>%
        group_by(country) %>%
        mutate(days_since_100 = as.numeric(time - min(time))) %>%
        ungroup 
dd <- d['global'] %>% 
        as_tibble %>%
        rename(confirm=cum_confirm) %>%
        filter(confirm > 100 ) %>%
        group_by(country) %>%
        mutate(days_since_100 = as.numeric(time - min(time))) %>%
        ungroup 

breaks=c(100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000)


#------------------------------------------------
#basic map 
#------------------------------------------------
data <- dd %>% filter(country %in% c("United States","China" ))

ggplot(data, aes(days_since_100, confirm, color = country)) +
        geom_line(size = 0.8)

ggplot(data, aes(days_since_100, confirm, color = country)) +
        geom_line(size = 0.8) + 
        geom_point(pch = 21, size = 1)

# scaling the axis
ggplot(data, aes(days_since_100, confirm, color = country)) +
        geom_line(size = 0.8) + 
        geom_point(pch = 21, size = 1)+
        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                      breaks = breaks, labels = breaks)+
        scale_x_continuous(expand = expansion(add = c(0,1))) 

# labels
ggplot(data, aes(days_since_100, confirm, color = country)) +
        geom_line(size = 0.8) + 
        geom_point(pch = 21, size = 1)+
        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                      breaks = breaks, labels = breaks)+
        scale_x_continuous(expand = expansion(add = c(0,1))) +
        labs(x = "Number of days since 100th case", y = NULL, 
             title = "Confirmed COVID-19 cases",
             subtitle = time(d))

# themes
ggplot(data, aes(days_since_100, confirm, color = country)) +
        geom_line(size = 0.8) + 
        geom_point(pch = 21, size = 1)+
        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                      breaks = breaks, labels = breaks)+
        scale_x_continuous(expand = expansion(add = c(0,1))) +
        labs(x = "Number of days since 100th case", y = NULL, 
             title = "Confirmed COVID-19 cases",
             subtitle = time(d)) +
        theme_minimal(base_size = 14) +
        theme(
                panel.grid.minor = element_blank(),
                legend.position = "none",
                plot.margin = margin(3,20,3,3,"mm")
        ) 
library(ggthemes)
ggplot(data, aes(days_since_100, confirm, color = country)) +
        geom_line(size = 0.8) + 
        geom_point(pch = 21, size = 1)+
        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                      breaks = breaks, labels = breaks)+
        scale_x_continuous(expand = expansion(add = c(0,1))) +
        labs(x = "Number of days since 100th case", y = NULL, 
             title = "Confirmed COVID-19 cases",
             subtitle = time(d)) +
        theme_economist_white()

# facet
ggplot(data, aes(days_since_100, confirm, color = country)) +
        geom_line(size = 0.8) + 
        geom_point(pch = 21, size = 1)+
        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                      breaks = breaks, labels = breaks)+
        scale_x_continuous(expand = expansion(add = c(0,1))) +
        labs(x = "Number of days since 100th case", y = NULL, 
             title = "Confirmed COVID-19 cases",
             subtitle = time(d)) +
        theme_minimal(base_size = 14) +
        theme(
                panel.grid.minor = element_blank(),
                legend.position = "none",
                plot.margin = margin(3,20,3,3,"mm")
        ) +
        facet_wrap( ~ country, ncol=2) 
# text
ggplot(data, aes(days_since_100, confirm, color = country)) +
        geom_line(size = 0.8) + 
        geom_point(pch = 21, size = 1)+
        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                      breaks = breaks, labels = breaks)+
        scale_x_continuous(expand = expansion(add = c(0,1))) +
        labs(x = "Number of days since 100th case", y = NULL, 
             title = "Confirmed COVID-19 cases",
             subtitle = time(d)) +
        theme_minimal(base_size = 14) +
        theme(
                panel.grid.minor = element_blank(),
                legend.position = "none",
                plot.margin = margin(3,20,3,3,"mm")
        ) +
        geom_shadowtext(aes(label = paste0(" ",country)), hjust=0, vjust = 0, 
                        data = . %>% group_by(country) %>% top_n(1, days_since_100), 
                        bg.color = "white") 


#------------------------------------------------
# final
p2 <- ggplot(dd, aes(days_since_100, confirm, color = country)) +
        geom_smooth(method='lm', aes(group=1),
                    data = . %>% filter(!country %in% c("Japan", "Singapore")), 
                    color='grey10', linetype='dashed') +
        geom_line(size = 0.8) +
        geom_point(pch = 21, size = 1) +
        scale_y_log10(expand = expansion(add = c(0,0.1)), 
                      breaks = breaks, labels = breaks) +
        scale_x_continuous(expand = expansion(add = c(0,1))) +
        theme_minimal(base_size = 14) +
        theme(
                panel.grid.minor = element_blank(),
                legend.position = "none",
                plot.margin = margin(3,20,3,3,"mm")
        ) +
        coord_cartesian(clip = "off") +
        geom_shadowtext(aes(label = paste0(" ",country)), hjust=0, vjust = 0, 
                        data = . %>% group_by(country) %>% top_n(1, days_since_100), 
                        bg.color = "white") 
        
ggsave(p2, filename = "nCov2019.jpg", width=16, height=11)

