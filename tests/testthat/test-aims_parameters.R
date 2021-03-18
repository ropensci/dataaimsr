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
  expect_is(aims_parameters(check_wa), "character")
  expect_identical(aims_parameters(check_wa), "Air Temperature")
  expect_is(aims_parameters(check_sa), "character")
  expect_identical(aims_parameters(check_sa), "Water Temperature")
  expect_is(aims_parameters(sdf_s), "character")
  expect_identical(aims_parameters(sdf_s), "")
  expect_is(aims_parameters(sdf_d), "character")
  expect_identical(aims_parameters(sdf_d), "")
  expect_error(aims_parameters(data.frame()))
  expect_error(aims_parameters(NULL))
  expect_error(aims_parameters(NA))
  expect_error(aims_parameters(TRUE))
  expect_error(aims_parameters(10))
  expect_error(aims_parameters(list()))
})
