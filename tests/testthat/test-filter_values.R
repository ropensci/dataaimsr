library(dataaimsr)

test_that("Correct structure", {
  expect_is(filter_values(weather_doi, filter_name = "site"), "character")
  expect_is(filter_values(weather_doi, filter_name = "series"), "data.frame")
  expect_is(filter_values(weather_doi, filter_name = "subsite"), "character")
  expect_is(filter_values(weather_doi, filter_name = "parameter"), "character")
  expect_is(filter_values(ssts_doi, filter_name = "site"), "character")
  expect_identical(filter_values(ssts_doi, filter_name = "series"),
                   filter_values(ssts_doi, filter_name = "subsite"))
  expect_is(filter_values(ssts_doi, filter_name = "parameter"), "character")
})

test_that("Wrong inputs", {
  expect_error(filter_values(wrong_doi, filter_name = "site"))
  expect_error(filter_values(wrong_doi, filter_name = "series_id"))
  expect_error(filter_values(wrong_doi, filter_name = "site-name"))
  expect_error(filter_values(wrong_doi, filter_name = "site_name"))
  expect_error(filter_values(ssts_doi))
})
