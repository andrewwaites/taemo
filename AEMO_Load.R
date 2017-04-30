rm(list=ls())

install.packages("RCurl")

library(RCurl)
library(dplyr)
library(readr)
library(ggplot2)

regions <- c("NSW","VIC","QLD","SA","TAS")
years   <- 2016:2017
years
base_url <- "www.aemo.com.au/aemo/data/nem/priceanddemand/PRICE_AND_DEMAND_"

#
# build empty data frame
#
aemo_data <- structure(list(Region=character(), 
                            SettlementDate=as.POSIXct(character()), 
                            TotalDemand=double(), 
                            RRP=double(), 
                            PeriodType=factor()),
                       class="data.frame")
#
# for years and regions and months, load it up....
#
for (year in years) {
  for (month in 1:12) {
    for (state in regions){
      qurl <- paste(base_url,year,sprintf("%02d",month),"_",state,"1.csv",sep="")
      print(qurl)
      if(url.exists(qurl)) {
        tdata <- httpGET(qurl)
        tdata <- read_csv(tdata)
        tdata$SETTLEMENTDATE <- as.POSIXct(tdata$SETTLEMENTDATE)
        tdata$PERIODTYPE <- as.factor(tdata$PERIODTYPE)
      
        aemo_data <- rbind(aemo_data, tdata)
      }
    }
  }
  
}
