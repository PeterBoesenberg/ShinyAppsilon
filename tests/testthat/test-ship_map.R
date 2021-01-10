library(data.table)
setwd("../..")


test_that("ShipMap", {
  sot <- ShipMap$new()

  test_that("calculate_distance", {
    test_that("should return distance in meters", {
      coordinates <- data.table(LAT = c(54.76542, 53.76542), LON = c(18.99361, 17.99361))
      result <- sot$calculate_distance(coordinates)
      expect_true(result == 128680)
    })
  })
  test_that("get_map_ui", {
    test_that("should return html with namespaced id", {
      result <- sot$get_map_ui("dummy")
      expect_true(grepl("id=\"dummy-map\"", result))
      expect_true(grepl("id=\"dummy-note\"", result))
    })
  })
})
