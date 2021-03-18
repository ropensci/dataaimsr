#' Class \code{aimsdf} of data.frame downloaded by the \pkg{dataaimsr} package
#'
#' Datasets downloaded by the
#' \code{\link[dataaimsr:dataaimsr-package]{dataaimsr}} package inherit
#' the \code{aimsdf} class, which is data.frame with three attributes.
#'
#' @name aimsdf-class
#' @aliases aimsdf
#' @docType class
#'
#' @details
#' See \code{methods(class = "aimsdf")} for an overview of available methods.
#'
#' @seealso \code{\link{aims_data}}
#'
NULL

#' Checks if argument is a \code{aimsdf} object
#'
#' @param x An \R object
#'
#' @export
is_aimsdf <- function(x) {
  inherits(x, "aimsdf")
}
