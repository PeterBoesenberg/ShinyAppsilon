library(shiny)
library(shiny.semantic)
library(data.table)
library(R6)
library(gmt)
library(leaflet)

source("R/ship_app.R")

ship_app <- ShipApp$new()

ui <- semanticPage(
  title = "ShinyAppsilon",
  ship_app$get_app_ui()
)

server <- function(input, output, session) {
  ship_app$get_app_server(input, output, session)
}
shinyApp(ui, server)
