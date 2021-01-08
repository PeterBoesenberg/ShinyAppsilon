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
                     filter_value <- as.integer(ship_type)
                     sort(self$ships[SHIPTYPE == filter_value, unique(SHIPNAME)])
                   },
                   get_longest_distance = function (ship) {
                     self$ships[SHIPNAME == ship][c(1,2)]
                   }

                 ),
                 private = list(
                   read = function() {
                     self$ships <- fread("input/ships.csv")
                   },
                   set_value_lists = function(){
                     self$ship_types <- sort(self$ships[, unique(SHIPTYPE)])
                   }
                 )
)

