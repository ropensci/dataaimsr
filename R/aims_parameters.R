#' Extracts parameters attribute from object of class aimsdf
#'
#' Extracts parameters attribute from object of class aimsdf
#'
#' @param df_ A data.frame of class \code{\link{aimsdf}} created by
#' function \code{\link{aims_data}}
#'
#' @details This function retrieves the parameters attribute from an
#' \code{\link{aimsdf}} object. If the input \code{\link{aimsdf}} object is
#' a summary data.frame (see ?\code{\link{aims_data}}), then output will be
#' an empty string.
#'
#' @return A \code{\link[base]{character}} vector.
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @export
aims_parameters <- function(df_) {
  attr(df_, "parameters")
}
