library(dataaimsr)

add_attr <- function(x, ...) {
  add_args <- list(...)
  c(x, add_args)
}

weather_doi <- aims_data_doi("weather")
ssts_doi <- aims_data_doi("temp_loggers")
wrong_doi <- "string"
my_api_key <- "dFpi9Qum8Q8cNAxnK4Q8Q4PoRrd7SBp9asHISDnI"
w_filters <- list(series_id = 64, from_date = "2018-01-01",
                  thru_date = "2018-01-10")
w_filters_b <- add_attr(w_filters, size = 1e4)
w_filters_c <- list(series = 64)
w_filters_d <- list(series_id = 64, from_date = "1900-01-01",
                    thru_date = "1900-01-10")

s_filters <- list(series_id = 2687, from_date = "2005-01-01",
                  thru_date = "2005-01-10", size = 300)
s_filters_b <- s_filters[-4]
s_filters_c <- list(series = 2687)
s_filters_d <- list(series_id = 2687, from_date = "1900-01-01",
                    thru_date = "1900-01-10")
