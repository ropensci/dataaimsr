library(httr)
library(jsonlite)

defaultBaseEndPoint <- "https://api.aims.gov.au/data/v1.0"
#defaultBaseEndPoint <- "https://6aq0l8l806.execute-api.ap-southeast-2.amazonaws.com/prod/v1.0"
defaultDateFormat <- "%Y-%m-%dT%H:%M:%OS"

aimsWeather <- "10.25845/5c09bf93f315d"
aimsTemperatureLoggers <- "10.25845/5b4eb0f9bb848"

# Get some data and return a data frame
getData <- function(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint) {
  endPoint <- paste(baseEndPoint, doi, "data", sep="/")
  dataRequest <- GET(endPoint, query = filters)
  jsonResponse <- content(dataRequest, "text", encoding = "UTF-8")
  results <- fromJSON(jsonResponse, simplifyDataFrame = TRUE)
  results <- updateFormat(results)
  print(paste("Cite this data as:", results$citation))
  return(results)
}

# Get some data and return a data frame
getNextData <- function(url) {
  parsed_url <- parse_url(url)
  # Unfortunately need to remove plus sign if not decoded properly
  parsed_url$query$cursor <- gsub("\\+", " ", parsed_url$query$cursor)
  dataRequest <- GET(parsed_url)
  if (http_error(dataRequest)) {
    warning(paste("Error", http_status(dataRequest), content(dataRequest)))
  } else {
    jsonResponse <- content(dataRequest, "text", encoding = "UTF-8")
    results <- fromJSON(jsonResponse, simplifyDataFrame = TRUE)
    if (nrow(results$results)==0) {
      warning("No more data")
    } else {
      results <- updateFormat(results)
      return(results)
    }
  }
}

getAllData <- function(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint) {
  results = getData(doi, filters=filters, baseEndPoint=baseEndPoint)
  nextUrl <- results$links$nextPage
  moreData <<- TRUE
  while(moreData) {
    tryCatch({
      nextResults <- getNextData(nextUrl)
      newDataFrame <- rbind(results$dataFrame, nextResults$dataFrame)
      results$dataFrame <- newDataFrame
      if ("links" %in% names(nextResults) && "nextPage" %in% names(nextResults$links)) {
        nextUrl <- nextResults$links$nextPage
      } else {
        moreData <<- FALSE
      }
    }, warning = function(w) {
      moreData <<- FALSE
    }, error = function(e) {
      #print(paste("getAllError", e))
      moreData <<- FALSE
    })
    print(paste("Result count:", nrow(results$dataFrame)))
  }
  return(results)
}

updateFormat <- function(results) {
  if ("links" %in% names(results) && "next" %in% names(results$links)) {
    results$links$nextPage <- results$links$'next'
    results$links$'next' <- NULL
  }
  results$results$time <- as.POSIXct(strptime(results$results$time, format=defaultDateFormat, tz="UTC"))
  names(results)[names(results) == "results"] <- "dataFrame"
  return(results)
}

# https://b5ms5dkmia.execute-api.ap-southeast-2.amazonaws.com/prod/data-by-doi/10.25845/5c09bf93f315d/data?site-name=Davies Reef&size=10
