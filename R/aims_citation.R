#' Extracts citation attribute from object of class aimsdf
#'
#' Extracts citation attribute from object of class aimsdf
#'
#' @param df_ A data.frame of class \code{\link{aimsdf}} created by
#' function \code{\link{aims_data}}
#'
#' @details This function retrieves the citation attribute from an
#' \code{\link{aimsdf}} object. If the input \code{\link{aimsdf}} object is
#' a summary data.frame (see ?\code{\link{aims_data}}), then output will be
#' an empty string.
#'
#' @return A \code{\link[base]{character}} vector.
#'
#' @author AIMS Datacentre \email{adc@aims.gov.au}
#'
#' @export
aims_citation <- function(df_) {
  attr(df_, "citation")
}
