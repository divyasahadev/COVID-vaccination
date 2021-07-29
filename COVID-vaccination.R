## --------------------------------------
## Public Health Report Analysis
## Identify next 3 socio-demographic groups to prioritise Covid vaccine delivery
## --------------------------------------

## Load packages

library(ggplot2)
library(dplyr) 
library(tidyr) 
library(readr) 
library(readxl) 
library(classInt) 
library(fingertipsR)
library(curl)
library(gridExtra)
library(reshape2)


#Read in hospitalizations data by age group from ONS
#https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/articles/coronaviruscovid19/latestinsights#hospitalisations
temp_hosp_age <- tempfile()
source <- "https://www.ons.gov.uk/visualisations/dvc1436/age/wrapper/datadownload.xlsx"
temp_hosp_age <- curl_download(url=source, destfile=temp_hosp_age, quiet=FALSE, mode="wb")

data.hosp.age <- read_excel(temp_hosp_age, sheet="Time series", range=paste0("A29:S38"),
                            col_names=TRUE, col_types=c("text","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric"))

data.hosp.age <- data.hosp.age %>%
  gather("Date", "value", 2:ncol(data.hosp.age)) %>%
  spread("Age \\ Week ending", value)
dates <- as.numeric(substr(data.hosp.age$Date, 2, nchar(data.hosp.age$Date)))
data.hosp.age$Date <- as.Date(dates, origin = '2009-7-6')

#Read in mortality data by age group from ONS                     
data.mort.age <- read_excel(temp_hosp_age, sheet="Time series", range=paste0("A41:S48"),
                            col_names=TRUE, col_types=c("text","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric"))                     

data.mort.age <- data.mort.age %>%
  gather("Date", "value", 2:ncol(data.mort.age)) %>%
  spread("Age \\ Week ending", value)
dates <- as.numeric(substr(data.mort.age$Date, 2, nchar(data.mort.age$Date)))
data.mort.age$Date <- as.Date(dates, origin = '2009-7-6')                                      

#Visualize hospitalizations by age group
#Multiple line plot
meltdf <- melt(data.hosp.age,id="Date")
#Create bar time series plot
hosp_age <- ggplot(meltdf, aes(x=Date, y=value, fill=variable))+
  geom_bar( stat="identity")+
  facet_wrap(~variable, ncol=3)+
  labs(
    title="Hospitalisation Rates by Age Group ",
    subtitle="Feb/21-June/21",
    x="Date", 
    y="Rates per 100,000 people",
    caption="Source: Office of National Statistics UK"
  )+
  theme_minimal()
hosp_age <- hosp_plot + theme(legend.position = "none")
hosp_age

#Visualize mortality by age group
#Create bar time series plot
meltdf <- melt(data.mort.age,id="Date")
mort_age <-ggplot(meltdf, aes(x=Date, y=value, fill=variable ))+
  geom_bar( stat="identity")+
  facet_wrap(~variable, ncol=3)+
  labs(
    title="Mortality Rates by Age Group",
    subtitle="Feb/21-June/21",
    x="Date", 
    y="Rates per 100,000 people",
    fill="Age Groups",
    caption="Source: Office of National Statistics UK"
  )+
  theme_minimal()

mort_age <- mort_age + theme(legend.position = "none")
mort_age

#Read in hospitalizations data by regions from ONS
#https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/articles/coronaviruscovid19/latestinsights#hospitalisations
temp_region <- tempfile()
source <- "https://www.ons.gov.uk/visualisations/dvc1436/deathshospregion/wrapper/datadownload.xlsx"
temp_region <- curl_download(url=source, destfile=temp_region, quiet=FALSE, mode="wb")

data.hosp.region <- read_excel(temp_region, sheet="Time series", range=paste0("A4:T13"),
                            col_names=TRUE, col_types=c("text","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric", "numeric"))
data.hosp.region <- data.hosp.region %>%
  gather("Date", "value", 2:ncol(data.hosp.region)) %>%
  spread("Week ending", value)
dates <- as.numeric(substr(data.hosp.region$Date, 2, nchar(data.hosp.region$Date)))
data.hosp.region$Date <- as.Date(dates, origin = '2009-7-6')

#Visualize hospitalizations by regions
#bar chart
meltdf <- melt(data.hosp.region,id="Date")
hosp_region <- ggplot(meltdf, aes(x=Date, y=value, fill=variable ))+
  geom_bar( stat="identity", position="dodge")+
  facet_wrap(~variable, ncol=3)+
  labs(
    title="Hospitalisation Rates by Regions",
    subtitle="Feb/21-June/21",
    x="Date", 
    y="Rates per 100,000 people",
    caption="Source: Office of National Statistics UK"
  )+
  theme_minimal()
hosp_region <- hosp_region + theme(legend.position = "none")
hosp_region
 
#create a multipanel graph
gridExtra::grid.arrange(hosp_age, hosp_region, ncol = 2)
  
#Read in mortality data by age group from ONS 
data.mort.region <- read_excel(temp_region, sheet="Time series", range=paste0("A16:T25"),
                            col_names=TRUE, col_types=c("text","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric","numeric",
                                                        "numeric","numeric","numeric","numeric", "numeric"))                     

data.mort.region <- data.mort.region %>%
  gather("Date", "value", 2:ncol(data.mort.region)) %>%
  spread("Week ending", value)
dates <- as.numeric(substr(data.mort.region$Date, 2, nchar(data.mort.region$Date)))
data.mort.region$Date <- as.Date(dates, origin = '2009-7-6') 

#Visualize mortality by regions
#bar chart
meltdf <- melt(data.mort.region,id="Date")
mort_region <- ggplot(meltdf, aes(x=Date, y=value, fill=variable ))+
  geom_bar( stat="identity", position="dodge")+
  facet_wrap(~variable, ncol=3)+
  labs(
    title="Mortality Rates by Regions",
    subtitle="Feb/21-June/21",
    x="Date", 
    y="Rates per 100,000 people",
    caption="Source: Office of National Statistics UK"
  )+
  theme_minimal()

mort_region <- mort_region + theme(legend.position = "none")
mort_region

#create a multipanel graph
gridExtra::grid.arrange(mort_age, mort_region, ncol = 2)

#Read in mortality data by depprivation decile from CHIME tool on gov.uk
#https://analytics.phe.gov.uk/apps/chime/#tab-2658-3
temp_mort_ethnic <- tempfile()
source <- "https://analytics.phe.gov.uk/apps/chime/session/11237ea3db32ff0d2ed54c84ed59f868/download/download_all_xlsx?w="
temp_mort_ethnic <- curl_download(url=source, destfile=temp_mort_ethnic, quiet=FALSE, mode="wb")

#Read in mortality data by deprivation decile 
data.mort.ethnic.1 <- read_excel(temp_mort_ethnic, sheet="CHIME data", range=paste0("E28976:J28985"),
                               col_names=FALSE)                     
cols <- c(1, 4, 6)
data.mort.ethnic.1 <- data.mort.ethnic.1[, cols]

data.mort.ethnic.2 <- read_excel(temp_mort_ethnic, sheet="CHIME data", range=paste0("E29006:J29015"),
                                 col_names=FALSE)                     
cols <- c(1, 4, 6)
data.mort.ethnic.2 <- data.mort.ethnic.2[, cols]

data.mort.ethnic.3 <- read_excel(temp_mort_ethnic, sheet="CHIME data", range=paste0("E29036:J29045"),
                                 col_names=FALSE)                     
cols <- c(1, 4, 6)
data.mort.ethnic.3 <- data.mort.ethnic.3[, cols]

data.mort.ethnic <- rbind(data.mort.ethnic.1, data.mort.ethnic.2, data.mort.ethnic.3)
colnames(data.mort.ethnic) <- c("timeperiod", "variable", "value") 
                                 
#Visualize death rates by deprivation decile
#Multiple line plot
ggplot(data.mort.ethnic, aes(x=timeperiod, y=value, colour=variable, group=variable)) + 
  geom_line(size=1)+
  labs(
    title="Monthly Deaths by Deprivation Decile",
    subtitle="Feb/21-April/21",
    x="Month", 
    y="Number of Deaths", 
    colour="Deprivation Category",
    caption="CHIME Public Health England"
  )

#Read in vaccination rates data within care home residents and staff from NHS England
#https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-vaccinations/
temp_vacc_carehome <- tempfile()
source <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/06/COVID-19-weekly-announced-vaccinations-17-June-2021.xlsx"
temp_vacc_carehome <- curl_download(url=source, destfile=temp_vacc_carehome, quiet=FALSE, mode="wb")

data.vacc.carehome.1 <- read_excel(temp_vacc_carehome, sheet="Older Adult Care Homes", 
                                 range=paste0("B20:I26"),
                               col_names=FALSE) 
cols <- c(1, 6, 8)
data.vacc.carehome.1 <- data.vacc.carehome.1[, cols]
data.vacc.carehome.2 <- read_excel(temp_vacc_carehome, sheet="Older Adult Care Homes", 
                                   range=paste0("B33:I39"),
                                   col_names=FALSE) 
cols <- c(1, 6, 8)
data.vacc.carehome.2 <- data.vacc.carehome.2[, cols]
data.vacc.carehome <- merge(data.vacc.carehome.1, data.vacc.carehome.2, by = "...1")
data.vacc.carehome[2:5] <- data.vacc.carehome[2:5]*100
colnames(data.vacc.carehome) <- c("Region", "Resident-1st dose", "Resident-2nd dose", 
                                  "Staff-1st dose", "Staff-2nd dose")

meltdf <- melt(data.vacc.carehome,id="Region")
ggplot(meltdf, aes(x=Region, y=value, fill=variable ))+
  geom_bar( stat="identity", position="dodge")+
  labs(
    title="Percent Residents and Staff Vaccinated in Care Homes by Regions",
    subtitle="Dec/20-June/21",
    x="Region", 
    y="Percent Vaccinated",
    fill="Vaccinated Residents and Staff",
    caption="Source: NHS England"
  )+
  theme_minimal()

#Read in cases rates for regions in England from ONS
#https://www.ons.gov.uk/peoplepopulationandcommunity/healthandsocialcare/conditionsanddiseases/articles/coronaviruscovid19/latestinsights#infections
temp_case_regions <- tempfile()
source <- "https://www.ons.gov.uk/visualisations/dvc1432/region/datadownload.xlsx"
temp_case_regions <- curl_download(url=source, destfile=temp_case_regions, quiet=FALSE, mode="wb")

data.case.region <- read_excel(temp_case_regions, sheet="Regional positivity", 
                                   range=paste0("A6:AB47"),
                                   col_names=FALSE) 
cols <- c(1, 2, 5, 8, 11, 14, 17, 20, 23, 26)
data.case.region <- data.case.region[, cols]
data.case.region[2:10] <- data.case.region[2:10]*100
colnames(data.case.region) <- c("Date", "North East", "North West", 
                                  "Yorkshire and The Humber", "East Midlands",
                                "West Midlands", "East of England","London", "South East", "South West")

#Visualize case rates by regions
#Multiple line plot
meltdf <- melt(data.case.region,id="Date")
ggplot(meltdf,aes(x=Date,y=value,colour=variable,group=variable)) + 
  geom_line()+
  facet_wrap(. ~ variable, ncol=3)+
  labs(
    title="Percent Population in England Testing Positive",
    subtitle="May/21-June/21",
    x="Date", 
    y="% People testing positive", 
    colour="Regions",
    caption="Source: Office of National Statistics UK"
  )



