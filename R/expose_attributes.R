#' Expose available query filters
#'
#' Expose available query filters which are allowed to be parsed either
#' via argument \code{summary} or \code{filters} in \code{\link{aims_data}}
#'
#' @inheritParams aims_data
#'
#' @details Use this function to learn which summary modes and
#' filters are allowed.
#'
#' We are working on implementing summary visualisation methods for weather
#' station data. So, for the moment, the options below are only available
#' for temperature logger data. Two options are available:
#'
#' \itemize{
#'    \item{summary-by-series}{Expose summary for all available series;
#'          a series is a continuing time-series, i.e. a collection of
#'          deployments measuring the same parameter at the same site.
#'          For temperature loggers, series is synonymous with sub-site.
#'          For weather stations, it is the combination of sub-site and
#'          parameter.}
#'    \item{summary-by-deployment}{Expose summary for all available
#'          deployments.}
#' }
#'
#' We offer a list of valid filter names:
#'
#' \itemize{
#'    \item{site}{Filter by a particular site.}
#'    \item{subsite}{Filter by a particular subsite.}
#'    \item{series}{Filter by a particular series.}
#'    \item{series_id}{A unique identifier for the series - it should be
#' unique within a dataset. An alternative to looking up a series by name.}
#'    \item{parameter}{Parameter of interest. Only relevant for
#' weather station data because temperature logger is always water
#' temperature.}
#'    \item{min_lat}{Minimum latitude; used to filter by a
#' lat-lon box.}
#'    \item{max_lat}{Maximum latitude; used to filter by a
#' lat-lon box.}
#'    \item{min_lon}{Minimum longitude; used to filter by a
#' lat-lon box.}
#'    \item{max_lon}{Maximum longitude; used to filter by a
#' lat-lon box.}
#'    \item{from_date}{Filter from time (string of format
#' YYYY-MM-DD).}
#'    \item{thru_date}{Filter until time (string of format
#' YYYY-MM-DD).}
#' }
#'
#' Some additional options for the actual download, which should be passed as
#' additional arguments to the function, are:
#' \itemize{
#'    \item{size}{Set a page size for large queries
#'          (only for the `data` and `data-no-key` endpoints).}
#'    \item{cursor}{Used for pagination on / data").}
#'    \item{version}{Request the data as recorded at a particular time
#'          (a version history).}
#' }
#'
#' @return A \code{\link[base]{list}} of two \code{\link[base]{character}}
#' vectors: one detailing summary modes, another detailing filters.
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' weather_doi <- aims_data_doi("weather")
#' ssts_doi <- aims_data_doi("temp_loggers")
#' expose_attributes(weather_doi)
#' expose_attributes(ssts_doi)
#' }
#'
#' @export
expose_attributes <- function(doi) {
  w_doi <- aims_data_doi("weather")
  tl_doi <- aims_data_doi("temp_loggers")
  if (doi == tl_doi) {
    list(summary = c("summary-by-series", "summary-by-deployment"),
         filters = c("site", "subsite", "series", "series_id", "parameter",
                     "size", "min_lat", "max_lat", "min_lon", "max_lon",
                     "from_date", "thru_date", "version", "cursor"))
  } else if (doi == w_doi) {
    list(summary = NA,
         filters = c("site", "subsite", "series", "series_id", "parameter",
                     "size", "min_lat", "max_lat", "min_lon", "max_lon",
                     "from_date", "thru_date", "version", "cursor"))
  }
}
