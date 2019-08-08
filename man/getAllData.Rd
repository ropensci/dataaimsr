\name{AIMS DataPlatform}
\alias{getAllData}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{getAllData}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getAllData(doi, filters=NULL, baseEndPoint=defaultBaseEndPoint)
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
  # Create dataplatform client
  client <- dataplatformclient()
  # Get a dataFrame
  dataFrame <- dataplatform.getData(client, '10.25845/5c09bf93f315d', filters=list("site-name"="Davies Reef", "size"=10))
  [1] "Cite this data as: Australian Institute of Marine Science (AIMS). 2009, Australian Institute of Marine Science Automatic Weather Stations, https://doi.org/10.25845/5c09bf93f315d, accessed 8 August 2019.  Site: Davies Reef."

  # Get the next page
  nextDataFrame <- dataplatform.getNextData(dataFrame$links$'next')

  # Get all data
  dataFrame <- dataplatform.getAllData(client, '10.25845/5c09bf93f315d', filters=list('site-name'='Davies Reef', 'size'=10000))
  [1] "Cite this data as: Australian Institute of Marine Science (AIMS). 2009, Australian Institute of Marine Science Automatic Weather Stations, https://doi.org/10.25845/5c09bf93f315d, accessed 8 August 2019.  Site: Davies Reef."
  [1] "Result count: 20000"
  [1] "Result count: 30000"
  [1] "Result count: 40000"
  [1] "Result count: 50000"
  [1] "Result count: 60000"
  [1] "Result count: 70000"
  [1] "Result count: 80000"
  [1] "Result count: 90000"
  [1] "Result count: 100000"
  [1] "Result count: 110000"
  [1] "Result count: 120000"
  [1] "Result count: 122164"
  [1] "Result count: 122164"
  summary(dataFrame)
           Length Class      Mode
  metadata  1     -none-     character
  citation  1     -none-     character
  links     1     -none-     list
  results  14     data.frame list
  summary(dataFrame$results)
  deployment_id    site_name         location_name       depth            latitude        longitude      parameter          serial_num           data_id              time             raw_value        qc_value       series_id    series_name
  Min.   :10933   Length:10000       Length:10000       Mode:logical   Min.   :-18.83   Min.   :147.6   Length:10000       Length:10000       Min.   :516430890   Length:10000       Min.   : 0.00   Min.   : 0.00   Min.   :2882   Length:10000
  1st Qu.:10941   Class :character   Class :character   NA's:10000     1st Qu.:-18.83   1st Qu.:147.6   Class :character   Class :character   1st Qu.:527888447   Class :character   1st Qu.:12.24   1st Qu.:12.24   1st Qu.:4783   Class :character
  Median :10941   Mode  :character   Mode  :character                  Median :-18.83   Median :147.6   Mode  :character   Mode  :character   Median :543658375   Mode  :character   Median :19.44   Median :19.44   Median :4783   Mode  :character
  Mean   :10941                                                        Mean   :-18.83   Mean   :147.6                                         Mean   :541826509                      Mean   :19.17   Mean   :19.17   Mean   :4674
  3rd Qu.:10941                                                        3rd Qu.:-18.83   3rd Qu.:147.6                                         3rd Qu.:550019914                      3rd Qu.:25.56   3rd Qu.:25.56   3rd Qu.:4783
  Max.   :10941                                                        Max.   :-18.83   Max.   :147.6                                         Max.   :580588025                      Max.   :53.89   Max.   :53.89   Max.   :4783
                                                                                                                                                                                                    NA's   :10
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
