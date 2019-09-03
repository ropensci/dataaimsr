\name{AIMS DataPlatform}
\alias{getPageData}
\title{getPageData}
\description{
An R Client for AIMS DataPlatform API
}
\usage{
getPageData(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint, apiKey=NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{doi}{
  The Digital Object Identifier for the data set.
  }
  \item{filters}{
  A list of filters on the request such as site_name, eg filters=list("site_name"="Davies Reef").
  }
  \item{baseEndPoint}{
  Alternate baseEndPoint if desired.
  }
  \item{apiKey}{
  The users AIMS DataPlatform API Key used for authentication.  Can be supplied here but recommended to be stored in .Renviron file.
  }
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
  The returned object is a list comprising metadata and a data frame:
  \item{metadata}{
  Information about the Metadata record of the associated DOI.
  }
  \item{citation}{
  An academic citation for the returned data.
  }
  \item{links}{
  Any links associtated with the data, a link to the next page of data
  }
  \item{dataFrame}{
  The data frame.
  }
}
\references{
  Australan Institute of Marine Science (AIMS)
  https://www.aims.gov.au
}
\author{
AIMS Datacentre <adc@aims.gov.au>
}
\examples{
  # Get a dataFrame
  > results <- getPageData('10.25845/5c09bf93f315d', filters=list("site-name"="Davies Reef", "size"=10))
  [1] "Cite this data as: Australian Institute of Marine Science (AIMS). 2009, Australian Institute of Marine Science Automatic Weather Stations, https://doi.org/10.25845/5c09bf93f315d, accessed 8 August 2019.  Site: Davies Reef."
  > results$dataFrame
}
