library(dataaimsr)

weather_doi <- data_doi("weather")
ssts_doi <- data_doi("temp_loggers")
base_end_pt <- make_base_end_pt(weather_doi, aims_version = NA)
good_pt <- paste(base_end_pt, weather_doi, "data", sep = "/")
bad_pt <- paste(base_end_pt, weather_doi, "wrong", sep = "/")

test_that("API key finder", {
  expect_error(find_api_key())
  expect_is(find_api_key(my_api_key), "character")
  key_ <- Sys.getenv("AIMS_DATAPLATFORM_API_KEY")
  Sys.setenv(AIMS_DATAPLATFORM_API_KEY = "empty")
  expect_is(find_api_key(NULL), "character")
  expect_identical(find_api_key(NULL), "empty")
  expect_identical(find_api_key(10), 10)
  expect_identical(find_api_key(NA), NA)
  expect_identical(find_api_key("something"), "something")
  Sys.setenv(AIMS_DATAPLATFORM_API_KEY = key_)
})

test_that("http error handling", {
  expect_error(handle_error(NA))
  expect_error(handle_error(10))
  expect_error(handle_error(TRUE))
  expect_error(handle_error(NULL))
})

with_mock_dir("JSON-results-Correct-structure-helpers", {
  test_that("JSON results - Correct structure", {
    good_dt_req <- GET(good_pt,
                       add_headers("X-Api-Key" = find_api_key(my_api_key)),
                       query = w_filters)
    bad_dt_req <- GET(bad_pt,
                      add_headers("X-Api-Key" = find_api_key(my_api_key)))
    expect_is(json_results(good_dt_req), "list")
    expect_true(all(c("metadata", "citation", "links", "results") %in%
                      names(json_results(good_dt_req))))
    expect_is(json_results(good_dt_req)$results, "data.frame")
    expect_identical(names(json_results(good_dt_req)$links), "next")
    expect_is(json_results(bad_dt_req), "list")
    expect_false(all(c("metadata", "citation", "links", "results") %in%
                       names(json_results(bad_dt_req))))
    expect_true(names(json_results(bad_dt_req)) == "message")
  })
})

test_that("End point creation - Correct structure", {
  expect_is(make_base_end_pt(weather_doi), "character")
  expect_is(make_base_end_pt(ssts_doi), "character")
  expect_identical(make_base_end_pt("something"),
                   "https://api.aims.gov.au/dataNA")
  expect_identical(make_base_end_pt(10),
                   "https://api.aims.gov.au/dataNA")
  expect_identical(make_base_end_pt(NA),
                   rep("https://api.aims.gov.au/dataNA", 2))
  expect_identical(make_base_end_pt(NULL),
                   "https://api.aims.gov.au/data")
})

with_mock_dir("Correctly-process-requests", {
  test_that("Correctly process requests", {
    good_dt_req <- GET(good_pt,
                       add_headers("X-Api-Key" = find_api_key(my_api_key)),
                       query = w_filters)
    bad_dt_req <- GET(bad_pt,
                      add_headers("X-Api-Key" = find_api_key(my_api_key)))
    expect_message(
      expect_is(process_request(good_dt_req, doi = weather_doi), "list")
    )
    expect_message(
      expect_true(all(c("metadata", "citation", "links", "data") %in%
                        names(process_request(good_dt_req,
                                              doi = weather_doi))))
    )
    expect_message(
      expect_is(process_request(good_dt_req, doi = weather_doi)$data,
                "data.frame")
    )
    expect_error(process_request(bad_dt_req, doi = weather_doi))
  })
})

with_mock_dir("Correctly-update-request-output-format", {
  test_that("Correctly update request output format", {
    good_dt_req <- GET(good_pt,
                       add_headers("X-Api-Key" = find_api_key(my_api_key)),
                       query = w_filters)
    bad_dt_req <- GET(bad_pt,
                      add_headers("X-Api-Key" = find_api_key(my_api_key)))
    json_out <- json_results(good_dt_req)
    expect_is(update_format(json_out), "list")
    expect_true(all(c("metadata", "citation", "links", "data") %in%
                      names(update_format(json_out))))
    expect_is(update_format(json_out)$data, "data.frame")
    expect_identical(update_format(json_out)$metadata,
                     json_results(good_dt_req)$metadata)
    expect_identical(update_format(json_out)$citation,
                     json_results(good_dt_req)$citation)
    expect_identical(names(update_format(json_out)$links), "next_page")
    expect_identical(update_format(json_out)$links[[1]],
                     json_results(good_dt_req)$links[[1]])
  })
})

test_that("Correct structure", {
  wrong_doi <- "string"
  expect_identical(data_doi("weather"), "10.25845/5c09bf93f315d")
  expect_identical(data_doi("temp_loggers"), "10.25845/5b4eb0f9bb848")
  expect_error(data_doi(wrong_doi))
  expect_error(data_doi(FALSE))
  expect_error(data_doi(NA))
  expect_error(data_doi(NULL))
})

test_that("Correct structure", {
  expect_identical(make_pretty_data_label("weather"), "Weather Station")
  expect_identical(make_pretty_data_label("temp_loggers"),
                   "Temperature loggers")
  expect_identical(make_pretty_data_label(10),
                   "Temperature loggers")
  expect_identical(make_pretty_data_label(TRUE),
                   "Temperature loggers")
  expect_identical(make_pretty_data_label(NA), NA)
  expect_vector(make_pretty_data_label(NULL))
})

test_that("Correct structure", {
  expect_identical(make_pretty_colour("blue"), "#0000FF8C")
  expect_identical(make_pretty_colour(NA), "#FFFFFF8C")
  expect_error(make_pretty_colour(NA, NA))
})

test_that("Correct structure", {
  expect_identical(capitalise("abc"), "Abc")
  expect_identical(capitalise(NA), "NANA")
  expect_vector(capitalise(NULL))
})

my_list <- list(a = list(k = 1, l = 2), b = list(k = "A", l = "b"))
test_that("Correct structure", {
  expect_identical(unname(extract_map_coord(my_list, 1)), c("1", "A"))
  expect_identical(unname(extract_map_coord(my_list, 2)), c("2", "b"))
  expect_is(extract_map_coord(my_list, NA), "list")
  expect_null(extract_map_coord(my_list, NA)[[1]])
})
