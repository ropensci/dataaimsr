library(dataaimsr)

# default to 1000 returns next_page link
check_wa <- aims_data("weather", filters = w_filters, api_key = my_api_key)
check_sa <- aims_data("temp_loggers", filters = s_filters,
                      api_key = my_api_key)
# larger size removed links from output
check_wb <- aims_data("weather", filters = w_filters_b,
                      api_key = my_api_key)
check_sb <- aims_data("temp_loggers", filters = s_filters_b,
                      api_key = my_api_key)

test_that("Correct structure", {
  expect_is(check_wa, "list")
  expect_length(check_wa, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_wa)))
  expect_is(check_sa, "list")
  expect_length(check_sa, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_sa)))
  expect_is(check_wb, "list")
  expect_length(check_wb, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_wb)))
  expect_is(check_sb, "list")
  expect_length(check_sb, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_sb)))
})

check_wc <- aims_data("weather", filters = w_filters_c, api_key = my_api_key)
check_wd <- aims_data("weather", filters = w_filters_d, api_key = my_api_key)
check_sc <- aims_data("temp_loggers", filters = s_filters_c, api_key = my_api_key)
check_sd <- aims_data("temp_loggers", filters = s_filters_d, api_key = my_api_key)

test_that("Wrong filters", {
  expect_is(check_wc, "list")
  expect_length(check_wc, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_wc)))
  expect_null(nrow(check_wc$data))
  expect_is(check_wd, "list")
  expect_length(check_wd, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_wd)))
  expect_null(nrow(check_wd$data))
  expect_is(check_sc, "list")
  expect_length(check_sc, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_sc)))
  expect_null(nrow(check_sc$data))
  expect_is(check_sd, "list")
  expect_length(check_sd, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_sd)))
  expect_null(nrow(check_sd$data))
})

test_that("summary requests", {
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
