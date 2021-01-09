library(R6)
library(gmt)

ShipMap <- R6Class("ShipMap",
  public = list(
    set_markers_on_map = function(coordinates, output) {
      output$map <- renderLeaflet({
        leaflet() %>%
          addProviderTiles(providers$Stamen.TonerLite,
            options = providerTileOptions(noWrap = TRUE)
          ) %>%
          addMarkers(data = coordinates, ~LON, ~LAT)
      })
    },
    build_distance_note = function(coordinates, output) {
      distance <- self$calculate_distance(coordinates)
      output$note <- renderText({
        paste0("Coordinates are ", distance, " meters apart")
      })
    },
    calculate_distance = function(coordinates) {
      round(geodist(coordinates[1]$LAT, coordinates[1]$LON, coordinates[2]$LAT, coordinates[2]$LON, units = "km") * 1000)
    },

    get_map_ui = function(id) {
      ns <- NS(id)
      tagList(
        leafletOutput(ns("map")),
        textOutput(ns("note"))
      )
    },

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
  private = list(
    
  )
)