#' Request data via the AIMS Data Platform API
#'
#' A function that communicates with the
#' the \href{https://open-aims.github.io/data-platform/}{AIMS Data Platform}
#' via the AIMS Data Platform API
#'
#' @inheritParams aims_data
#'
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen
#' \href{https://open-aims.github.io/data-platform/}{AIMS data series}
#' @param api_key An AIMS Data Platform
#' \href{https://open-aims.github.io/data-platform/key-request}{API Key}
#' @param summary Should summary tables (\code{"summary-by-series"} or
#' \code{"summary-by-deployment"}) or daily aggregated data ("daily") be
#' returned instead of full data (see Details)?
#' @param aims_version A \code{\link[base]{character}} string
#' defining the version of database. Must be "/v1.0" or "-v2.0".
#' If none is provided, then "-v2.0" (the most recent) is used.
#' @param verbose Should links be printed to screen? Used for debugging only
#'
#' @inherit aims_data details return
#'
#' @seealso \code{\link{aims_expose_attributes}},
#' \code{\link{aims_filter_values}}, \code{\link{aims_data}}
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @importFrom httr GET add_headers
page_data <- function(doi, filters = NULL, api_key = NULL,
                      summary = NA, aims_version = NA, verbose = FALSE) {
  base_end_pt <- make_base_end_pt(doi, aims_version)
  end_pt <- paste(base_end_pt, doi, "data", sep = "/")
  if (!is.na(summary)) {
    end_pt <- paste(end_pt, summary, sep = "/")
  } else {
    # for now, this block is only triggered if summary is not queried
    # because it is causing conflict with the summary-type endpoint
    # behaviour; should be removed once API is fixed.
    if (is.null(filters[["size"]])) {
      filters[["size"]] <- 1000
    }
  }
  dt_req <- GET(end_pt,
                add_headers("X-Api-Key" = find_api_key(api_key),
                            "X-Query-Source" = "dataaimsr"),
                query = filters)
  if (verbose) {
    message(end_pt)
    message(dt_req)
  }
  process_request(dt_req, doi = doi)
}

#' Further data requests via the AIMS Data Platform API
#'
#' Similar to \code{\link{page_data}}, but for cases #' where there are
#' multiple URLs for data retrieval
#'
#' @inheritParams page_data
#'
#' @param url A data retrieval URL
#' @param ... Additional arguments to be passed to internal function
#' \code{\link{update_format}}
#'
#' @inherit aims_data details return
#'
#' @seealso \code{\link{aims_filter_values}}, \code{\link{page_data}},
#' \code{\link{aims_data}}
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @importFrom httr GET add_headers
#' @importFrom utils URLencode
next_page_data <- function(url, api_key = NULL, ...) {
  url <- gsub("+", "%2B", URLencode(url), fixed = TRUE)
  dt_req <- GET(url,
                add_headers("X-Api-Key" = find_api_key(api_key),
                            "X-Query-Source" = "dataaimsr")
                )  # query filters not required because url passed in will already include them
  process_request(dt_req, next_page = TRUE, ...)
}
