################################################################################
#                                                                              #  
# Define here the global part of the application - used by both iu and server  #
#                                                                              #
################################################################################

# Load user-defined function for package loading and installation
source("./Functions/F_Load_Install_Packages.R")

# Load/Install packages
load_install_packages("shiny")
load_install_packages("wbstats")
load_install_packages("dplyr")
load_install_packages("googleVis")
load_install_packages("DT")
load_install_packages("DescTools")
load_install_packages("xlsx")

#Load libraries
# library(shiny)
# library(wbstats)
# library(dplyr)
# library(googleVis)
# library(DT)
# library(DescTools)
# library(xlsx)

#################################################################
#                                                               #
# Get data from the world bank API using the wbstats() function #
#                                                               #  
#################################################################

# Search for data with the world bank R package
#internet_data <- wbsearch(pattern = "education")

############################
#                          #  
#  Technology indicators   #
#                          #
############################

#Percentage of internet users from the population
percentInternetUsers <- wb(indicator = "IT.NET.USER.ZS")

technicalJournalArticles = wb(indicator = "IP.JRN.ARTC.SC")

highTechExports = wb(indicator = "TX.VAL.ICTG.ZS.UN")

highTechImports = wb(indicator = "TM.VAL.ICTG.ZS.UN")

telephoneSubscribers = wb(indicator = "IT.TEL.TOTL.P3")

##########################
#                        #
#  Economic indicators   #
#                        #  
##########################

#GDP growth
gdpGrowth = wb(indicator = "NY.GDP.MKTP.KD.ZG")

#Unemployment Rate
unempRate = wb(indicator = "SL.UEM.TOTL.NE.ZS")

#Inflation
inflation = wb(indicator = "FP.CPI.TOTL.ZG")

#Real interest rates
lendingInterestRate = wb(indicator = "FR.INR.LEND")

# GDP per capita current dollars
gdpPerCapita = wb(indicator = "NY.GDP.PCAP.PP.KD")

##########################
#                        #
# Education indicators   #  
#                        #    
##########################

govExpTertiaryEducation = wb(indicator = "UIS.XGDP.56.FSGOV")

secondaryEducationPercent = wb(indicator = "SE.SEC.CUAT.LO.ZS")

earlySchoolLeavers = wb(indicator = "UIS.ESL.1.T")

#numberOfSchools = wb(indicator = "SE.SCHL.PRM")

##########################
#                        #
# Finance indicators     #  
#                        #    
##########################

governmentDebt = wb(indicator = "GC.DOD.TOTL.GD.ZS")

fdi = wb(indicator = "BN.KLT.DINV.CD")

grossPortfolioDebt = wb(indicator = "GFDD.DM.10")

grossPortfolioEquity = wb(indicator = "GFDD.DM.08")

