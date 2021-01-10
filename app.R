library(shiny)
library(shiny.semantic)
library(data.table)
library(R6)
library(gmt)
library(leaflet)

source("R/ships.R")
source("R/ship_map.R")

# initialize R6-objects
ships <- Ships$new()
ship_map <- ShipMap$new()

ui <- semanticPage(
  title = "ShinyAppsilon",
  ships$get_ship_type_dropdown_ui("type_selection"),
  ships$get_ships_dropdown_ui("ship_selection"),
  ship_map$get_map_ui("map")
)


server <- function(input, output, session) {
  # reactive values used to communicate between shiny modules
  selected_ship_type <- reactiveVal()
  ship_observations <- reactiveVal()


  callModule(ships$get_ship_type_dropdown_server, "type_selection",  selected_ship_type)
  callModule(ships$get_ships_dropdown_server, "ship_selection",  selected_ship_type, ship_observations)
  callModule(ship_map$get_map_server, "map", ship_observations)

}
shinyApp(ui, server)
