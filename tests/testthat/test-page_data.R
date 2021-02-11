library(dataaimsr)

# default to 1000 returns next_page link
check_wa <- page_data(weather_doi, filters = w_filters, api_key = my_api_key)
check_sa <- page_data(ssts_doi, filters = s_filters, api_key = my_api_key)
# larger size removed links from output
check_wb <- page_data(weather_doi, filters = w_filters_b, api_key = my_api_key)
check_sb <- page_data(ssts_doi, filters = s_filters_b, api_key = my_api_key)
# next_page works
check_wa_n <- next_page_data(check_wa$links$next_page, api_key = my_api_key)
check_sa_n <- next_page_data(check_sa$links$next_page, api_key = my_api_key)
final_nrow_wa <- nrow(check_wa$data) + nrow(check_wa_n$data)
final_nrow_sa <- nrow(check_sa$data) + nrow(check_sa_n$data)

test_that("Correct structure", {
  expect_is(check_wa, "list")
  expect_length(check_wa, 4)
  expect_true("links" %in% names(check_wa))
  expect_is(check_wa$links, "list")
  expect_identical(names(check_wa$links), "next_page")
  expect_is(check_sa, "list")
  expect_length(check_sa, 5)
  expect_true(all(c("cursor", "links") %in% names(check_sa)))
  expect_is(check_sa$links, "list")
  expect_identical(names(check_sa$links), "next_page")
  expect_is(check_wb, "list")
  expect_length(check_wb, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_wb)))
  expect_is(check_sb, "list")
  expect_length(check_sb, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_sb)))
  expect_is(check_wa_n, "list")
  expect_length(check_wa_n, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_wa_n)))
  expect_is(check_sa_n, "list")
  expect_length(check_sa_n, 3)
  expect_true(all(c("metadata", "citation", "data") %in% names(check_sa_n)))
  expect_identical(final_nrow_sa, nrow(check_sb$data))
  expect_identical(final_nrow_wa, nrow(check_wb$data))
})

test_that("Wrong filters", {
  expect_error(page_data(weather_doi, filters = w_filters_c,
                         api_key = my_api_key))
  expect_error(page_data(weather_doi, filters = w_filters_d,
                         api_key = my_api_key))
})

test_that("summary requests", {
  expect_error(page_data(weather_doi, api_key = my_api_key,
                         summary = "summary-by-series"))
  expect_error(page_data(weather_doi, api_key = my_api_key,
                         summary = "summary-by-deployment"))
  expect_message(expect_is(page_data(ssts_doi, api_key = my_api_key,
                                     summary = "summary-by-series"),
                 "data.frame"))
  expect_message(expect_is(page_data(ssts_doi, api_key = my_api_key,
                                     summary = "summary-by-deployment"),
                 "data.frame"))
})
