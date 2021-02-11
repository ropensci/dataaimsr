#' Retrieve vector of existing filter values
#'
#' This is a utility function which allows to user
#' to query about the existing possibilities of
#' a given filter name
#'
#' @inheritParams page_data
#'
#' @param filter_name A \code{\link[base]{character}} string containing the
#' name of the filter. Must be "site", "subsite", "series", or
#' "parameter". See details.
#'
#' @details For a full description of each valid filter_name see
#' ?\code{\link{expose_attributes}}. In the temperature logger dataset,
#' "subsite" is equivalent to "series"; moreover, note that there is only one
#' parameter being measured (i.e. water temperature), so the "parameter" filter
#' contains one single value.
#'
#' @return Either a \code{\link[base]{data.frame}} if
#' \code{filter_name = "series"}, else a \code{\link[base]{character}}
#' vector.
#'
#' @seealso \code{\link{aims_data}}, \code{\link{expose_attributes}}
#'
#' @importFrom httr GET http_error
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' weather_doi <- aims_data_doi("weather")
#' ssts_doi <- aims_data_doi("temp_loggers")
#' filter_values(weather_doi, filter_name = "site")
#' filter_values(weather_doi, filter_name = "subsite")
#' filter_values(weather_doi, filter_name = "series")
#' filter_values(weather_doi, filter_name = "parameter")
#' filter_values(ssts_doi, filter_name = "site")
#' filter_values(ssts_doi, filter_name = "subsite")
#' filter_values(ssts_doi, filter_name = "series") # same as subsite
#' filter_values(ssts_doi, filter_name = "parameter")
#' }
#'
#' @export
filter_values <- function(doi, filter_name, aims_version = NA) {
  if (length(filter_name) != 1) {
    stop("Argument \"filter_name\" should contain one single value")
  }
  if (!filter_name %in% c("site", "subsite", "series", "parameter")) {
    stop("\"filter_name\" must be \"site\", \"subsite\", \"series\", ",
         "or \"parameter\"")
  }
  base_end_pt <- make_base_end_pt(doi, aims_version)
  end_pt <- paste(base_end_pt, doi, filter_name, sep = "/")
  dt_req <- GET(end_pt)
  if (http_error(dt_req)) {
    handle_error(dt_req)
  } else {
    json_results(dt_req)
  }
}
