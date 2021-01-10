library(shiny)
library(shiny.semantic)
library(R6)
library(data.table)

Ships <- R6Class("Ships",
  public = list(
    ships = NULL,
    ship_types = NULL,

    #' Read in data from CSV and populate Ship Type list
    #'
    #' @export
    initialize = function() {
      private$read()
      private$set_value_lists()
    },

    #' Get all ship names for a given ship type.
    #' Ship names are sorted alphabetical.
    #'
    #' @param ship_type string, name of the ship type
    #'
    #' @return sorted list of ship names
    #' @export
    get_ships_by_type = function(ship_type) {
      filter_value <- ship_type
      sort(self$ships[ship_type == filter_value, unique(SHIPNAME)])
    },

    #' Get the longest distance a ship has moved between two consecutive observations.
    #' Adds column "distance", which is the distance between one observation and its predecessor.
    #'
    #' @param ship string, name of the ship
    #'
    #' @return datatable with two rows, new column "distance" added
    #' @export
    get_longest_distance = function(ship) {
      distance <- NULL
      if (ship != "") {
        ship_logs <- self$ships[SHIPNAME == ship]
        ship_logs[, distance := round(geodist(LAT, LON, shift(LAT, 1), shift(LON, 1), units = "km") * 1000)]
        max_distance_index <- ship_logs[distance == max(distance, na.rm = TRUE), which = TRUE]
        distance <- ship_logs[(max_distance_index - 1):max_distance_index]
      }
      distance
    },

    #' Get UI of ship type dropdown module.
    #' Dropdown is filled with all shiptypes from class variable "ship_types".
    #'
    #' @param id string, used for namespacing
    #'
    #' @return dropdown-input tag
    #' @export
    get_ship_type_dropdown_ui = function(id) {
      ns <- NS(id)
      dropdown_input(ns("ship_types"), self$ship_types, value = NULL, type = "search selection single")
    },

    #' Get server-part of ship type dropdown-module.
    #' Observes changed in ship-type selection and updates selected_ship_type.
    #'
    #' @param input shiny input
    #' @param output shiny output
    #' @param session shiny session
    #' @param selected_ship_type reactive value of selected ship type
    #'
    #' @export
    get_ship_type_dropdown_server = function(input, output, session, selected_ship_type) {
      observeEvent(input$ship_types, {
        selected_ship_type(input$ship_types)
      })
    },
    #' Get UI of ships dropdown module.
    #' Dropdown is initally empty.
    #'
    #' @param id string, used for namespacing
    #'
    #' @return dropdown-input tag
    #' @export
    get_ships_dropdown_ui = function(id) {
      ns <- NS(id)
      dropdown_input(ns("ships"), NULL, value = NULL, type = "search selection single")
    },

    #' Get server-part of ships dropdown-module.
    #' Refreshes ship dropdown based on selected_ship_types.
    #' Observes changed in ship selection and updates ship-observations..
    #' @param input shiny input
    #' @param output shiny output
    #' @param session shiny session
    #' @param selected_ship_type reactive value of selected ship type
    #' @param ship_observations reactive value of ship observations
    #'
    #' @export
    get_ships_dropdown_server = function(input, output, session, selected_ship_type, ship_observations) {
      observeEvent(selected_ship_type(), {
        selected_ships <- self$get_ships_by_type(selected_ship_type())
        update_dropdown_input(session, "ships", choices = selected_ships)
      })
      observeEvent(input$ships, {
        if (input$ships != "") {
          points <- self$get_longest_distance(input$ships)
          ship_observations(points)
        }
      })
    }
  ),
  private = list(
    #' Read ship observations from CSV and set it in class-variable "ships".
    #'
    #' @export
    read = function() {
      self$ships <- fread("data/ships.csv")
    },
    #' Populate value list ship_types based on available ship_types in CSV.
    #'
    #' @export
    set_value_lists = function() {
      self$ship_types <- sort(self$ships[, unique(ship_type)])
    }
  )
)
