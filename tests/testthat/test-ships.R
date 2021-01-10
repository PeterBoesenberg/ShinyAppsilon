library(data.table)
# set working directory to find CSV
setwd("../..")


test_that("Ships", {
  sot <- Ships$new()

  test_that("should populate ships on creation", {
    expect_false(is.null(sot$ships))
    expect_gt(nrow(sot$ships), 0)
  })

  test_that("should populate ship_types on creation", {
    expect_false(is.null(sot$ship_types))
  })

  test_that("get_ships_by_type", {
    test_that("should return a non-empty list for a valid ship_type", {
      result <- sot$get_ships_by_type("Cargo")
      expect_gt(length(result), 0)
    })
    test_that("should return empty list for a invalid ship_type", {
      result <- sot$get_ships_by_type("ssdfsdfaaf")
      expect_length(result, 0)
    })
  })

  test_that("get_longest_distance", {
    test_that("should return datatable with 2 rows for valid shipname", {
      result <- sot$get_longest_distance("KAROLI")
      expect(nrow(result), 2)
    })
    test_that("should return NULL for empty shipname", {
      result <- sot$get_longest_distance("")
      expect_true(is.null(result))
    })
  })

  test_that("get_ship_type_dropdown_ui", {
    test_that("should return html with namespaced id", {
      result <- sot$get_ship_type_dropdown_ui("dummy")
      expect_true(grepl("id=\"dummy-ship_types\"", result))
    })
  })

  test_that("get_ships_dropdown_ui", {
    test_that("should return html with namespaced id", {
      result <- sot$get_ships_dropdown_ui("dummy")
      expect_true(grepl("id=\"dummy-ships\"", result))
    })
  })
})

