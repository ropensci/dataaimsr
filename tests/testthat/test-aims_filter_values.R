with_mock_dir("Correct-structure-filtervalues", {
  test_that("Correct structure", {
    expect_is(aims_filter_values("weather", filter_name = "site"), "data.frame")
    expect_is(aims_filter_values("weather", filter_name = "series"),
              "data.frame")
    expect_is(aims_filter_values("temp_loggers", filter_name = "site"),
              "data.frame")
    expect_is(aims_filter_values("temp_loggers", filter_name = "series"),
              "data.frame")
    expect_is(aims_filter_values("temp_loggers", filter_name = "parameter"),
              "data.frame")
  })
})

with_mock_dir("Wrong-inputs-filtervalues", {
  test_that("Wrong inputs", {
    expect_error(aims_filter_values("string", filter_name = "site"))
    expect_error(aims_filter_values("string", filter_name = "series_id"))
    expect_error(aims_filter_values("string", filter_name = "site-name"))
    expect_error(aims_filter_values("string", filter_name = "site_name"))
    expect_error(aims_filter_values("temp_loggers"))
    expect_error(aims_filter_values("weather",
                                    filter_name = c("site", "series")))
    expect_error(aims_filter_values("temp_loggers",
                                    filter_name = c("site", "series")))
  })
})

with_mock_dir("Fake-bad-connection-filtervalues", {
  test_that("Fake bad connection", {
    Sys.setenv("NETWORK_UP" = FALSE)
    expect_message(aims_filter_values("weather", filter_name = "parameter"),
                   "internet connection")
    Sys.setenv("NETWORK_UP" = TRUE)
  })
})
