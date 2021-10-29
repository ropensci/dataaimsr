library(dataaimsr)

with_mock_api({
  test_that("Correct structure", {
    # default to 1000 returns next_page link
    check_wa <- aims_data("weather", filters = w_filters, api_key = my_api_key)
    check_sa <- aims_data("temp_loggers", filters = s_filters,
                          api_key = my_api_key)
    expect_is(check_wa, "data.frame")
    expect_true(all(c("metadata", "citation", "parameters") %in%
                        names(attributes(check_wa))))
    expect_s3_class(check_wa, "aimsdf")
    # larger size removed links from output
    check_wb <- aims_data("weather", filters = w_filters_b,
                          api_key = my_api_key)
    check_sb <- aims_data("temp_loggers", filters = s_filters_b,
                          api_key = my_api_key)
    expect_is(check_sa, "data.frame")
    expect_true(all(c("metadata", "citation", "parameters") %in%
                        names(attributes(check_sa))))
    expect_is(check_wb, "data.frame")
    expect_true(all(c("metadata", "citation", "parameters") %in%
                        names(attributes(check_wb))))
    expect_is(check_sb, "data.frame")
    expect_true(all(c("metadata", "citation", "parameters") %in%
                        names(attributes(check_sb))))
    expect_s3_class(check_sa, "aimsdf")
    expect_s3_class(check_wb, "aimsdf")
    expect_s3_class(check_sb, "aimsdf")
  })
})

with_mock_api({
  test_that("Wrong filters", {
    check_wc <- aims_data("weather", filters = w_filters_c,
                          api_key = my_api_key)
    check_wd <- aims_data("weather", filters = w_filters_d,
                          api_key = my_api_key)
    check_sc <- aims_data("temp_loggers", filters = s_filters_c,
                          api_key = my_api_key)
    check_sd <- aims_data("temp_loggers", filters = s_filters_d,
                          api_key = my_api_key)
    expect_null(check_wc)
    expect_null(check_wd)
    expect_null(check_sc)
    expect_null(check_sd)
  })
})

with_mock_api({
  test_that("summary requests", {
    expect_message(aims_data("temp_loggers", filters = s_filters,
                             api_key = my_api_key, summary = "daily"))
    expect_message(aims_data("weather", api_key = my_api_key,
                             summary = "summary-by-series"))
    expect_message(aims_data("weather", api_key = my_api_key,
                             summary = "summary-by-deployment"))
    expect_message(expect_is(aims_data("temp_loggers", api_key = my_api_key,
                                       summary = "summary-by-series"),
                   "data.frame"))
    expect_message(expect_is(aims_data("temp_loggers", api_key = my_api_key,
                                       summary = "summary-by-deployment"),
                   "data.frame"))
  })
})

with_mock_api({
  test_that("Fake bad connection", {
    Sys.setenv("NETWORK_UP" = FALSE)
    expect_message(aims_data("weather", api_key = my_api_key,
                             summary = "summary-by-deployment"),
                   "internet connection")
    Sys.setenv("NETWORK_UP" = TRUE)
  })
})
