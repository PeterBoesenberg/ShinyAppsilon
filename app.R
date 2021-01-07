library(shiny)
library(shiny.semantic)

source("R/ships.R")

ships <- Ships$new()
ui <- semanticPage(
  title = "My page",
  dropdown_input("ship_types", ships$ship_types, value = NULL, type = "search selection single"),
  dropdown_input("ships", NULL, value = NULL, type = "search selection single"),
  div(class = "ui button", icon("user"),  "Icon button")
)
server <- function(input, output, session) {
  
  observeEvent(input$ship_types, {
    print("EVENT!")
    print(input$ship_types)
    selected_ships <- ships$get_vessels_by_type(input$ship_types)
    print(selected_ships)
    update_dropdown_input(session, "ships", choices = selected_ships)
  })
}
shinyApp(ui, server)