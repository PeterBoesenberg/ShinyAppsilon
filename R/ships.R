library(R6)
library(data.table)

Ships <- R6Class("Ships",
  public = list(
    ships = NULL,
    ship_types = NULL,

    initialize = function() {
      private$read()
      private$set_value_lists()
    },
    get_ships_by_type = function(ship_type) {
      filter_value <- ship_type
      sort(self$ships[ship_type == filter_value, unique(SHIPNAME)])
    },
    get_longest_distance = function(ship) {
      distance <- 0
      if (ship != "") {
        ship_logs <- self$ships[SHIPNAME == ship]
        ship_logs[, distance := round(geodist(LAT, LON, shift(LAT, 1), shift(LON, 1), units = "km") * 1000)]
        max_distance_index <- ship_logs[distance == max(distance, na.rm = TRUE), which = TRUE]
        distance <- ship_logs[(max_distance_index - 1):max_distance_index]
      }
      distance
    },
    
    get_ship_type_dropdown_ui = function(id) {
      ns <- NS(id)
      dropdown_input(ns("ship_types"), self$ship_types, value = NULL, type = "search selection single")
    },
    
    get_ship_type_dropdown_server = function(input, output, session, selected_ship_type) {
      observeEvent(input$ship_types, {
        selected_ship_type(input$ship_types)
      })
    },
    get_ships_dropdown_ui = function(id) {
      ns <- NS(id)
      dropdown_input(ns("ships"), NULL, value = NULL, type = "search selection single")
    },
    
    get_ships_dropdown_server = function(input, output, session, selected_ship_type, ship_observations) {
      observeEvent(selected_ship_type(), {
        selected_ships <- self$get_ships_by_type(selected_ship_type())
        update_dropdown_input(session, "ships", choices = selected_ships)
      })
      observeEvent(input$ships, {
        if(input$ships != "") {
          points <- self$get_longest_distance(input$ships)
          ship_observations(points)
        }
      })
    }
  ),
  private = list(
    read = function() {
      self$ships <- fread("input/ships.csv")
    },
    set_value_lists = function() {
      self$ship_types <- sort(self$ships[, unique(ship_type)])
    }
  )
)
