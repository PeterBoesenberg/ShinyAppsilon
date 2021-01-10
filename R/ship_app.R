library(R6)

source("R/ships.R")
source("R/ship_map.R")

ShipApp <- R6Class("ShippApp",
  public = list(
    ships = NULL,
    ship_map = NULL,

    #' Initialize R6-objects, which will build the app.
    #'
    #' @export
    initialize = function() {
      self$ships <- Ships$new()
      self$ship_map <- ShipMap$new()
    },

    #' Get UI of the complete App.
    #'
    #' @return grid object which includes all UI elements
    #' @export
    get_app_ui = function() {
      grid(private$grid,
        container_style = "",
        ship_type = self$ships$get_ship_type_dropdown_ui("type_selection"),
        ships = self$ships$get_ships_dropdown_ui("ship_selection"),
        map = self$ship_map$get_map_ui("map")
      )
    },

    #' Get all server logic for the ship app.
    #'
    #' @param input shiny input
    #' @param output shiny output
    #' @param session shiny session
    #'
    #' @export
    get_app_server = function(input, output, session) {
      # reactive values used to communicate between shiny modules
      selected_ship_type <- reactiveVal()
      ship_observations <- reactiveVal()

      callModule(self$ships$get_ship_type_dropdown_server, "type_selection", selected_ship_type)
      callModule(self$ships$get_ships_dropdown_server, "ship_selection", selected_ship_type, ship_observations)
      callModule(self$ship_map$get_map_server, "map", ship_observations)
    }
  ),
  private = list(
    grid = grid_template(default = list(
      areas = rbind(
        c("ship_type", "ships"),
        c("map", "map")
      ),
      rows_height = c("150px", "auto"),
      cols_width = c("1fr", "4fr")
    ))
  )
)
