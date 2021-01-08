library(shiny)
library(shiny.semantic)
library(leaflet)

source("R/ships.R")
source("R/ship_map.R")

ships <- Ships$new()
ship_map <- ShipMap$new()

ui <- semanticPage(
  title = "My page",
  dropdown_input("ship_types", ships$ship_types, value = NULL, type = "search selection single"),
  dropdown_input("ships", NULL, value = NULL, type = "search selection single"),
  leafletOutput("map"),
  textOutput("note")
)
server <- function(input, output, session) {
  
  observeEvent(input$ship_types, {
    selected_ships <- ships$get_ships_by_type(input$ship_types)
    update_dropdown_input(session, "ships", choices = selected_ships)
  })
  observeEvent(input$ships, {
    points <- ships$get_longest_distance(input$ships)
    ship_map$set_markers_on_map(points, output)
    ship_map$build_distance_note(points, output)
  })
  
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) 
  })
}
shinyApp(ui, server)