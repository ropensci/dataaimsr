\name{AIMS DataPlatform}
\alias{getFilterValues}
\title{getFilterValues}
\description{
An R Client for AIMS DataPlatform API
}
\usage{
getFilterValues(doi, filter, baseEndPoint=defaultBaseEndPoint)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{doi}{
  The Digital Object Identifier for the data set.
  }
  \item{filterName}{
  The name of the filter to query values for.  Examples are sites, parameters, series.
  }
  \item{baseEndPoint}{
  Alternate baseEndPoint if desired.
  }
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
The returned object is a list of available values that can be provided to the filter.
}
\references{
  Australan Institute of Marine Science (AIMS)
  https://www.aims.gov.au
}
\author{
AIMS Datacentre <adc@aims.gov.au>
}
\examples{

> getFilterValues('10.25845/5c09bf93f315d', 'sites')
 [1] "Agincourt Reef Number 3" "Badu"                    "Beagle Gulf"             "Bramble Cay"             "Cape Bowling Green"      "Cleveland Bay"
 [7] "Darwin"                  "Davies Reef"             "Heron Island"            "Lizard Island"           "Masig Island"            "Myrmidon Reef"
[13] "Ningaloo Reef"           "One Tree Island"         "Orpheus Island"          "Saibai Island"           "Square Rocks"            "Thursday Island"
[19] "Yongala"

}
