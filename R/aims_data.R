#' Request data via the AIMS Data Platform API
#'
#' A function that communicates with the
#' the \href{https://open-aims.github.io/data-platform}{AIMS Data Platform}
#' via the AIMS Data Platform API
#'
#' @param target A \code{\link[base]{character}} vector of length 1 specifying
#' the dataset. Only \code{weather} or \code{temp_loggers} are currently
#' allowed.
#' @param filters A \code{\link[base]{list}} containing a set of
#' filters for the data query (see Details)
#' @param ... Additional arguments to be passed to non-exported internal
#' functions \code{\link{page_data}} and \code{\link{next_page_data}}
#'
#' @details The AIMS Data Platform R Client provides easy access to
#' data sets for R applications to the
#' \href{https://open-aims.github.io/data-platform}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this
#' \href{https://open-aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY`
#' permanently under the user's \code{.Renviron} file in order to load
#' the API Key automatically.
#'
#' There are two types of data currently available through the
#' [AIMS Data Platform API](https://open-aims.github.io/data-platform):
#' [Weather](https://weather.aims.gov.au/#/overview) and
#' [Sea Water Temperature Loggers](https://tinyurl.com/h93mcojk).
#' They are searched internally via unique DOI identifiers.
#' Only one data type at a time can be passed to the argument \code{target}.
#'
#' A list of arguments for \code{filters} can be exposed for both
#' [Weather](https://weather.aims.gov.au/#/overview) and
#' [Sea Water Temperature Loggers](https://weather.aims.gov.au/#/overview)
#' using function \code{\link{aims_expose_attributes}}.
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
#' @return If \code{summary} is passed as an additional argument (see code
#' example below), \code{aims_data} returns a \code{\link[base]{data.frame}}
#' containing the summary information for the dataset (NB: currently,
#' \code{summary} only works for the temperature logger dataset).
#'
#' Otherwise, if actual data is downloaded, a \code{\link[jsonlite]{fromJSON}}
#' \code{\link[base]{list}} containing three elements:
#' \itemize{
#'    \item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
#'          containing the metadata record for the data series.}
#'    \item{\code{citation}}{the citation information for the particular
#'          dataset.}
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
#' # start downloads:
#' # 1. downloads weather data from
#' # site Yongala
#' # within a defined date range
#' wdf_a <- aims_data("weather", api_key = NULL,
#'                    filters = list(site = "Yongala",
#'                                   from_date = "2018-01-01",
#'                                   thru_date = "2018-01-02"))$data
#'
#' # 2. downloads weather data from all sites
#' # under series_id 64 from Davies Reef
#' # within a defined date range
#' wdf_b <- aims_data("weather", api_key = NULL,
#'                    filters = list(series_id = 64,
#'                                   from_date = "1991-10-18",
#'                                   thru_date = "1991-10-19"))$data
#' head(wdf_b)
#' range(wdf_b$time)
#'
#' # 3. downloads weather data from all sites
#' # under series_id 64 from Davies Reef
#' # within defined date AND time range
#' wdf_c <- aims_data("weather", api_key = NULL,
#'                    filters = list(series_id = 64,
#'                                   from_date = "1991-10-18T06:00:00",
#'                                   thru_date = "1991-10-18T12:00:00"))$data
#' head(wdf_c)
#' range(wdf_c$time)
#'
#' # 4. downloads all parameters from all sites
#' # within a defined date range
#' wdf_d <- aims_data("weather", api_key = NULL,
#'                    filters = list(from_date = "2003-01-01",
#'                                   thru_date = "2003-01-02"))$data
#' # note that there are multiple sites and series
#' # so in this case, because we did not specify a specific
#' # parameter, series within sites could differ by both
#' # parameter and depth
#' head(wdf_d)
#' unique(wdf_d[, c("site", "series_id", "series")])
#' unique(wdf_d$parameter)
#' range(wdf_d$time)
#'
#' # 5. downloads chlorophyll from all sites
#' # within a defined date range
#' wdf_e <- aims_data("weather", api_key = NULL,
#'                    filters = list(parameter = "Chlorophyll",
#'                                   from_date = "2018-01-01",
#'                                   thru_date = "2018-01-02"))$data
#' # note again that there are multiple sites and series
#' # however in this case because we did specify a specific
#' # parameter, series within sites differ by depth only
#' head(wdf_e)
#' unique(wdf_e[, c("site", "series_id", "series", "depth")])
#' unique(wdf_e$parameter)
#' range(wdf_e$time)
#'
#' # 6. downloads temperature data
#' # summarised by series
#' sdf_a <- aims_data("temp_loggers", api_key = NULL,
#'                    summary = "summary-by-series")
#' head(sdf_a)
#' dim(sdf_a)
#'
#' # 7. downloads temperature data
#' # summarised by series
#' # for all sites that contain data
#' # within a defined date range
#' sdf_b <- aims_data("temp_loggers", api_key = NULL,
#'                    summary = "summary-by-series",
#'                    filters = list("from_date" = "2018-01-01",
#'                                   "thru_date" = "2018-12-31"))
#' head(sdf_b)
#' dim(sdf_b) # a subset of sdf_a
#'
#' # 8. downloads temperature data
#' # summarised by deployment
#' sdf_c <- aims_data("temp_loggers", api_key = NULL,
#'                    summary = "summary-by-deployment")
#' head(sdf_c)
#' dim(sdf_c)
#' }
#'
#' @export
aims_data <- function(target, filters = NULL, ...) {
  doi <- data_doi(target = target)
  w_doi <- data_doi(target = "weather")
  allowed <- aims_expose_attributes(target = target)
  add_args <- list(...)
  if ("summary" %in% names(add_args)) {
    if (doi == w_doi) {
      message("Argument \"summary\" is currently only available",
              " for the temperature logger (\"temp_loggers\") dataset.\n",
              " Ignoring \"summary\" entry. See details in",
              " ?aims_expose_attributes")
      add_args$summary <- NA
    }
    if (!all(add_args$summary %in% allowed$summary)) {
      wrong_s <- setdiff(add_args$summary, allowed$summary)
      stop("summary string \"", paste(wrong_s, sep = "; "),
           "\" not allowed; please check ?aims_expose_attributes")
    }
  }
  if (!is.null(filters)) {
    if (!all(names(filters) %in% allowed$filters)) {
      wrong_f <- setdiff(names(filters), allowed$filters)
      stop("filter string \"", paste(wrong_f, sep = "; "),
           "\" not allowed; please check ?aims_expose_attributes")
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
  if ("summary" %in% names(add_args)) {
    results
  } else {
    results[c("metadata", "citation", "data")]
  }
}
