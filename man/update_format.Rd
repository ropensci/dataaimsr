% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers.R
\name{update_format}
\alias{update_format}
\title{Format \code{\link[jsonlite]{fromJSON}} output list}
\usage{
update_format(results, doi)
}
\arguments{
\item{results}{A \code{\link[jsonlite]{fromJSON}} list
generated by \code{\link{json_results}}.}

\item{doi}{A \href{https://www.doi.org/}{Digital Object Identifier}
for a chosen
\href{https://open-aims.github.io/data-platform/}{AIMS data series}}
}
\value{
\code{aims_data} returns a \code{\link[base]{data.frame}} of class
\code{\link{aimsdf}}.

If \code{summary \%in\% c("summary-by-series", "summary-by-deployment")},
the output shows the summary information for the target dataset (i.e.
weather or temperature loggers)
(NB: currently, \code{summary} only works for the temperature logger
database). If \code{summary} is \emph{not} passed as an additional argument, then
the output contains \strong{raw} monitoring data. If \code{summary = "daily"},
then the output contains \strong{mean daily aggregated} monitoring data.
The output also contains five attributes (empty strings if
\code{summary} is passed as an additional argument):
\itemize{
\item{\code{metadata}}{a \href{https://www.doi.org/}{DOI} link
containing the metadata record for the data series.}
\item{\code{citation}}{the citation information for the particular
dataset.}
\item{\code{parameters}}{The measured parameters comprised in the
output.}
\item{\code{type}}{The type of dataset. Either "monitoring" if
\code{summary} is not specified, "monitoring (daily aggregation)" if
\code{summary = "daily"}, or a "summary-by-" otherwise.}
\item{\code{target}}{The input target.}
}
}
\description{
When \code{\link[jsonlite]{fromJSON}} returns a list, format list names
}
\author{
AIMS Datacentre \email{adc@aims.gov.au}
}
\keyword{internal}
