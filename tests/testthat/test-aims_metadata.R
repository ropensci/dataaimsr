library(dataaimsr)

# regular monitoring data
check_wa <- aims_data("weather", filters = w_filters, api_key = my_api_key)
check_sa <- aims_data("temp_loggers", filters = s_filters,
                      api_key = my_api_key)
# summary data
sdf_s <- aims_data("temp_loggers", api_key = my_api_key,
                   summary = "summary-by-series")
sdf_d <- aims_data("temp_loggers", api_key = my_api_key,
                   summary = "summary-by-deployment")
test_that("Correct structure", {
  expect_is(aims_metadata(check_wa), "character")
  expect_is(aims_metadata(check_sa), "character")
  expect_is(aims_metadata(sdf_s), "character")
  expect_identical(aims_metadata(sdf_s), "")
  expect_is(aims_metadata(sdf_d), "character")
  expect_identical(aims_metadata(sdf_d), "")
  expect_error(aims_metadata(data.frame()))
  expect_error(aims_metadata(NULL))
  expect_error(aims_metadata(NA))
  expect_error(aims_metadata(TRUE))
  expect_error(aims_metadata(10))
  expect_error(aims_metadata(list()))
})
