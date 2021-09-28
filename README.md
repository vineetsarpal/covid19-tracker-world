# Global Covid 19 Tracker

## Introduction
I have developed a Covid-19 tracker to stay up-to-date about the situation of the pandemic in different parts of the world. The project involves multiple steps, inputs and tools (described later) to achieve the final output via a Tableau (public) dashboard.

You can find the the Tableau dashboard [here](https://public.tableau.com/app/profile/vineetsarpal/viz/MyCovid-19Tracker/Covid-19Tracker)

## Data Source
We're using data from OurWorldInData.org, a scientific online publication that focuses on global problems. Some of the data is fetched by OurWorldInData.org directly while data for many countries is further obtained by the respective governments or the concerned ministries or World Health Organisation (WHO). The data is public, reliable and from a credile source.

## Project Details
### Desired Output
A dashboard displaying the:
* Vaccination %age (fully vaccinated) of each country
* Latest data of New Covid-19 Cases by country
* New Cases everyday since the start of the pandemic for the world (filtered by country)
* Deaths everday since the start of the pandemic for the world (filtered by country)

### Tools/Languages used:
* R
* RStudio
* Google drive
* Google sheets
* Windows Task scheduler
* Tableau (public) online and desktop

### The high level Process Flow in sequential order:
RStudio:
* Reading the Covid-19 data from the dataset provided by OurWorldInData.org
* The data is provided in multiple formats. We are using the csv file
* The csv file is read as a dataframe in R using RStudio
* Cleaning, formating and reorganizing the data to extract the necessary information we need
* Connecting to the Goolge drive via the 'googledrive' package
* Writing the reorganized dataframes to googledrive as Google sheets
* Updating the existing file each time instead of replacing it

Windows:
* Using Windows task scheduler to schedule the R script to run daily and fetch the latest data then post to google drive

Tableau:
* Using the 'Google Sheets' connector in Tableau to conenct to the Google sheets posted by the above process
* Creating the visualtiions as per the desired output and combining them in a single dashboard
* Saving to Tableau (public) online with the option to sync the data
