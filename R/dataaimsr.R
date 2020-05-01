#' Title here
#' 
#' General description here
#' 
#' @param dt_req Description of parameter
#' 
#' @details Details about this function.
#' 
#' @return A warning message which retrieves the \pkg{httr}
#'   status and content from \code{dt_req}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr http_status content
request_warning <- function(dt_req) {
  warning(paste("Error", http_status(dt_req),
                content(dt_req)))
}

#' Title here
#' 
#' General description here
#' 
#' @inheritParams request_warning
#' 
#' @details Details about this function.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} simplified \code{data.frame}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
json_results  <-  function(dt_req) {
    json_resp <- content(dt_req, "text", encoding = "UTF-8")
    fromJSON(json_resp, simplifyDataFrame = TRUE)
}

#' Title here
#' 
#' General description here
#' 
#' @inheritParams request_warning
#' 
#' @param next_page Description of parameter
#' 
#' @details Details about this function.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} simplified \code{data.frame}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr http_error
request_process <- function(dt_req, next_page = FALSE) {
  if (http_error(dt_req)) {
    request_warning(dt_req)
  } else {
    results <- json_results(dt_req)
    if (next_page && nrow(results$results) == 0) {
      warning("No more data")
    } else {
      results <- format_update(results)
      if (!next_page) {
        print(paste("Cite this data as:", results$citation))
      }
      results
    }
  }
}

#' Get some data and return a data frame
#' 
#' General description here
#' 
#' @param doi Description of parameter
#' 
#' @param filters Description of parameter
#' 
#' @param api_key Description of parameter
#' 
#' @details Details about this function.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} simplified \code{data.frame}.
#' 
#' @seealso \code{\link{aims_data_get}}
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
  request_process(dt_req)
}

#' Get some data and return a data frame
#' 
#' General description here
#' 
#' @param url Description of parameter
#' 
#' @param api_key Description of parameter
#' 
#' @details Details about this function.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} simplified \code{data.frame}.
#' 
#' @seealso \code{\link{aims_data_get}}
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @importFrom httr parse_url GET add_headers
next_page_data_get <- function(url, api_key = NULL) {
  parsed_url <- parse_url(url)
  # Unfortunately need to remove plus sign if not decoded properly
  parsed_url$query$cursor <- gsub("\\+", " ", parsed_url$query$cursor)
  dt_req <- GET(parsed_url,
                add_headers("X-Api-Key" = api_key_find(api_key)))
  request_process(dt_req, next_page = TRUE)
}

#' Get some data and return a data frame
#' 
#' General description here
#' 
#' @param doi Description of parameter
#' 
#' @param filters Description of parameter
#' 
#' @param ... Additional arguments to be passed to internal functions
#' \code{\link{page_data_get}} and \code{\link{next_page_data_get}}
#' 
#' @details Details about this function.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} simplified \code{data.frame}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' # assumes that user already has API key saved to
#' # .Renviron
#' weather  <-  getOption("dataaimsr.weather")
#' results <- aims_data_get(weather,
#'                     api_key = NULL,
#'                     filters = list('series' = 64,
#'                                    'from-date' = '2018-01-01',
#'                                    'thru-date' = '2018-01-10'))
#' }
#' 
#' @export
aims_data_get <- function(doi, filters = NULL, ...) {
  results <- page_data_get(doi, filters = filters, ...)
  next_url <- results$links$next_page
  more_data <- TRUE
  while (more_data) {
    tryCatch({
      next_res <- next_page_data_get(next_url, ...)
      new_df <- rbind(results$data, next_res$data)
      results$data <- new_df
      if ("links" %in% names(next_res) &&
          "next_page" %in% names(next_res$links)) {
        next_url <- next_res$links$next_page
      } else {
        more_data <- FALSE
      }
    }, warning = function() {
      more_data <<- FALSE
    }, error = function() {
      more_data <<- FALSE
    })
    print(paste("Result count:", nrow(results$data)))
  }
  results
}

#' Retrieve existing list of data attributes
#' 
#' General description here
#' 
#' @param doi Description of parameter
#' 
#' @param filter_name Description of parameter
#' 
#' @details Details about this function.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} simplified \code{data.frame}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#' 
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' weather  <-  getOption("dataaimsr.weather")
#' filter_values_get(weather, filter_name = "series")
#' }
#' 
#' @export
#' @importFrom httr GET http_error
filter_values_get <- function(doi, filter_name) {
  base_end_pt <- getOption("dataaimsr.base_end_point")
  end_pt <- paste(base_end_pt, doi, filter_name, sep = "/")
  dt_req <- GET(end_pt)
  if (http_error(dt_req)) {
    request_warning(dt_req)
  } else {
    json_results(dt_req)
  }
}

#' Title here
#' 
#' General description here
#' 
#' @param results A \code{\link[jsonlite]{fromJSON}} simplified
#' \code{data.frame} generated from internal function
#' \code{\link{json_results}}.
#' 
#' @details Details about this function.
#' 
#' @return A \code{\link[jsonlite]{fromJSON}} simplified \code{data.frame}.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
format_update <- function(results) {
  if ("links" %in% names(results) &&
      "next" %in% names(results$links)) {
    results$links$next_page <- results$links$"next"
    results$links$"next" <- NULL
  }
  date_format <- getOption("dataaimsr.date_format")
  results$results$time <- as.POSIXct(strptime(results$results$time,
                                              format = date_format,
                                              tz = "UTC"))
  names(results)[names(results) == "results"] <- "data"
  results
}

#' Title here
#' 
#' General description here
#' 
#' @param api_key An API key obtained from
#' \href{https://aims.github.io/data-platform/key-request}{AIMS DataPlatform}.
#' 
#' @details Details about this function.
#' 
#' @return Either a \code{character} vector API key found
#' in .Renviron or, if missing entirely, a \code{warning} message.
#' 
#' @author AIMS Datacentre \email{adc@aims.gov.au}
api_key_find <- function(api_key) {
  if (is.null(api_key)) {
    r_env_api_key <- Sys.getenv("AIMS_DATAPLATFORM_API_KEY")
    if (is.null(r_env_api_key)) {
      warning("No API Key could be found, please see",
              "https://aims.github.io/data-platform/key-request")
    } else {
      r_env_api_key
    }
  } else {
    api_key
  }
}
