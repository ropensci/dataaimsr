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
error_handle <- function(dt_req) {
  stop(paste("Error", http_status(dt_req),
                content(dt_req)))
}

#' \code{\link[jsonlite]{fromJSON}} data request
#' 
#' Wrapper function
#' 
#' @inheritParams error_handle
#' 
#' @details This function submits a \code{dt_req} 
#' data request via \code{\link[jsonlite]{fromJSON}}.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \code{metadata}: a \href{https://www.doi.org/}{DOI} link
#' containing the metadata record for the data series; 
#' \code{citation}: the citation information for the particular dataset; 
#' \code{links}: the link from which the data query was retrieved;
#' \code{data}: an output \code{\link[base]{data.frame}}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
json_results  <-  function(dt_req) {
    json_resp <- content(dt_req, "text", encoding = "UTF-8")
    fromJSON(json_resp, simplifyDataFrame = TRUE)
}

#' Format \code{\link{json_results}} output
#' 
#' Wrapper function
#' 
#' @inheritParams error_handle
#' 
#' @param next_page Logical. Is this a multi-url request?
#' 
#' @param ... Additional arguments to be passed to internal function
#' \code{\link{format_update}}
#' 
#' @details This function checks for errors in \code{dt_req} 
#' data request and processes result via 
#' \code{\link{json_results}}.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \code{metadata}: a \href{https://www.doi.org/}{DOI} link
#' containing the metadata record for the data series; 
#' \code{citation}: the citation information for the particular dataset; 
#' \code{links}: the link from which the data query was retrieved;
#' \code{data}: an output \code{\link[base]{data.frame}}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr http_error
request_process <- function(dt_req, next_page = FALSE, ...) {
  if (http_error(dt_req)) {
    error_handle(dt_req)
  } else {
    results <- json_results(dt_req)
    if (next_page && length(results$results) == 0) {
      warning("No more data")
    } else {
      results <- format_update(results, ...)
      if (!next_page) {
        message(paste("Cite this data as:", results$citation))
      }
      results
    }
  }
}

#' Request data via the AIMS Data Platform API
#' 
#' A function that communicates with the 
#' the \href{https://aims.github.io/data-platform}{AIMS Data Platform}
#' via the AIMS Data Platform API
#' 
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen \href{https://aims.github.io/data-platform}{AIMS data series}
#' 
#' @param filters A \code{\link[base]{list}} containing a set of 
#' filters for the data query (see Details)
#' 
#' @param api_key An AIMS Data Platform 
#' \href{https://aims.github.io/data-platform/key-request}{API Key}
#' 
#' @details The AIMS Data Platform R Client provides easy access to 
#' data sets for R applications to the 
#' \href{https://aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this \href{https://aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend 
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY` 
#' permanently under the user's \code{.Renviron} file in order to load
#' the API Key automatically.
#' 
#' There are two types of data currently available through the 
#' [AIMS Data Platform API](https://aims.github.io/data-platform): 
#' [Weather](https://aims.github.io/data-platform/weather/index) and 
#' [Sea Water Temperature Loggers](https://aims.github.io/data-platform/temperature-loggers/index). 
#' They are searched internally via unique DOI identifiers which 
#' can be obtained by e.g. \code{getOption("dataaimsr.weather")} (see Examples).
#' Only one DOI at a time can be passed to the argument \code{doi}.
#' 
#' A list of arguments for \code{filters} can be found for both
#' [Weather](https://aims.github.io/data-platform/weather/index) and 
#' [Sea Water Temperature Loggers](https://aims.github.io/data-platform/weather/index).
#' 
#' Note that currently \code{from-date} and 
#' \code{thru-date} cannot be inspected directly, for details about dates
#' of available different time series can be accessed via Metadata on
#' \href{https://aims.github.io/data-platform}{AIMS Data Platform API}. Despite
#' this limitation, these time boundaries are very important because the 
#' data are collected at very small time intervals, so just a few days of 
#' time interval can yield massive datasets. The query will return and error 
#' if it reaches the system's memory capacity.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \code{metadata}: a \href{https://www.doi.org/}{DOI} link
#' containing the metadata record for the data series; 
#' \code{citation}: the citation information for the particular dataset; 
#' \code{links}: the link from which the data query was retrieved;
#' \code{data}: an output \code{\link[base]{data.frame}}.
#' 
#' @seealso \code{\link{filter_values_get}}, \code{\link{aims_data_get}}
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr GET add_headers
page_data_get <- function(doi, filters = NULL, api_key = NULL) {
  base_end_pt <- getOption("dataaimsr.base_end_point")
  end_pt <- paste(base_end_pt, doi, "data", sep = "/")
  dt_req <- GET(end_pt,
                add_headers("X-Api-Key" = api_key_find(api_key)),
                query = filters)
  request_process(dt_req, doi = doi)
}

#' Further data requests via the AIMS Data Platform API
#' 
#' Similar to \code{\link{page_data_get}}, but for cases
#' where there are multiple URLs for data retrieval
#' 
#' @param url A data retrieval URL
#' 
#' @param api_key An AIMS Data Platform 
#' \href{https://aims.github.io/data-platform/key-request}{API Key}
#' 
#' @param ... Additional arguments to be passed to internal function
#' \code{\link{format_update}}
#' 
#' @details The AIMS Data Platform R Client provides easy access to 
#' data sets for R applications to the 
#' \href{https://aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this \href{https://aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend 
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY` 
#' permanently under the user's \code{.Renviron} file in order to load
#' the API key automatically.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \code{metadata}: a \href{https://www.doi.org/}{DOI} link
#' containing the metadata record for the data series; 
#' \code{citation}: the citation information for the particular dataset; 
#' \code{links}: the link from which the data query was retrieved;
#' \code{data}: an output \code{\link[base]{data.frame}}.
#' 
#' @seealso \code{\link{filter_values_get}}, \code{\link{page_data_get}}, \code{\link{aims_data_get}}
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr GET add_headers
next_page_data_get <- function(url, api_key = NULL, ...) {
  dt_req <- GET(url,
                add_headers("X-Api-Key" = api_key_find(api_key)))
  request_process(dt_req, next_page = TRUE, ...)
}

#' Request data via the AIMS Data Platform API
#' 
#' A function that communicates with the 
#' the \href{https://aims.github.io/data-platform}{AIMS Data Platform}
#' via the AIMS Data Platform API
#' 
#' @param doi A \href{https://www.doi.org/}{Digital Object Identifier}
#' for a chosen \href{https://aims.github.io/data-platform}{AIMS data series}
#' 
#' @param filters A \code{\link[base]{list}} containing a set of 
#' filters for the data query (see Details)
#' 
#' @param ... Additional arguments to be passed to internal functions
#' \code{\link{page_data_get}} and \code{\link{next_page_data_get}}
#' 
#' @details The AIMS Data Platform R Client provides easy access to 
#' data sets for R applications to the 
#' \href{https://aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this \href{https://aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend 
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY` 
#' permanently under the user's \code{.Renviron} file in order to load
#' the API key automatically.
#' 
#' There are two types of data currently available through the 
#' [AIMS Data Platform API](https://aims.github.io/data-platform): 
#' [Weather](https://aims.github.io/data-platform/weather/index) and 
#' [Sea Water Temperature Loggers](https://aims.github.io/data-platform/temperature-loggers/index). 
#' They are searched internally via unique DOI identifiers which 
#' can be obtained by e.g. \code{getOption("dataaimsr.weather")} (see Examples).
#' Only one DOI at a time can be passed to the argument \code{doi}.
#' 
#' A list of arguments for \code{filters} can be found for both
#' [Weather](https://aims.github.io/data-platform/weather/index) and 
#' [Sea Water Temperature Loggers](https://aims.github.io/data-platform/weather/index).
#' 
#' Note that currently \code{from-date} and 
#' \code{thru-date} cannot be inspected directly, for details about dates
#' of available different time series can be accessed via Metadata on
#' \href{https://aims.github.io/data-platform}{AIMS Data Platform API}. Despite
#' this limitation, these time boundaries are very important because the 
#' data are collected at very small time intervals, so just a few days of 
#' time interval can yield massive datasets. The query will return and error 
#' if it reaches the system's memory capacity.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \code{metadata}: a \href{https://www.doi.org/}{DOI} link
#' containing the metadata record for the data series; 
#' \code{citation}: the citation information for the particular dataset; 
#' \code{links}: the link from which the data query was retrieved;
#' \code{data}: an output \code{\link[base]{data.frame}}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' # assumes that user already has API key saved to
#' # .Renviron
#' weather_doi  <-  getOption("dataaimsr.weather")
#' ssts_doi     <-  getOption("dataaimsr.temp_loggers")
#' 
#' # 64 corresponds to air temperature from Davies Reef
#' wdata <- aims_data_get(weather_doi,
#'                        api_key = NULL,
#'                        filters = list("series" = 64,
#'                                       "from-date" = "2018-01-01",
#'                                       "thru-date" = "2018-01-10"))
#'
#' # Downloads Chlorophyll data from all sites between given time interval
#' cdata <- aims_data_get(weather_doi,
#'                        api_key = NULL,
#'                        filters = list("parameters" = "Chlorophyll",
#'                                       "from-date" = "2003-01-01",
#'                                       "thru-date" = "2003-01-02"))
#' 
#' sdata <- aims_data_get(ssts_doi,
#'                        api_key = NULL,
#'                        filters = list("site-name" = "Bickerton Island"))
#' }
#' 
#' @export
aims_data_get <- function(doi, filters = NULL, ...) {
  results <- page_data_get(doi, filters = filters, ...)
  message(results$links)
  next_url <- results$links$next_page
  more_data <- TRUE
  while (more_data) {
    tryCatch({
      next_res <- next_page_data_get(next_url, ..., doi = doi)
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
#' for a chosen \href{https://aims.github.io/data-platform}{AIMS data series}
#' 
#' @param filter_name A \code{\link[base]{character}} vector containing the name of
#' the filter (see Details)
#' 
#' @details A list of arguments for \code{filters} can be found for both
#' [Weather](https://aims.github.io/data-platform/weather/index) and 
#' [Sea Water Temperature Loggers](https://aims.github.io/data-platform/weather/index).
#' 
#' @return Either a \code{\link[base]{data.frame}} or a \code{\link[base]{character}} vector.
#' 
#' @seealso \code{\link{aims_data_get}}
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' weather_doi  <-  getOption("dataaimsr.weather")
#' ssts_doi     <-  getOption("dataaimsr.temp_loggers")
#' filter_values_get(weather_doi, filter_name = "sites")
#' filter_values_get(weather_doi, filter_name = "series")
#' filter_values_get(weather_doi, filter_name = "parameters")
#' filter_values_get(ssts_doi, filter_name = "sites")
#' }
#' 
#' @export
#' @importFrom httr GET http_error
filter_values_get <- function(doi, filter_name) {
  base_end_pt <- getOption("dataaimsr.base_end_point")
  end_pt <- paste(base_end_pt, doi, filter_name, sep = "/")
  dt_req <- GET(end_pt)
  if (http_error(dt_req)) {
    error_handle(dt_req)
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
#' for a chosen \href{https://aims.github.io/data-platform}{AIMS data series}
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} \code{\link[base]{list}} 
#' containing four elements: 
#' \code{metadata}: a \href{https://www.doi.org/}{DOI} link
#' containing the metadata record for the data series; 
#' \code{citation}: the citation information for the particular dataset; 
#' \code{links}: the link from which the data query was retrieved;
#' \code{data}: an output \code{\link[base]{data.frame}}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
format_update <- function(results, doi) {
  if ("links" %in% names(results) &&
      "next" %in% names(results$links)) {
    results$links$next_page <- results$links$"next"
    results$links$"next" <- NULL
  }
  date_format <- getOption("dataaimsr.date_format")[doi]
  results$results$time <- as.POSIXct(strptime(results$results$time,
                                              format = date_format,
                                              tz = "UTC"))
  names(results)[names(results) == "results"] <- "data"
  results
}

#' AIMS API Key retriever
#' 
#' This function tries to search for an API Key
#' 
#' @param api_key An API Key obtained from
#' \href{https://aims.github.io/data-platform/key-request}{AIMS DataPlatform}.
#' 
#' @details The AIMS Data Platform R Client provides easy access to 
#' data sets for R applications to the 
#' \href{https://aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this \href{https://aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend 
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY` 
#' permanently under the user's \code{.Renviron} file in order to load
#' the API Key automatically.
#' 
#' @return Either a \code{\link[base]{character}} vector API Key found
#' in .Renviron or, if missing entirely, an error message.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
api_key_find <- function(api_key) {
  if (is.null(api_key)) {
    r_env_api_key <- Sys.getenv("AIMS_DATAPLATFORM_API_KEY")
    if (is.null(r_env_api_key)) {
      stop("No API Key could be found, please see",
           "https://aims.github.io/data-platform/key-request")
    } else {
      r_env_api_key
    }
  } else {
    api_key
  }
}
