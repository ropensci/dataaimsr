request_warning <- function(dt_req) {
  warning(paste("Error", httr::http_status(dt_req),
                httr::content(dt_req)))
}

json_results  <-  function(dt_req) {
    json_resp <- httr::content(dt_req, "text", encoding = "UTF-8")
    jsonlite::fromJSON(json_resp, simplifyDataFrame = TRUE)
}

request_process <- function(dt_req, next_page = FALSE) {
  if (httr::http_error(dt_req)) {
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

# Get some data and return a data frame
page_data_get <- function(doi, filters = NULL, api_key = NULL) {
  base_end_pt <- getOption("aimsdataplatform.base_end_point")
  end_pt <- paste(base_end_pt, doi, "data", sep = "/")
  dt_req <- httr::GET(end_pt,
                      httr::add_headers("X-Api-Key" = api_key_find(api_key)),
                      query = filters)
  request_process(dt_req)
}

# Get some data and return a data frame
next_page_data_get <- function(url, api_key = NULL) {
  parsed_url <- httr::parse_url(url)
  # Unfortunately need to remove plus sign if not decoded properly
  parsed_url$query$cursor <- gsub("\\+", " ", parsed_url$query$cursor)
  dt_req <- httr::GET(parsed_url,
                      httr::add_headers("X-Api-Key" = api_key_find(api_key)))
  request_process(dt_req, next_page = TRUE)
}

#' @ ... api_key to page_data_get and next_page_data_get
data_get <- function(doi, filters = NULL, ...) {
  results <- page_data_get(doi, filters = filters, ...)
  next_url <- results$links[["next"]]
  more_data <- TRUE
  while (more_data) {
    tryCatch({
      next_res <- next_page_data_get(next_url, ...)
      new_df <- rbind(results$data, next_res$data)
      results$data <- new_df
      if ("links" %in% names(next_res) &&
          "next_page" %in% names(next_res$links)) {
        next_url <- next_res$links[["next"]]
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

filter_values_get <- function(doi, filter_name) {
  base_end_pt <- getOption("aimsdataplatform.base_end_point")
  end_pt <- paste(base_end_pt, doi, filter_name, sep = "/")
  dt_req <- httr::GET(end_pt)
  if (httr::http_error(dt_req)) {
    request_warning(dt_req)
  } else {
    json_results(dt_req)
  }
}

format_update <- function(results) {
  date_format <- getOption("aimsdataplatform.date_format")
  results$results$time <- as.POSIXct(strptime(results$results$time,
                                              format = date_format,
                                              tz = "UTC"))
  names(results)[names(results) == "results"] <- "data"
  results
}

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
