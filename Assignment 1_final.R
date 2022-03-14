require(tidyverse)
require(ggplot2)
library(dplyr)

datafips=read.csv("/Users/arlen/Desktop/COVID-19/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv")
dataglb=read.csv("/Users/arlen/Desktop/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

colnames(dataglb)[colnames(dataglb)=="Province.State"] = "Province_State"
colnames(dataglb)[colnames(dataglb)=="Country.Region"] = "Country_Region"
colnames(datafips)[colnames(datafips)=="Long_"] = "Long"


# merge data
datajoin <- inner_join(datafips, dataglb, by = c("Province_State", "Country_Region", "Lat","Long")) 
# change col names for reshaping
for (i in 13:ncol(datajoin)) {
  colnames(datajoin)[colnames(datajoin)==colnames(datajoin[i])]<- paste("dt", colnames(datajoin[i]), sep = "-")
}

colnames(datajoin) = gsub("X", "", colnames(datajoin))

# reshape to long format
da3df <- as.data.frame(datajoin)
da3df_lr <- reshape(data = da3df,
                    varying = 793:nrow(da3df),
                    timevar = "date",
                    sep = "-",
                    idvar = "UID",
                    direction = "long")

da3df_lr <- tbl_df(da3df_lr) %>%
  arrange(UID)
da3df_lr <- subset (da3df_lr, select = -c(13:274))


da3df_lr$date<- as.Date(da3df_lr$date, "%m.%d.%y")
# 
# plot overall change in time of log number of cases
da3df_lr %>%filter(dt>0)%>%
  ggplot(aes(date, dt)) +
  stat_summary(fun = sum, geom = "line", lwd = 1)+
  labs(y = "noc") +
  
  theme_bw()

# change in time of log number of cases by country
# select ten countries
da<-da3df_lr[c(1:5190),]

#scale_x_continuous(breaks = as.numeric(wvyear)+2000) +
da %>% 
  ggplot(aes(date, dt, color = Combined_Key)) +
  stat_summary(fun = mean, geom = "line", lwd = 1)+
  labs(x = "date", y = "num. of cases",
       color = "country name") +
  theme_bw() +
  facet_wrap( ~ Combined_Key, as.table =F) #, nrow = 12

# change in time by country of rate of infection per 100,000 cases
dprop<-data.frame( prop=da$dt/da$Population*100000)
da<-cbind(da,dprop)
da %>% 
  ggplot(aes(date, prop, color = Combined_Key)) +
  stat_summary(fun = mean, geom = "line", lwd = 1)+
  labs(x = "date", y = "noc per100,000",
       color = "country name") +
  theme_bw() +
  facet_wrap( ~ Combined_Key, as.table =F) 

