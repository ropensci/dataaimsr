#' Retrieve vector of existing filter values
#'
#' This is a utility function which allows to user
#' to query about the existing possibilities of
#' a given filter name
#'
#' @inheritParams aims_data
#'
#' @param filter_name A \code{\link[base]{character}} string containing the
#' name of the filter. Must be "site", "subsite", "series", or
#' "parameter". See details.
#'
#' @details For a full description of each valid filter_name see
#' ?\code{\link{aims_expose_attributes}}. In the temperature logger dataset,
#' "subsite" is equivalent to "series"; moreover, note that there is only one
#' parameter being measured (i.e. water temperature), so the "parameter" filter
#' contains one single value.
#'
#' @return Either a \code{\link[base]{data.frame}} if
#' \code{filter_name = "series"}, else a \code{\link[base]{character}}
#' vector.
#'
#' @seealso \code{\link{aims_data}}, \code{\link{aims_expose_attributes}}
#'
#' @importFrom httr GET http_error
#' @importFrom curl has_internet
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' aims_filter_values("weather", filter_name = "site")
#' aims_filter_values("temp_loggers", filter_name = "subsite")
#' }
#'
#' @export
aims_filter_values <- function(target, filter_name) {
  if (!has_internet()) {
    message("It seems that your internet connection is down. You need an ",
            "internet connection to successfully download AIMS data.")
    return(invisible())
  }
  doi <- data_doi(target)
  if (length(filter_name) != 1) {
    stop("Argument \"filter_name\" should contain one single value")
  }
  if (!filter_name %in% c("site", "subsite", "series", "parameter")) {
    stop("\"filter_name\" must be \"site\", \"subsite\", \"series\", ",
         "or \"parameter\"")
  }
  base_end_pt <- make_base_end_pt(doi)
  end_pt <- paste(base_end_pt, doi, filter_name, sep = "/")
  dt_req <- GET(end_pt)
  if (http_error(dt_req)) {
    handle_error(dt_req)
  } else {
    json_results(dt_req)
  }
}
