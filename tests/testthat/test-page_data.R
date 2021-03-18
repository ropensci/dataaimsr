library(dataaimsr)

weather_doi <- data_doi("weather")
ssts_doi <- data_doi("temp_loggers")

with_mock_api({
  test_that("Correct structure", {
    # default to 1000 returns next_page link
    wa <- page_data(weather_doi, filters = w_filters, api_key = my_api_key)
    sa <- page_data(ssts_doi, filters = s_filters, api_key = my_api_key)
    # larger size removed links from output
    wb <- page_data(weather_doi, filters = w_filters_b, api_key = my_api_key)
    sb <- page_data(ssts_doi, filters = s_filters_b, api_key = my_api_key)
    # next_page works
    wa_n <- next_page_data(wa$links$next_page, api_key = my_api_key)
    sa_n <- next_page_data(sa$links$next_page, api_key = my_api_key)
    final_nrow_wa <- nrow(wa$data) + nrow(wa_n$data)
    final_nrow_sa <- nrow(sa$data) + nrow(sa_n$data)
    expect_is(wa, "list")
    expect_length(wa, 4)
    expect_true("links" %in% names(wa))
    expect_is(wa$links, "list")
    expect_identical(names(wa$links), "next_page")
    expect_is(sa, "list")
    expect_length(sa, 5)
    expect_true(all(c("cursor", "links") %in% names(sa)))
    expect_is(sa$links, "list")
    expect_identical(names(sa$links), "next_page")
    expect_is(wb, "list")
    expect_length(wb, 3)
    expect_true(all(c("metadata", "citation", "data") %in% names(wb)))
    expect_is(sb, "list")
    expect_length(sb, 3)
    expect_true(all(c("metadata", "citation", "data") %in% names(sb)))
    expect_is(wa_n, "list")
    expect_length(wa_n, 3)
    expect_true(all(c("metadata", "citation", "data") %in% names(wa_n)))
    expect_is(sa_n, "list")
    expect_length(sa_n, 3)
    expect_true(all(c("metadata", "citation", "data") %in% names(sa_n)))
    expect_identical(final_nrow_sa, nrow(sb$data))
    expect_identical(final_nrow_wa, nrow(wb$data))
  })
})

with_mock_api({
  test_that("Wrong filters", {
    texpect <- function(...) expect_message(expect_error(expect_is(...)))
    texpect(page_data(weather_doi, filters = w_filters_c,
                      api_key = my_api_key), "data.frame")
    texpect(page_data(weather_doi, filters = w_filters_d,
                      api_key = my_api_key), "data.frame")
  })
})

with_mock_api({
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
})
