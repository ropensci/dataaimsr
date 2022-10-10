with_mock_dir("Correct-structure-metadata", {
  test_that("Correct structure metadata", {
    # regular monitoring data
    wa <- aims_data("weather", filters = w_filters, api_key = my_api_key)
    sa <- aims_data("temp_loggers", filters = s_filters,
                          api_key = my_api_key)
    # summary data
    ss <- aims_data("temp_loggers", api_key = my_api_key,
                       summary = "summary-by-series")
    sd <- aims_data("temp_loggers", api_key = my_api_key,
                       summary = "summary-by-deployment")
    expect_is(aims_metadata(wa), "character")
    expect_is(aims_metadata(sa), "character")
    expect_is(aims_metadata(ss), "character")
    expect_identical(aims_metadata(ss), "")
    expect_is(aims_metadata(sd), "character")
    expect_identical(aims_metadata(sd), "")
    expect_error(aims_metadata(data.frame()))
    expect_error(aims_metadata(NULL))
    expect_error(aims_metadata(NA))
    expect_error(aims_metadata(TRUE))
    expect_error(aims_metadata(10))
    expect_error(aims_metadata(list()))
  })
})
