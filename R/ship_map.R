library(R6)
library(gmt)
library(leaflet)

ShipMap <- R6Class("ShipMap",
  public = list(
    #' Set markers on map based on coordinates.
    #' Sets output property map.
    #' @param coordinates datatable with LAT and LON columns
    #' @param output shiny output, sets "map"
    #'
    #' @export
    set_markers_on_map = function(coordinates, output) {
      output$map <- renderLeaflet({
        leaflet() %>%
          addProviderTiles(providers$Stamen.TonerLite,
            options = providerTileOptions(noWrap = TRUE)
          ) %>%
          addMarkers(data = coordinates, ~LON, ~LAT)
      })
    },
    #' Build text note saying how many meters a ship has moved between two observations.
    #'
    #' @param coordinates datatable with LAT and LON columns
    #' @param output shiny output, sets "note"
    #'
    #' @export
    build_distance_note = function(coordinates, output) {
      distance <- self$calculate_distance(coordinates)
      output$note <- renderText({
        paste0("Coordinates are ", distance, " meters apart")
      })
    },
    #' calculate distance in meter between two observations measured in Lat/Lon.
    #'
    #' @param coordinates datatable with two rows and columns LAT LON
    #'
    #' @return integer, distance in meter
    #' @export
    calculate_distance = function(coordinates) {
      round(geodist(coordinates[1]$LAT, coordinates[1]$LON, coordinates[2]$LAT, coordinates[2]$LON, units = "km") * 1000)
    },

    #' Get UI of map module.
    #' Includes map and text note about how much distance is between two observations..
    #'
    #' @param id string, used for namespacing
    #'
    #' @return taglist with leaflet-map and text
    #' @export
    get_map_ui = function(id) {
      ns <- NS(id)
      tagList(
        leafletOutput(ns("map")),
        textOutput(ns("note"))
      )
    },

    #' Get server-part of maps-module.
    #' Creates initially an empty map.
    #' Refreshes markers and text note whenever ship_observations change
    #'
    #' @param input shiny input
    #' @param output shiny output
    #' @param session shiny session
    #' @param ship_observations reactive value of ship observations
    #'
    #' @export
    get_map_server = function(input, output, session, ship_observations) {
      output$map <- renderLeaflet({
        leaflet() %>%
          addProviderTiles(providers$Stamen.TonerLite,
            options = providerTileOptions(noWrap = TRUE)
          )
      })

      observeEvent(ship_observations(), {
        self$set_markers_on_map(ship_observations(), output)
        self$build_distance_note(ship_observations(), output)
      })
    }
  ),
  private = list()
)
