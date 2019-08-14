library(httr)
library(jsonlite)

defaultBaseEndPoint <- "https://6aq0l8l806.execute-api.ap-southeast-2.amazonaws.com/prod/v1.0"
defaultDateFormat <- "%Y-%m-%dT%H:%M:%OS"

# Get some data and return a data frame
getData <- function(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint) {
  endPoint <- paste(baseEndPoint, doi, "data", sep="/")
  dataRequest <- GET(endPoint, query = filters)
  jsonResponse <- content(dataRequest, "text", encoding = "UTF-8")
  dataFrame <- fromJSON(jsonResponse, simplifyDataFrame = TRUE)
  dataFrame$results$time <- as.POSIXct(strptime(dataFrame$results$time, format=defaultDateFormat, tz="UTC"))
  dataFrame <- addNextPage(dataFrame)
  print(paste("Cite this data as:", dataFrame$citation))
  return(dataFrame)
}

# Get some data and return a data frame
getNextData <- function(url) {
  dataRequest <- GET(parse_url(url))
  if (http_error(dataRequest)) {
    if (http_status(dataRequest)==204) {
      warning("No more data")
    } else {
      warning(paste("Error", http_status(dataRequest), content(dataRequest)))
    }
  } else {
    jsonResponse <- content(dataRequest, "text", encoding = "UTF-8")
    dataFrame <- fromJSON(jsonResponse, simplifyDataFrame = TRUE)
    dataFrame$results$time <- as.POSIXct(strptime(dataFrame$results$time, format=defaultDateFormat, tz="UTC"))
    dataFrame <- addNextPage(dataFrame)
    if (nrow(dataFrame$results)==0) {
      warning("No more data")
    } else return(dataFrame)
  }
}

getAllData <- function(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint) {
  dataFrame = getData(doi, filters=filters, baseEndPoint=baseEndPoint)
  nextUrl <- dataFrame$links$nextPage
  moreData <<- TRUE
  while(moreData) {
    tryCatch({
      nextDataFrame <- getNextData(nextUrl)
      newDataFrame <- rbind(dataFrame$results, nextDataFrame$results)
      dataFrame$results <- newDataFrame
      if ("links" %in% names(nextDataFrame) && "nextPage" %in% names(dataFrame$links)) {
        nextUrl <- nextDataFrame$links$nextPage
      } else {
        moreData <<- FALSE
      }
    }, warning = function(w) {
      moreData <<- FALSE
    }, error = function(e) {
      moreData <<- FALSE
    })
    print(paste("Result count:", nrow(dataFrame$results)))
  }
  return(dataFrame)
}

addNextPage <- function(dataFrame) {
  if ("links" %in% names(dataFrame) && "next" %in% names(dataFrame$links)) {
    dataFrame$links$nextPage <- dataFrame$links$'next'
    dataFrame$links$'next' <- NULL
  }
  return(dataFrame)
}

# https://b5ms5dkmia.execute-api.ap-southeast-2.amazonaws.com/prod/data-by-doi/10.25845/5c09bf93f315d/data?site-name=Davies Reef&size=10
