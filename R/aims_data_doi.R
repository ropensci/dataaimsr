#' AIMS Dataset DOI retriever
#'
#' Returns DOI for a given dataset
#'
#' @param target A \code{\link[base]{character}} vector of length 1 specifying
#' the dataset. Only \code{weather} or #' \code{temp_loggers} are currently
#' allowed.
#'
#' @return A \code{\link[base]{character}} vector
#' containing the dataset DOI string.
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @examples
#' \dontrun{
#' library(dataaimsr)
#' weather_doi <- aims_data_doi("weather")
#' ssts_doi <- aims_data_doi("temp_loggers")
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
