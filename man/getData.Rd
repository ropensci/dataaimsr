\name{AIMS DataPlatform}
\alias{getData}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{getData}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getData(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint)
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

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
