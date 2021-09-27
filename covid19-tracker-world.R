library(tidyverse)
library(googledrive)
library(googlesheets4)
#library(RCurl)

# Creating a log file to track errors when script is run by task scheduler
current_wd <- getwd()
error_log <- file(paste0(current_wd,"/error_log.Rout"), open = "wt")
sink(error_log, type = "message")

try({

################################
# Fetching global Covid 19 data
################################
df_covid_data_raw <- read_csv("https://covid.ourworldindata.org/data/owid-covid-data.csv")

#URL <- getURL('https://covid.ourworldindata.org/data/owid-covid-data.csv', ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)
#df_covid_data_raw <- read_csv(URL)
  
##############################
# Vaccination %age by country
##############################
# Filtering required data
df_covid_data_vaccination <- df_covid_data_raw %>% 
  filter(!is.na(continent)) %>% 
  subset(select = c("location","date","people_fully_vaccinated","population")) %>% 
  group_by(location) %>% 
  filter(!is.na(people_fully_vaccinated) & !is.na(population)) %>% 
  filter(date == max(date))

# Adding new column to calculate vaccination %age
df_covid_data_vaccination <- df_covid_data_vaccination %>% 
  mutate(vaccination_percent = (people_fully_vaccinated/population)*100)


###########
# New cases 
###########
# Filtering required data
df_covid_data_new_cases <- df_covid_data_raw %>% 
  filter(!is.na(continent)) %>%
  subset(select = c("location","date","new_cases","new_cases_smoothed")) %>% 
  group_by(location) %>% 
  filter(!is.na(new_cases) | !is.na(new_cases_smoothed)) %>% 
  filter(date == max(date))

# Adding new column to determine the final count of new cases if new_cases is 0
df_covid_data_new_cases <- df_covid_data_new_cases %>% 
  mutate(new_cases_final = if_else(new_cases>0,new_cases,new_cases_smoothed))

############################
# Merging & Posting to drive
############################
# Joining the vaccination and new cases tables
df_covid_data_vaccine_new_cases <- full_join(df_covid_data_vaccination, df_covid_data_new_cases, by = "location")

# Authorizing Google connection 
drive_auth(email = "vince.insanity@gmail.com")

#Writing to drive
write_csv(df_covid_data_vaccine_new_cases, file = paste0(current_wd,"/covid_data_vaccine_new_cases_latest.csv"))
td <- drive_get("https://drive.google.com/drive/folders/1xK8YWZnD4IKXhwnbf4qhtr2yFlCjFV-z")
#drive_upload(media = "covid_data_vaccine_new_cases_latest.csv", type = "spreadsheet", path = as_id(td), overwrite = TRUE, name = "covid_data_vaccine_new_cases_latest")
drive_put(media = "covid_data_vaccine_new_cases_latest.csv", type = "spreadsheet", path = as_id(td), name = "covid_data_vaccine_new_cases_latest")

############################
# Cases and Deaths Over Time
############################
# Filtering required data
df_covid_cases_deaths <- df_covid_data_raw %>% 
  filter(!is.na(continent)) %>%
  subset(select = c("location","date","new_cases","new_cases_smoothed","new_deaths","new_deaths_smoothed")) 

df_covid_cases_deaths <- df_covid_cases_deaths %>% 
  mutate(new_cases_final = if_else(new_cases>0,new_cases,new_cases_smoothed)) %>% 
  mutate(new_deaths_final = if_else(new_deaths>0,new_deaths,new_deaths_smoothed))

##################
# Posting to drive
##################

write_csv(df_covid_cases_deaths, file = paste0(current_wd,"/covid_data_cases_deaths_over_time.csv"))
td <- drive_get("https://drive.google.com/drive/folders/1xK8YWZnD4IKXhwnbf4qhtr2yFlCjFV-z")
#drive_upload(media = "covid_data_cases_deaths_over_time.csv", type = "spreadsheet", path = as_id(td), overwrite = TRUE, name = "covid_data_cases_deaths_over_time")
drive_put(media = "covid_data_cases_deaths_over_time.csv", type = "spreadsheet", path = as_id(td), name = "covid_data_cases_deaths_over_time")


})
