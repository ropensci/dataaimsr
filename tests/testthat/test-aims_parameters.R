with_mock_dir("Correct-structure-parameters", {
  test_that("Correct structure", {
    # regular monitoring data
    wa <- aims_data("weather", filters = w_filters, api_key = my_api_key)
    sa <- aims_data("temp_loggers", filters = s_filters,
                    api_key = my_api_key)
    # summary data
    ss <- aims_data("temp_loggers", api_key = my_api_key,
                    summary = "summary-by-series")
    sd <- aims_data("temp_loggers", api_key = my_api_key,
                    summary = "summary-by-deployment")
    expect_is(aims_parameters(wa), "character")
    expect_identical(aims_parameters(wa), "Air Temperature")
    expect_is(aims_parameters(sa), "character")
    expect_identical(aims_parameters(sa), "Water Temperature")
    expect_is(aims_parameters(ss), "character")
    expect_identical(aims_parameters(ss), "")
    expect_is(aims_parameters(sd), "character")
    expect_identical(aims_parameters(sd), "")
    expect_error(aims_parameters(data.frame()))
    expect_error(aims_parameters(NULL))
    expect_error(aims_parameters(NA))
    expect_error(aims_parameters(TRUE))
    expect_error(aims_parameters(10))
    expect_error(aims_parameters(list()))
  })
})
