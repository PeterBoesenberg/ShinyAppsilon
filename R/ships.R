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
