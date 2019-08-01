require("httr")
require("jsonlite")

defaultBaseEndPoint <- "https://dbh6gco67g.execute-api.ap-southeast-2.amazonaws.com/test/data-by-doi"

# Get values for a filter and return a vector
# getFilterValues <- function(doi, filterName, baseEndPoint=defaultBaseEndPoint) {
#   endPoint <- paste(baseEndPoint, doi, "filters", filterName, sep='/')
#   filterValues <- GET(endPoint)
#   jsonResponse <- content(filterValues, "text", encoding = "UTF-8")
#   filterValuesVector <- fromJSON(jsonResponse , simplifyVector = TRUE)
#   print(filterValuesVector)
#   return(filterValuesVector)
# }

# Get some data and return a data frame
getData <- function(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint) {
  endPoint <- paste(baseEndPoint, doi, "data", sep="/")
  dataRequest <- GET(endPoint, query = filters)
  jsonResponse <- content(dataRequest, "text", encoding = "UTF-8")
  dataFrame <- fromJSON(jsonResponse, simplifyDataFrame = TRUE)
  print(dataFrame)
  return(dataFrame)
}

# Optional OO client
dataplatformclient <- function(baseEndPoint = defaultBaseEndPoint) {
  c <- list("baseEndPoint"=baseEndPoint)
  class(c) <- "dataplatformclient"
  return(c)
}

dataplatformclient.getData <- function(object, doi, filters=NULL) {
  return(getData(doi, filters=filters, baseEndPoint=object$baseEndPoint))
}

# dataplatformclient.getFilterValues <- function(object, doi, filterName) {
#   return(getFilterValues(doi, filterName, baseEndPoint=object$baseEndPoint))
# }
