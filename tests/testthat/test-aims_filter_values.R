library(dataaimsr)

test_that("Correct structure", {
  expect_is(aims_filter_values("weather", filter_name = "site"), "character")
  expect_is(aims_filter_values("weather", filter_name = "series"),
            "data.frame")
  expect_is(aims_filter_values("weather", filter_name = "subsite"),
            "character")
  expect_is(aims_filter_values("weather", filter_name = "parameter"),
            "character")
  expect_is(aims_filter_values("temp_loggers", filter_name = "site"),
            "character")
  expect_identical(aims_filter_values("temp_loggers", filter_name = "series"),
                   aims_filter_values("temp_loggers", filter_name = "subsite"))
  expect_is(aims_filter_values("temp_loggers", filter_name = "parameter"),
            "character")
})

test_that("Wrong inputs", {
  expect_error(aims_filter_values("string", filter_name = "site"))
  expect_error(aims_filter_values("string", filter_name = "series_id"))
  expect_error(aims_filter_values("string", filter_name = "site-name"))
  expect_error(aims_filter_values("string", filter_name = "site_name"))
  expect_error(aims_filter_values("temp_loggers"))
})
