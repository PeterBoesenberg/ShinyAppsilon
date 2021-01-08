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
                       round(geodist(coordinates[1]$LAT, coordinates[1]$LON, coordinates[2]$LAT, coordinates[2]$LON, units="km") * 1000)
                     }
                   ),
                   private = list()
                   )