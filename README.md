# myrepo
install.packages("tidyverse")
library(tidyverse)

# import dateset: “UID_ISO_FIPS_LookUp_Table”
read.csv("/Users/arlen/Desktop/COVID-19/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv")
# import dateset: "time_series_covid19_confirmed_global.csv"
read.csv("/Users/arlen/Desktop/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

# merge two datasets and creat a long verson of data. Save both long and wide data locally?--> how? I saved as data_3, does it count?
dataset_1<-read.csv("/Users/arlen/Desktop/COVID-19/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv")
dataset_2<-read.csv("/Users/arlen/Desktop/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
names(dataset_2)[names(dataset_2) == "Country.Region"] <- "Country_Region"
dataset_3<-merge(dataset_1,dataset_2,by="Country_Region")
print(dataset_3)