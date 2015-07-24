library(shinydashboard)
library(jsonlite)

header <- dashboardHeader(title = "swaggeR")
sidebar <- dashboardSidebar(
  sidebarMenuOutput("sbMenu"))


body <- dashboardBody(
  uiOutput("body")
)



dashboardPage(
  header,
  sidebar,
  body
)