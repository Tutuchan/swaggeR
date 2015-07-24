library(shinydashboard)
library(shiny)
library(jsonlite)

shinyServer(function(input, output) {
  
  
  # Inputs
  output$sbMenu <- renderMenu({
    # Leagues
    subMenuLeague <- lapply(1:nrow(dfAllLeagues), function(i) menuSubItem(dfAllLeagues$label[i], tabName = paste0("tabLeague", dfAllLeagues$id[i])))
    menuLeague <- menuItem("Leagues", subMenuLeague)
    # Teams
    menuTeam <- menuItem("Teams", tabName = "tabTeams")
    # Players
    menuPlayer <- menuItem("Players", tabName = "tabPlayers")
    
    sidebarMenu(menuLeague,
                menuTeam,
                menuPlayer)
  })
  
  output$body <- renderUI({
    listTabLeagues <- lapply(1:nrow(dfAllLeagues), function(i) {
      tabItem(paste0("tabLeague", dfAllLeagues$id[i]),
              tabBox(width = 12,
                tabPanel("Tournaments",
                         DT::dataTableOutput(paste0("dtLeague", dfAllLeagues$id[i]))),
                tabPanel("Test",
                         textOutput(paste0("textLeague", dfAllLeagues$id[i])))
                
              )
      )
    })
    
    do.call(tabItems, listTabLeagues)
  })
  
  # Datatables
  lapply(1:nrow(dfAllLeagues), function(i) {
    output[[paste0("dtLeague", dfAllLeagues$id[i])]] <- renderDataTable({
      tournamentIDs <- fromJSON(paste0(mainURL, "league/", dfAllLeagues$id[i], ".json"))$leagueTournaments
      listTournaments <- lapply(tournamentIDs, function(id) {
        listTournament <- fromJSON(paste0(mainURL, "tournament/", id, ".json"))
        data.frame(Season = listTournament$season, Name = listTournament$namePublic, Contestants = paste(sort(rbindlist(listTournament$contestants)$name), collapse = ", "))
      })
      rbind_all(listTournaments)
    })
  })
})
