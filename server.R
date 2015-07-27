library(shinydashboard)
library(shiny)
library(jsonlite)

shinyServer(function(input, output) {
  values <- reactiveValues(currentTournament = NULL)
  
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
              tabBox(width = 12, height = "1200px",
                     tabPanel("Tournaments",
                              column(8, DT::dataTableOutput(paste0("dtLeague", dfAllLeagues$id[i]))),
                              column(4, DT::dataTableOutput(paste0("dtContestants", dfAllLeagues$id[i])))
                     ),
                     tabPanel("Test",
                              textOutput(paste0("textLeague", dfAllLeagues$id[i])))))
    })
    do.call(tabItems, listTabLeagues)
  })
  
  # Datatables
  lapply(1:nrow(dfAllLeagues), function(i) {
    # All tournaments in a league
    output[[paste0("dtLeague", dfAllLeagues$id[i])]] <- DT::renderDataTable({
      listTournaments <- listAllTournaments[[i]]
      df <- rbindlist(lapply(listTournaments, function(l) l[[1]])) 
      values$currentTournament <- df
      df %<>% 
        select(Season = season, Name = namePublic, `Start date` = dateBegin, `End date` = dateEnd)
      df[["# teams"]]<- sapply(listTournaments, function(l) nrow(l[[2]]))
      df %>% 
        filter(grepl("Split|Playoffs|Promotion", Name))
    }, selection = "single", class = "cell-border stripe", options = list(dom = 't', pageLength = nrow(df)), rownames = FALSE)
    
    # All contestants in a selected tournament
    output[[paste0("dtContestants", dfAllLeagues$id[i])]] <- DT::renderDataTable({
      shiny::validate(
        need(input[[paste0("dtLeague", dfAllLeagues$id[i], "_rows_selected")]], "Select a row.")
      )
      
      selID <- input[[paste0("dtLeague", dfAllLeagues$id[i], "_rows_selected")]]
      dfContestants <- listAllTournaments[[i]][[selID]]$dfContestants %>% 
        select(-ends_with("Id"))
      names(dfContestants) <- c("Name", "Acronym")
      dfContestants$is_winner <- as.numeric(dfContestants$Acronym == values$currentTournament$winner[selID])
      
      datatable(dfContestants, selection = "none", class = "cell-border stripe", 
                options = list(dom = 't', pageLength = nrow(df), columnDefs = list(list(targets = 2, visible = FALSE))), 
                rownames = FALSE) %>% 
        formatStyle("is_winner", 
                    target = "row", 
                    backgroundColor = styleEqual(c(0,1), c("white", "green")),
                    color = styleEqual(c(0,1), c("black", "white")),
                    fontWeight = styleEqual(c(0,1), c("normal", "bold")))
    })
  })
})
