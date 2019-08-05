library("httr")
library("jsonlite")

defaultBaseEndPoint <- "https://dbh6gco67g.execute-api.ap-southeast-2.amazonaws.com/test/data-by-doi"

# Get some data and return a data frame
getData <- function(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint) {
  endPoint <- paste(baseEndPoint, doi, "data", sep="/")
  dataRequest <- GET(endPoint, query = filters)
  jsonResponse <- content(dataRequest, "text", encoding = "UTF-8")
  dataFrame <- fromJSON(jsonResponse, simplifyDataFrame = TRUE)
  #print(dataFrame)
  return(dataFrame)
}

# Optional OO client
dataplatformclient <- function(baseEndPoint = defaultBaseEndPoint) {
  require("httr")
  require("jsonlite")
  c <- list("baseEndPoint"=baseEndPoint)
  class(c) <- "dataplatformclient"
  return(c)
}

dataplatform.getData <- function(object, doi, filters=NULL) {
  return(getData(doi, filters=filters, baseEndPoint=object$baseEndPoint))
}

# dataplatformclient.getFilterValues <- function(object, doi, filterName) {
#   return(getFilterValues(doi, filterName, baseEndPoint=object$baseEndPoint))
# }
