#' Expose available query filters
#' 
#' Expose available query filters which are allowed to be parsed either
#' via argument \code{summary} or \code{filters} in \code{\link{aims_data}}
#' 
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen \href{https://open-aims.github.io/data-platform}{AIMS data series}
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
#' Currently we are working on standardising all filter names
#' across datasets. However, for the moment they might differ depending on
#' whether the user is downloading temperature logger data or weather station
#' data. Below the valid parameter names should be read as
#' temperature-logger / weather-station (NA means that the particular filter
#' name is not available for the dataset.
#' 
#' \itemize{
#'    \item{site/site-name}{Filter by a particular site.}
#'    \item{subsite/NA}{Filter by a particular subsite.}
#'    \item{series/series_name}{Filter by a particular series.}
#'    \item{parameter/parameter}{Parameter of interest. Only used for weather
#'          station data.}
#'    \item{min_lat/min-latitude}{Minimum latitude; used to filter by a lat-lon box.}
#'    \item{max_lat/max-latitude}{Maximum latitude; used to filter by a lat-lon box.}
#'    \item{min_lon/min-longitude}{Minimum longitude; used to filter by a lat-lon box.}
#'    \item{max_lon/max-longitude}{Maximum longitude; used to filter by a lat-lon box.}
#'    \item{from_date/from-date}{Filter from time (string of format YYYY-MM-DD).}
#'    \item{thru_date/thru-date}{Filter until time (string of format YYYY-MM-DD).}
#' }
#' 
#' Some additional options for the actual download, which should be passed as additional
#' arguments to the function,  are:
#' \itemize{
#'    \item{size}{Set a page size for large queries
#'          (only for the `data` and `data-no-key` endpoints).}
#'    \item{cursor}{Used for pagination on / data").}
#'    \item{version}{Request the data as recorded at a particular time
#'          (a version history).}
#' }
#' 
#' @return A \code{\link[base]{list}} of a \code{\link[base]{character}} vector
#' each: one detailing summary modes, another detailing filters.
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
#' @export
expose_attributes <- function(doi) {
  w_doi <- aims_data_doi("weather")
  tl_doi <- aims_data_doi("temp_loggers")
  if (doi == tl_doi) {
    list(summary = c("summary-by-series", "summary-by-deployment"),
         filters = c("site", "subsite", "series", "size", "parameter",
                     "min_lat", "max_lat", "min_lon", "max_lon",
                     "from_date", "thru_date", "version", "cursor"))
  } else if (doi == w_doi) {
    list(summary = NA,
         filters = c("site-name", "series", "size", "parameter",
                     "min-latitude", "max-latitude", "min-longitude",
                     "max-longitude", "from-date", "thru-date",
                     "version", "cursor"))
  }
}

#' \code{\link[httr]{GET}} error handler
#' 
#' Displays error status
#' 
#' @param dt_req An URL \code{\link[httr]{GET}} output
#' 
#' @details This function retrieves the 
#' status and content of \code{dt_req} via the 
#' \pkg{httr} package.
#' 
#' @return A \code{\link[base]{character}} vector conveying the error message.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr http_status content
handle_error <- function(dt_req) {
  stop(paste("Error", http_status(dt_req),
                content(dt_req)))
}

#' \code{\link[jsonlite]{fromJSON}} data request
#' 
#' Wrapper function
#' 
#' @inheritParams handle_error
#' 
#' @details This function submits a \code{dt_req} 
#' data request via \code{\link[jsonlite]{fromJSON}}.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \itemize{
#'    \item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
#'          containing the metadata record for the data series.}
#'    \item{\code{citation}}{the citation information for the particular
#'          dataset.}
#'    \item{\code{links}}{the link from which the data query was retrieved.}
#'    \item{\code{data}}{an output \code{\link[base]{data.frame}}.}
#' }
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
json_results <- function(dt_req) {
    json_resp <- content(dt_req, "text", encoding = "UTF-8")
    fromJSON(json_resp, simplifyDataFrame = TRUE)
}

#' Format \code{\link{json_results}} output
#' 
#' Wrapper function
#' 
#' @inheritParams handle_error
#' 
#' @param next_page Logical. Is this a multi-url request?
#' 
#' @param ... Additional arguments to be passed to internal function
#' \code{\link{update_format}}
#' 
#' @details This function checks for errors in \code{dt_req} 
#' data request and processes result via 
#' \code{\link{json_results}}.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \itemize{
#'    \item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
#'          containing the metadata record for the data series.}
#'    \item{\code{citation}}{the citation information for the particular
#'          dataset.}
#'    \item{\code{links}}{the link from which the data query was retrieved.}
#'    \item{\code{data}}{an output \code{\link[base]{data.frame}}.}
#' }
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr http_error
process_request <- function(dt_req, next_page = FALSE, ...) {
  if (http_error(dt_req)) {
    handle_error(dt_req)
  } else {
    results <- json_results(dt_req)
    if (next_page && length(results$results) == 0) {
      warning("No more data")
    } else {
      results <- update_format(results, ...)
      if (!next_page) {
        message(paste("Cite this data as:", results$citation))
      }
      results
    }
  }
}

#' Expose available query filters
#' 
#' Expose available query filters which are allowed to be parsed either
#' via argument \code{summary} or \code{filters} in \code{\link{aims_data}}
#' 
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen \href{https://open-aims.github.io/data-platform}{AIMS data series}
#' @param aims_version A \code{\link[base]{character}} string
#' defining the version of database. Must be "/v1.0" or "-v2.0".
#' If none is provided, then "-v2.0" (the most recent) is used.
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
make_base_end_pt <- function(doi, aims_version = NA) {
  base_end_pt <- getOption("dataaimsr.base_end_point")
  if (is.na(aims_version)) {
    aims_version <- getOption("dataaimsr.version")[doi]
  }
  if (is.na(aims_version)) {
    aims_version <- "/v1.0"
  }
  paste0(base_end_pt, aims_version)
}

#' Request data via the AIMS Data Platform API
#' 
#' A function that communicates with the 
#' the \href{https://open-aims.github.io/data-platform}{AIMS Data Platform}
#' via the AIMS Data Platform API
#' 
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen \href{https://open-aims.github.io/data-platform}{AIMS data series}
#' 
#' @param filters A \code{\link[base]{list}} containing a set of 
#' filters for the data query (see Details)
#' 
#' @param api_key An AIMS Data Platform 
#' \href{https://open-aims.github.io/data-platform/key-request}{API Key}
#' 
#' @param verbose Should links be printed to screen? Used for debugging only
#' 
#' @details The AIMS Data Platform R Client provides easy access to 
#' data sets for R applications to the 
#' \href{https://open-aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this \href{https://open-aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend 
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY` 
#' permanently under the user's \code{.Renviron} file in order to load
#' the API Key automatically.
#' 
#' There are two types of data currently available through the 
#' [AIMS Data Platform API](https://open-aims.github.io/data-platform): 
#' [Weather](https://weather.aims.gov.au/#/overview) and 
#' [Sea Water Temperature Loggers](https://apps.aims.gov.au/metadata/view/4a12a8c0-c573-11dc-b99b-00008a07204e). 
#' They are searched internally via unique DOI identifiers which 
#' can be obtained by the function \code{\link{aims_data_doi}} (see Examples).
#' Only one DOI at a time can be passed to the argument \code{doi}.
#' 
#' A list of arguments for \code{filters} can be exposed for both
#' [Weather](https://weather.aims.gov.au/#/overview) and 
#' [Sea Water Temperature Loggers](https://weather.aims.gov.au/#/overview)
#' using function \code{\link{expose_attributes}}.
#' 
#' Note that at present the user can inspect the range of dates for
#' the temperature loggers data only (see usage of argument \code{summary} in
#' \code{\link{aims_data}}). Details about available dates for each dataset
#' and time series can be accessed via Metadata on
#' \href{https://open-aims.github.io/data-platform}{AIMS Data Platform API}.
#' We raise this caveat here because these time boundaries are very important;
#' data are collected at very small time intervals, so just a few days of 
#' time interval can yield massive datasets. The query will return and error 
#' if it reaches the system's memory capacity.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \itemize{
#'    \item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
#'          containing the metadata record for the data series.}
#'    \item{\code{citation}}{the citation information for the particular
#'          dataset.}
#'    \item{\code{links}}{the link from which the data query was retrieved.}
#'    \item{\code{data}}{an output \code{\link[base]{data.frame}}.}
#' }
#' 
#' @seealso \code{\link{expose_attributes}}, \code{\link{filter_values}}, \code{\link{aims_data}}
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
  }
  if (is.null(filters[["size"]])) {
    filters[["size"]] <- 1000
  }
  dt_req <- GET(end_pt,
                add_headers("X-Api-Key" = find_api_key(api_key)),
                query = filters)
  if (verbose) {
    message(end_pt)
    message(dt_req)
  }
  process_request(dt_req, doi = doi)
}

#' Further data requests via the AIMS Data Platform API
#' 
#' Similar to \code{\link{page_data}}, but for cases
#' where there are multiple URLs for data retrieval
#' 
#' @param url A data retrieval URL
#' 
#' @param api_key An AIMS Data Platform 
#' \href{https://open-aims.github.io/data-platform/key-request}{API Key}
#' 
#' @param ... Additional arguments to be passed to internal function
#' \code{\link{update_format}}
#' 
#' @details The AIMS Data Platform R Client provides easy access to 
#' data sets for R applications to the 
#' \href{https://open-aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this \href{https://open-aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend 
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY` 
#' permanently under the user's \code{.Renviron} file in order to load
#' the API key automatically.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \itemize{
#'    \item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
#'          containing the metadata record for the data series.}
#'    \item{\code{citation}}{the citation information for the particular
#'          dataset.}
#'    \item{\code{links}}{the link from which the data query was retrieved.}
#'    \item{\code{data}}{an output \code{\link[base]{data.frame}}.}
#' }
#' 
#' @seealso \code{\link{filter_values}}, \code{\link{page_data}}, \code{\link{aims_data}}
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr GET add_headers
next_page_data <- function(url, api_key = NULL, ...) {
  url <- gsub("+", "%2B", URLencode(url), fixed = TRUE)
  dt_req <- GET(url,
                add_headers("X-Api-Key" = find_api_key(api_key)))
  process_request(dt_req, next_page = TRUE, ...)
}

#' Request data via the AIMS Data Platform API
#' 
#' A function that communicates with the 
#' the \href{https://open-aims.github.io/data-platform}{AIMS Data Platform}
#' via the AIMS Data Platform API
#' 
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen \href{https://open-aims.github.io/data-platform}{AIMS data series}
#' 
#' @param filters A \code{\link[base]{list}} containing a set of 
#' filters for the data query (see Details)
#' 
#' @param ... Additional arguments to be passed to internal functions
#' \code{\link{page_data}} and \code{\link{next_page_data}}
#' 
#' @details The AIMS Data Platform R Client provides easy access to 
#' data sets for R applications to the 
#' \href{https://open-aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this \href{https://open-aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend 
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY` 
#' permanently under the user's \code{.Renviron} file in order to load
#' the API Key automatically.
#' 
#' There are two types of data currently available through the 
#' [AIMS Data Platform API](https://open-aims.github.io/data-platform): 
#' [Weather](https://weather.aims.gov.au/#/overview) and 
#' [Sea Water Temperature Loggers](https://apps.aims.gov.au/metadata/view/4a12a8c0-c573-11dc-b99b-00008a07204e). 
#' They are searched internally via unique DOI identifiers which 
#' can be obtained by the function \code{\link{aims_data_doi}} (see Examples).
#' Only one DOI at a time can be passed to the argument \code{doi}.
#' 
#' A list of arguments for \code{filters} can be exposed for both
#' [Weather](https://weather.aims.gov.au/#/overview) and 
#' [Sea Water Temperature Loggers](https://weather.aims.gov.au/#/overview)
#' using function \code{\link{expose_attributes}}.
#' 
#' Note that at present the user can inspect the range of dates for
#' the temperature loggers data only (see usage of argument \code{summary} in
#' \code{\link{aims_data}}). Details about available dates for each dataset
#' and time series can be accessed via Metadata on
#' \href{https://open-aims.github.io/data-platform}{AIMS Data Platform API}.
#' We raise this caveat here because these time boundaries are very important;
#' data are collected at very small time intervals, so just a few days of 
#' time interval can yield massive datasets. The query will return and error 
#' if it reaches the system's memory capacity.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \itemize{
#'    \item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
#'          containing the metadata record for the data series.}
#'    \item{\code{citation}}{the citation information for the particular
#'          dataset.}
#'    \item{\code{links}}{the link from which the data query was retrieved.}
#'    \item{\code{data}}{an output \code{\link[base]{data.frame}}.}
#' }
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' # assumes that user already has API key saved to
#' # .Renviron
#' 
#' # first we retrieve the correct DOI
#' # for each dataset
#' weather_doi <- aims_data_doi("weather")
#' ssts_doi <- aims_data_doi("temp_loggers")
#' 
#' # first notice that most filter names
#' # are not the same across datasets
#' # to discover what is allowed
#' expose_attributes(weather_doi)
#' 
#' # start downloads:
#' # 1. downloads weather data from
#' # site Yongala
#' # within a defined date range
#' wdata_a <- aims_data(weather_doi,
#'                      api_key = NULL,
#'                      filters = list("site-name" = "Yongala",
#'                                     "from-date" = "2018-01-01",
#'                                     "thru-date" = "2018-01-02"))$data
#' 
#' # 2. downloads weather data from all sites
#' # under series 64 from Davies Reef
#' # within a defined date range
#' # ignores summary argument
#' wdata_b <- aims_data(weather_doi,
#'                      api_key = NULL,
#'                      summary = "summary-by-series",
#'                      filters = list("series" = 64,
#'                                     "from-date" = "1991-10-18",
#'                                     "thru-date" = "1991-10-19"))$data
#' head(wdata_b)
#' range(wdata_b$time)
#' 
#' # 3. downloads weather data from all sites
#' # under series 64 from Davies Reef
#' # within defined date AND time range
#' wdata_c <- aims_data(weather_doi,
#'                      api_key = NULL,
#'                      filters = list("series" = 64,
#'                                     "from-date" = "1991-10-18T06:00:00",
#'                                     "thru-date" = "1991-10-18T12:00:00"))$data
#' 
#' # 4. downloads all parameters from all sites
#' # within a defined date range
#' cdata_a <- aims_data(weather_doi,
#'                      api_key = NULL,
#'                      filters = list("from-date" = "2003-01-01",
#'                                     "thru-date" = "2003-01-02"))$data
#' # note that there are multiple sites and series
#' # so in this case, because we did not specify a specific
#' # parameter, series within sites could differ by both
#' # parameter and depth
#' head(cdata_a)
#' unique(cdata_a[, c("site_name", "series_id", "series_name")])
#' unique(cdata_a$parameter)
#' range(cdata_a$time)
#' 
#' # 5. downloads chlorophyll from all sites
#' # within a defined date range
#' cdata_b <- aims_data(weather_doi,
#'                      api_key = NULL,
#'                      filters = list("parameter" = "Chlorophyll",
#'                                     "from-date" = "2018-01-01",
#'                                     "thru-date" = "2018-01-02"))$data
#' # note again that there are multiple sites and series
#' # however in this case because we did specify a specific
#' # parameter, series within sites differ by depth only
#' head(cdata_b)
#' unique(cdata_b[, c("site_name", "series_id", "series_name", "depth")])
#' unique(cdata_b$parameter)
#' range(cdata_b$time)
#' 
#' # 6. downloads summarised temperature data
#' # for all sites
#' # within a defined date range
#' sdata <- aims_data(ssts_doi,
#'                    api_key = NULL,
#'                    summary = "summary-by-series",
#'                    filters = list("from_date" = "2018-01-01",
#'                                   "thru_date" = "2018-12-31"))$data
#' head(sdata)
#' unique(sdata$site)
#' min(sdata$from_date)
#' max(sdata$thru_date)
#' }
#' 
#' @export
aims_data <- function(doi, filters = NULL, ...) {
  w_doi <- aims_data_doi("weather")
  allowed <- expose_attributes(doi)
  add_args <- list(...)
  if ("summary" %in% names(add_args)) {
    if (doi == w_doi) {
      message("Argument \"summary\" is currently only available",
              " for the temperature logger (\"temp_loggers\") dataset.\n",
              " Ignoring \"summary\" entry. See details in ?expose_attributes")
      add_args$summary <- NA
    }
    if (!all(add_args$summary %in% allowed$summary)) {
      wrong_s <- setdiff(add_args$summary, allowed$summary)
      stop("summary string \"", paste(wrong_s, sep = "; "),
           "\" not allowed; please check ?expose_attributes")
    }
  }
  if (!is.null(filters)) {
    if (!all(names(filters) %in% allowed$filters)) {
      wrong_f <- setdiff(names(filters), allowed$filters)
      stop("filter string \"", paste(wrong_f, sep = "; "),
           "\" not allowed; please check ?expose_attributes")
    }
  }
  all_args <- c(doi = doi, filters = list(filters), add_args)
  results <- do.call(page_data, all_args)
  message(results$links)
  next_url <- results$links$next_page
  more_data <- TRUE
  while (more_data) {
    tryCatch({
      next_res <- next_page_data(next_url, ..., doi = doi)
      results$data <- rbind(results$data, next_res$data)
      if ("links" %in% names(next_res) &&
          "next_page" %in% names(next_res$links)) {
        message(next_res$links)
        next_url <- next_res$links$next_page
      } else {
        more_data <- FALSE
      }
    }, warning = function(war) {
      more_data <<- FALSE
    }, error = function(err) {
      more_data <<- FALSE
    })
    message(paste("Result count:",
                  nrow(results$data)))
  }
  results
}

#' Retrieve existing list of data attributes
#' 
#' This is a utility function which allows to user
#' to query about the existing possibilities of 
#' a given filter name
#' 
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen \href{https://open-aims.github.io/data-platform}{AIMS data series}
#' 
#' @param filter_name A \code{\link[base]{character}} string containing the name of
#' the filter. Must be "sites" or "series". It could also be "parameters" for the
#' weather data (i.e. doi = aims_data_doi("weather")).
#' 
#' @return Either a \code{\link[base]{data.frame}} or a \code{\link[base]{character}} vector.
#' 
#' @seealso \code{\link{aims_data}}
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' weather_doi <- aims_data_doi("weather")
#' ssts_doi <- aims_data_doi("temp_loggers")
#' filter_values(weather_doi, filter_name = "sites")
#' filter_values(weather_doi, filter_name = "series")
#' filter_values(weather_doi, filter_name = "parameters")
#' filter_values(ssts_doi, filter_name = "sites")
#' filter_values(ssts_doi, filter_name = "series")
#' }
#'
#' @export
#' @importFrom httr GET http_error
filter_values <- function(doi, filter_name, aims_version = NA) {
  if (length(filter_name) > 1) {
    stop("Argument \"filter_name\" should contain one single value")
  }
  sdoi <- aims_data_doi("temp_loggers")
  if (!filter_name %in% c("sites", "series", "parameters")) {
    stop("\"filter_name\" must be \"sites\", \"series\"or ",
         " \"parameters\"")
  }
  if (doi == sdoi & filter_name == "parameters") {
    stop("\"filter_name\" = \"parameters\" only works for weather station doi")
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

#' Format \code{\link[jsonlite]{fromJSON}} output list
#' 
#' When \code{\link[jsonlite]{fromJSON}} returns a list, 
#' format list names
#' 
#' @param results A \code{\link[jsonlite]{fromJSON}} list
#' generated by \code{\link{json_results}}.
#' 
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen \href{https://open-aims.github.io/data-platform}{AIMS data series}
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \itemize{
#'    \item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
#'          containing the metadata record for the data series.}
#'    \item{\code{citation}}{the citation information for the particular
#'          dataset.}
#'    \item{\code{links}}{the link from which the data query was retrieved.}
#'    \item{\code{data}}{an output \code{\link[base]{data.frame}}.}
#' }
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' @importFrom parsedate parse_iso_8601
update_format <- function(results, doi) {
  if ("links" %in% names(results) &&
      "next" %in% names(results$links)) {
    results$links$next_page <- results$links$"next"
    results$links$"next" <- NULL
  }
  if ("time" %in% colnames(results$results)) {
    results$results$time <- parse_iso_8601(results$results$time)
  }
  names(results)[names(results) == "results"] <- "data"
  results
}

#' AIMS API Key retriever
#' 
#' This function tries to search for an API Key
#' 
#' @param api_key An API Key obtained from
#' \href{https://open-aims.github.io/data-platform/key-request}{AIMS DataPlatform}.
#' 
#' @details The AIMS Data Platform R Client provides easy access to 
#' data sets for R applications to the 
#' \href{https://open-aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this \href{https://open-aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend 
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY` 
#' permanently under the user's \code{.Renviron} file in order to load
#' the API Key automatically.
#' 
#' @return Either a \code{\link[base]{character}} vector API Key found
#' in .Renviron or, if missing entirely, an error message.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
find_api_key <- function(api_key) {
  if (is.null(api_key)) {
    r_env_api_key <- Sys.getenv("AIMS_DATAPLATFORM_API_KEY")
    if (is.null(r_env_api_key)) {
      stop("No API Key could be found, please see",
           "https://open-aims.github.io/data-platform/key-request")
    } else {
      r_env_api_key
    }
  } else {
    api_key
  }
}

#' AIMS Dataset DOI retriever
#' 
#' Returns DOI for a given dataset
#' 
#' @param target A \code{\link[base]{character}} vector of length 1 
#' specifying the dataset. Only \code{weather} or 
#' \code{temp_loggers} are currently allowed.
#' 
#' @return A \code{\link[base]{character}} vector 
#' containing the dataset DOI string.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' weather_doi <- aims_data_doi('weather')
#' ssts_doi <- aims_data_doi('temp_loggers')
#' }
#' 
#' @export
aims_data_doi <- function(target) {
  if (!(target %in% c("weather", "temp_loggers"))) {
    stop("Wrong type of data target, only \"weather\"",
         "or \"temp_loggers\" are allowed")
  }
  getOption(paste0("dataaimsr.", target))
}
