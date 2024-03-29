#' Request data via the AIMS Data Platform API
#'
#' A function that communicates with the
#' the \href{https://open-aims.github.io/data-platform/}{AIMS Data Platform}
#' via the AIMS Data Platform API
#'
#' @param target A \code{\link[base]{character}} vector of length 1 specifying
#' the dataset. Only \code{weather} or \code{temp_loggers} are currently
#' allowed.
#' @param filters A \code{\link[base]{list}} containing a set of
#' filters for the data query (see Details).
#' @param summary Should summary tables (\code{"summary-by-series"} or
#' \code{"summary-by-deployment"}) or daily aggregated data ("daily") be
#' returned instead of full data (see Details)?
#' @param ... Currently unused. Additional arguments to be passed to
#' non-exported internal functions.
#'
#' @details The AIMS Data Platform R Client provides easy access to
#' data sets for R applications to the
#' \href{https://open-aims.github.io/data-platform/}{AIMS Data Platform API}.
#' The AIMS Data Platform requires an API Key for requests, which can
#' be obtained at this
#' \href{https://open-aims.github.io/data-platform/key-request}{link}.
#' It is preferred that API Keys are not stored in code. We recommend
#' storing the environment variable `AIMS_DATAPLATFORM_API_KEY`
#' permanently under the user's \code{.Renviron} file in order to load
#' the API Key automatically.
#'
#' There are two types of data currently available through the
#' [AIMS Data Platform API](https://open-aims.github.io/data-platform/):
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
#' the examples below). For that, the argument \code{summary} must be either
#' the string \code{"summary-by-series"} or \code{"summary-by-deployment"}.
#' In those cases, time filters will be ignored.
#' 
#' Details about available dates for each dataset and time series can be
#' accessed via Metadata on
#' \href{https://open-aims.github.io/data-platform/}{AIMS Data Platform API}.
#' We raise this caveat here because these time boundaries are very important;
#' data are collected at very small time intervals, a window of just a few days
#' can yield very large datasets. The query will return and error
#' if it reaches the system's memory capacity.
#'
#' For that same reason, from version 1.1.0 onwards, we are offering the
#' possibility of downloading a mean daily aggregated version. For that, the
#' user must set \code{summary = "daily"}. In this particular case, query filter
#' will be taken into account.
#'
#' @return \code{aims_data} returns a \code{\link[base]{data.frame}} of class
#' \code{\link{aimsdf}}.
#'
#' If \code{summary %in% c("summary-by-series", "summary-by-deployment")},
#' the output shows the summary information for the target dataset (i.e.
#' weather or temperature loggers)
#' (NB: currently, \code{summary} only works for the temperature logger
#' database). If \code{summary} is *not* passed as an additional argument, then
#' the output contains **raw** monitoring data. If \code{summary = "daily"},
#' then the output contains **mean daily aggregated** monitoring data.
#' The output also contains five attributes (empty strings if
#' \code{summary} is passed as an additional argument):
#' \itemize{
#'    \item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
#'          containing the metadata record for the data series.}
#'    \item{\code{citation}}{the citation information for the particular
#'          dataset.}
#'    \item{\code{parameters}}{The measured parameters comprised in the
#'          output.}
#'    \item{\code{type}}{The type of dataset. Either "monitoring" if
#'          \code{summary} is not specified, "monitoring (daily aggregation)" if
#'          \code{summary = "daily"}, or a "summary-by-" otherwise.}
#'    \item{\code{target}}{The input target.}
#' }
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @importFrom curl has_internet
#'
#' @seealso \code{\link{aims_citation}}, \code{\link{aims_metadata}},
#' \code{\link{aims_parameters}}
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
#'                                   thru_date = "2018-01-02"))
#'
#' # 2. downloads weather data from all sites
#' # under series_id 64 from Davies Reef
#' # within a defined date range
#' wdf_b <- aims_data("weather", api_key = NULL,
#'                    filters = list(series_id = 64,
#'                                   from_date = "1991-10-18",
#'                                   thru_date = "1991-10-19"))
#' head(wdf_b)
#' range(wdf_b$time)
#'
#' # 3. downloads weather data from all sites
#' # under series_id 64 from Davies Reef
#' # within defined date AND time range
#' wdf_c <- aims_data("weather", api_key = NULL,
#'                    filters = list(series_id = 64,
#'                                   from_date = "1991-10-18T06:00:00",
#'                                   thru_date = "1991-10-18T12:00:00"))
#' head(wdf_c)
#' range(wdf_c$time)
#'
#' # 4. downloads all parameters from all sites
#' # within a defined date range
#' wdf_d <- aims_data("weather", api_key = NULL,
#'                    filters = list(from_date = "2003-01-01",
#'                                   thru_date = "2003-01-02"))
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
#'                                   thru_date = "2018-01-02"))
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
#'
#' # 9. downloads temperature data
#' # within a defined date range, averaged by day
#' sdf_d <- aims_data("temp_loggers", api_key = NULL, summary = "daily",
#'                    filters = list(series = "DAVFL1",
#'                                   from_date = "2018-01-01",
#'                                   thru_date = "2018-01-10"))
#' # note again that there are multiple sites and series
#' # however in this case because we did specify a specific
#' # parameter, series within sites differ by depth only
#' head(sdf_d)
#' unique(sdf_d[, c("site", "series_id", "series", "depth")])
#' unique(sdf_d$parameter)
#' range(sdf_d$time)
#' }
#'
#' @export
aims_data <- function(target, filters = NULL, summary = NA, ...) {
  # dummy variable to allow testing of network
  network <- as.logical(Sys.getenv("NETWORK_UP", unset = TRUE))
  if (!has_internet() | !network) {
    message("It seems that your internet connection is down. You need an ",
            "internet connection to successfully download AIMS data.")
    return(invisible())
  }
  doi <- data_doi(target = target)
  w_doi <- data_doi(target = "weather")
  allowed <- aims_expose_attributes(target = target)
  add_args <- list(...)
  if (!is.na(summary)) {
    if (doi == w_doi) {
      stop("Argument \"summary\" is currently only available",
           " for the temperature logger (\"temp_loggers\") dataset.\n",
           " See details in ?aims_expose_attributes")
    }
    if (!all(summary %in% allowed$summary)) {
      wrong_s <- setdiff(summary, allowed$summary)
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
  all_args <- c(doi = doi, filters = list(filters), summary = summary, add_args)
  results <- try(do.call(page_data, all_args), silent = TRUE)
  if (inherits(results, "try-error")) {
    message("Failed to download monitoring data; Did you specify ",
            "appropriate filter names/values?")
    return(invisible())
  }
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
    message(paste("Result count:", nrow(results$data)))
  }
  final_wrap <- "full_data"
  data_type <- "monitoring"
  if (!is.na(summary)) {
    if (summary == "daily") {
      data_type <- "monitoring (daily aggregation)"
    } else {
      final_wrap <- "summary_data"
    }
  }
  if (final_wrap == "summary_data") {
    attr(results, "citation") <- ""
    attr(results, "metadata") <- ""
    attr(results, "parameters") <- ""
    attr(results, "type") <- summary
    attr(results, "target") <- target
  } else {
    if (!inherits(results$data, "data.frame") |
          (inherits(results$data, "data.frame") && nrow(results$data) == 0)) {
      message("Failed to download monitoring data; Did you specify ",
              "appropriate filter names/values?")
      return(invisible())
    }
    attr(results$data, "citation") <- results$citation
    attr(results$data, "metadata") <- results$metadata
    attr(results$data, "parameters") <- unique(results$data$parameter)
    attr(results$data, "type") <- data_type
    attr(results$data, "target") <- target
    results <- results$data
  }
  class(results) <- c("aimsdf", class(results))
  results
}
