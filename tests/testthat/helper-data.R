library(httptest)
library(dataaimsr)

add_attr <- function(x, ...) {
  add_args <- list(...)
  c(x, add_args)
}

with_mock_dir <- function(name, ...) {
	httptest::with_mock_dir(file.path("../api", name), ...)
}

null_api_key <- function() {
  NULL
}

valid_weather_filters <- function() {
  list(series_id = 64, from_date = "2018-01-01", thru_date = "2018-01-10")
}

weather_filters_larger_size <- function() {
  add_attr(valid_weather_filters(), size = 1e4)
}

invalid_weather_filters_series <- function() {
  list(series = 64)
}

invalid_weather_filters_dates <- function() {
  list(series_id = 64, from_date = "1900-01-01", thru_date = "1900-01-10")
}

valid_tlogger_filters <- function() {
  list(series_id = 2687, from_date = "2005-01-01", thru_date = "2005-01-10",
       size = 300)
}

tlogger_filters_no_size <- function() {
  valid_tlogger_filters()[-4]
}

invalid_weather_filters_series <- function() {
  list(series = 2687)
}

invalid_weather_filters_dates <- function() {
  list(series_id = 2687, from_date = "1900-01-01", thru_date = "1900-01-10")
}
