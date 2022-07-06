library(dataaimsr)

with_mock_api({
  test_that("Correct structure", {
    expect_is(aims_filter_values("weather", filter_name = "site"), "character")
    expect_is(aims_filter_values("weather", filter_name = "series"),
              "data.frame")
    expect_is(aims_filter_values("weather", filter_name = "subsite"),
              "character")
    # expect_is(aims_filter_values("weather", filter_name = "parameter"),
    #           "character")
    expect_is(aims_filter_values("temp_loggers", filter_name = "site"),
              "character")
    expect_identical(aims_filter_values("temp_loggers",
                                        filter_name = "series"),
                     aims_filter_values("temp_loggers",
                                        filter_name = "subsite"))
    expect_is(aims_filter_values("temp_loggers", filter_name = "parameter"),
              "character")
  })
})

with_mock_api({
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

with_mock_api({
  test_that("Fake bad connection", {
    Sys.setenv("NETWORK_UP" = FALSE)
    expect_message(aims_filter_values("weather", filter_name = "parameter"),
                   "internet connection")
    Sys.setenv("NETWORK_UP" = TRUE)
  })
})
