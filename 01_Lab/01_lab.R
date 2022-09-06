##########################################
#   URP-5493: PLanning & Econ Development
#   Prof: Esteban Lopez Ochoa, PhD
#   Lab 1: Regional Economic Profiles
##########################################

#https://apps.bea.gov/itable/index.cfm
#https://www.bea.gov/news/2021/gross-domestic-product-county-2020
#https://apps.bea.gov/API/signup/index.cfm

#https://github.com/us-bea/bea.R
#https://jwrchoi.com/post/how-to-use-bureau-of-economic-analysis-bea-api-in-r/


#-------- Part 0: Setting up data access ----
install.packages("bea.R")
library(bea.R)

install.packages(c('devtools', 'httr'))
library(httr)
library(devtools)

httr::set_config( config( ssl_verifypeer = 0L ))
devtools::install_github('us-bea/bea.R')


library(data.table)

myAPIkey<-"99BD2068-C8C5-4E24-B4E0-7FB2E8E1E693"

?beaSets

beaSets(beaKey = myAPIkey)

beaParams(beaKey = myAPIkey,setName = 'GDPbyIndustry')

beaParamVals(beaKey = myAPIkey,setName = 'GDPbyIndustry',paramName = 'TableID')
beaParamVals(beaKey = myAPIkey,setName = 'GDPbyIndustry',paramName = 'Industry')
beaParamVals(beaKey = myAPIkey,setName = 'GDPbyIndustry',paramName = 'Year')


userSpecList <- list('UserID' = '99BD2068-C8C5-4E24-B4E0-7FB2E8E1E693' ,
                     'Method' = 'GetData',
                     'datasetname' = 'GDPbyIndustry',
                     'Frequency' = 'A',
                     'Industry' = 'II',
                     'TableID' = '16',
                     'Year' = '2020',
                     'ResultFormat' = 'json'
                     )	

userSpecList <- list('UserID' = '99BD2068-C8C5-4E24-B4E0-7FB2E8E1E693' ,
                     'Method' = 'GetData',
                     'datasetname' = 'NIPA',
                     'Frequency' = 'A',
                     'TableID' = '68',
                     'Year' = 'X')	


?beaGet
resp <- beaGet(userSpecList,asTable = F)
BL <- bea2List(resp)
BDT <- bea2Tab(resp)

beaSpecs <- list(
  'UserID' = myAPIkey ,
  'Method' = 'GetData',
  'datasetname' = 'NIPA',
  'TableName' = 'T20305',
  'Frequency' = 'Q',
  'Year' = 'X',
  'ResultFormat' = 'json'
);
beaPayload <- beaGet(beaSpecs);

beaLong <- beaGet(beaSpecs, asWide = FALSE)

#-------- Part 1: Regional Economic Profiles ----


