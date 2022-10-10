with_mock_dir("Citation", {
  test_that("Correct structure", {
    # regular monitoring data
    wa <- aims_data(
      "weather", filters = valid_weather_filters(), api_key = null_api_key()
    )
    sa <- aims_data(
      "temp_loggers", filters = valid_tlogger_filters(),
      api_key = null_api_key()
    )
    # summary data
    ss <- aims_data("temp_loggers", api_key = null_api_key(),
                    summary = "summary-by-series")
    sd <- aims_data("temp_loggers", api_key = null_api_key(),
                    summary = "summary-by-deployment")
    expect_is(aims_citation(wa), "character")
    expect_is(aims_citation(sa), "character")
    expect_is(aims_citation(ss), "character")
    expect_identical(aims_citation(ss), "")
    expect_is(aims_citation(sd), "character")
    expect_identical(aims_citation(sd), "")
    expect_error(aims_citation(data.frame()))
    expect_error(aims_citation(NULL))
    expect_error(aims_citation(NA))
    expect_error(aims_citation(TRUE))
    expect_error(aims_citation(10))
    expect_error(aims_citation(list()))
  })
})
