library(jsonlite)
library(dplyr)
library(tidyr)
library(stringr)
library(shiny)
library(shinydashboard)
library(shinyBS)
library(DT)
library(data.table)

options(stringsAsFactors = FALSE)
mainURL <- "http://na.lolesports.com:80/api/"
dfAllSeries <- fromJSON(paste0(mainURL,"series.json"))
dfAllLeagues <- fromJSON(paste0(mainURL,"league.json?parameters[method]=all&parameters[published]=1"))[[1]]
