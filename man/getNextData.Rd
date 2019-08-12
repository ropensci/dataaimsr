\name{AIMS DataPlatform}
\alias{getNextData}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{getNextData}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getNextData(url)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{url}{
    The URL of a data request.  Generally generated from the previous page under the links.nextPage field of JSON output.
  }
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
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
  dataFrame <- getData('10.25845/5c09bf93f315d', filters=list("site-name"="Davies Reef", "size"=10))
  [1] "Cite this data as: Australian Institute of Marine Science (AIMS). 2009, Australian Institute of Marine Science Automatic Weather Stations, https://doi.org/10.25845/5c09bf93f315d, accessed 8 August 2019.  Site: Davies Reef."

  # Get the next page
  nextDataFrame <- getNextData(dataFrame$links$nextPage)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
