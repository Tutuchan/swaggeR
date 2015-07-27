library(jsonlite)
library(dplyr)
library(tidyr)
library(stringr)
library(shiny)
library(shinydashboard)
library(shinyBS)
library(DT)
library(data.table)
library(magrittr)

source("functions/helpers.R")

cache = TRUE

if (cache){
  load("data/cache.RData")
} else {
  options(stringsAsFactors = FALSE)
  mainURL <- "http://na.lolesports.com:80/api/"
  dfAllSeries <- getSeries()
  dfAllLeagues <- getLeague()[[1]]
  
  listAllTournaments <- lapply(1:nrow(dfAllLeagues), function(i) {
    print(i)
    tournamentIDs <- getLeague(id)$leagueTournaments
    lapply(tournamentIDs, function(id) {
      print(id)
      tournament <- getTournament(id)
      dfContestants <- tournament$contestants
      tournament$contestants <- NULL
      tournament$id <- id
      tournament %<>% as.data.frame
      if (length(dfContestants)>0){
          dfContestants <- data.frame(matrix(unlist(dfContestants), ncol=3, byrow=T),stringsAsFactors=FALSE) %>% 
        arrange(X1)
          names(dfContestants) <- c("teamId", "teamName", "teamAcronym")
          dfContestants$tournamentId <- id
          if(tournament$winner!="") tournament$winner <- dfContestants$teamAcronym[dfContestants$teamId == tournament$winner]
      }
      list(dfTournament = tournament, dfContestants = dfContestants)
    })
  })
}


