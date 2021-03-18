---
title: 'dataaimsr: An R Client for the Australian Institute of Marine Science Data Platform API which provides easy access to AIMS Data Platform'
tags:
  - R
  - sea surface temperature
  - weather stations
  - long-term environmental monitoring
  - Australia
  - API
authors:
  - name: Diego R. Barneche
    orcid: 0000-0002-4568-2362
    affiliation: "1, 2"
  - name: Greg Coleman
    affiliation: "3"
  - name: Duncan Fermor
    affiliation: "3"
  - name: Eduardo Klein
    affiliation: "3"
  - name: Tobias Robinson
    affiliation: "3"
  - name: Jason Smith
    affiliation: "3"
  - name: Jeffrey L. Sheehan
    affiliation: "3"
  - name: Shannon Dowley
    affiliation: "3"
  - name: Dean Ditton
    affiliation: "3"
  - name: Kevin Gunn
    affiliation: "3"
  - name: Gavin Ericson
    affiliation: "3"
  - name: Murray Logan
    affiliation: "3"
  - name: Mark Rehbein
    affiliation: "3"
affiliations:
 - name: Australian Institute of Marine Science, Crawley, WA 6009, Australia
   index: 1
 - name: The Indian Ocean Marine Research Centre, The University of Western Australia, Crawley, WA 6009, Australia
   index: 2
 - name: Australian Institute of Marine Science, Townsville, Qld 4810, Australia
   index: 3

citation_author: Barneche et al.
date: "2021-03-18"
bibliography: paper.bib
output:
  my_modified_joss:
    fig_caption: yes
csl: apa.csl
journal: JOSS
---

# Summary

`dataaimsr` is an **R package** written to provide open access to decades
of field measurements of atmospheric and oceanographic parameters around the
coast of Australia, conducted by the
[Australian Institute of Marine Science][0] (AIMS). The package communicates
with the recently-developed AIMS Data Platform API via an API key. Here we
describe the available datasets as well as example usage cases.

[0]: https://www.aims.gov.au/

# Background and Statement of need

The Australian Institute of Marine Science (AIMS) has a long tradition in
measuring and monitoring a series of environmental parameters along the
tropical coast of Australia. These parameters include long-term record of sea
surface temperature, wind characteristics, atmospheric temperature, pressure,
chlorophyll-a data, among many others. The AIMS Data Centre team has recently
developed the [AIMS Data Platform API][1] which is a *REST API* providing
JSON-formatted data to users. `dataaimsr` is an **R package** written to
allow users to communicate with the AIMS Data Platform API using an API key
and a few convenience functions to interrogate and understand the datasets
that are available to download. In doing so, it allows the user to
fully explore these datasets in R in whichever capacity they want (e.g.
data visualisation, statistical analyses, etc). The package itself contains
a `plot` method which allows the user to plot summaries of the different types
of dataset made available by the API.

[1]: https://open-aims.github.io/data-platform/

Currently, there are two AIMS long-term monitoring datasets available to be
downloaded through `dataaimsr`:

### Northern Australia Automated Marine Weather And Oceanographic Stations

Automatic weather stations have been deployed by AIMS since 1980. Most of the
stations are along the Great Barrier Reef (GBR) including the Torres Strait in
North-Eastern Australia but there is also a station in Darwin and one at
Ningaloo Reef in Western Australia. Many of the stations are located on the
reef itself either on poles located in the reef lagoon or on tourist pontoons
or other structures. A list of the weather stations which have been deployed
by AIMS and the period of time for which data may be available can be
found on the [AIMS metadata][2] webpage. **NB:** Records may not be continuous
for the time spans given.

[2]: https://apps.aims.gov.au/metadata/view/0887cb5b-b443-4e08-a169-038208109466

### AIMS Sea Water Temperature Observing System (AIMS Temperature Logger Program)

The data provided here are from a number of sea water temperature monitoring
programs conducted in tropical and subtropical coral reefs environments around
Australia. Data are available from approximately 80 GBR sites, 16 Coral Sea
sites, 7 sites in North West Western Australia (WA), 8 Queensland regional
ports, 13 sites in the Solitary Islands, 4 sites in Papua New Guinea and 10
sites in the Cocos (Keeling) Islands. Data are obtained from in-situ data
loggers deployed on the reef. Temperature instruments sample water
temperatures every 5-10 minutes (typically) and are exchanged and downloaded
approximately every 12 months. Temperature loggers on the reef-flat are
generally placed just below Lowest Astronomical Tide level. Reef-slope (or
where specified as Upper reef-slope) generally refers to depths 5--9 m while
Deep reef-slope refers to depths of ~20 m. For more information on the dataset
and its usage, please visit the [AIMS metadata][3] webpage.

[3]: https://apps.aims.gov.au/metadata/view/4a12a8c0-c573-11dc-b99b-00008a07204e 

# Technical details and Usage

Before loading the package, a user needs to download and store their personal
[AIMS Data Platform API Key][4]---we strongly encourage users to
maintain their API key as a private, locally hidden environment variable
(`AIMS_DATAPLATFORM_API_KEY`) in the `.Renviron` file for
automatic loading at the start of an R session.

[4]: https://open-aims.github.io/data-platform/key-request

`dataaimsr` imports the packages *httr* [@httrcit], *jsonlite* [@jsonlitecit],
*parsedate* [@parsedatecit], *dplyr* [@dplyrcit], *tidyr* [@tidyrcit],
*rnaturalearth* [@rnaturalearthcit], *sf* [@sfcit], *ggplot2* [@ggplot2cit],
*ggrepel* [@ggrepelcit] and *curl* [@curlcit].

The [Weather Station][2] and [Sea Water Temperature Loggers][3] datasets are
very large (terabytes in size), and as such they are not locally stored.
They are instead downloaded via the API and unique DOI identifiers. The 
datasets are structured by sites, series and parameters. A series is a 
continuing time-series, i.e. a collection of deployments measuring the 
same parameter (e.g. Air Temperature, Air Pressure, Chlorophyll) at the 
same subsite. So, for a given site and parameter, there might exist multiple
subsites and therefore series, in which case they are most likely 
distinguishable by depth.

For the Sea Water Temperature Loggers dataset, series is synonymous 
with the variable called subsite. For the Weather Station dataset, it 
is the combination of subsite and parameter.

## Discover a dataset

The [AIMS Data Platform API][1] points to the full metadata of each
dataset. We are currently working on ways to facilitate the 
visualisation of both datasets and their multiple features directly
through the R package. At the moment though it is only possible
to visualise summary information for the Sea Water Temperature Loggers
dataset. A similar feature for the Weather Station dataset will be 
implemented in the near future (likely late 2021)---so for now, please
refer to the online metadata to discover from where (and when) one can 
download data.

### Data summaries

The first step would be to visualise the dataset. We do this by
mapping all available sites. For example, we download the summary information
for the Sea Water Temperature Loggers dataset using the main function called
`aims_data`:


```r
library(dataaimsr)
sdata <- aims_data("temp_loggers", api_key = NULL,
                   summary = "summary-by-series")
head(sdata)
```

```
##   site_id                    site subsite_id    subsite series_id     series         parameter parameter_id time_coverage_start time_coverage_end      lat      lon depth uncal_obs cal_obs qc_obs
## 1       1 Agincourt Reef Number 3       2687     AG3FL1      2687     AG3FL1 Water Temperature            1          1996-03-30        2008-12-11 -15.9903 145.8212     0     23130  110480 110480
## 2       1 Agincourt Reef Number 3      14276  AG3SL1old     14276  AG3SL1old Water Temperature            1          1996-03-30        2011-07-21 -15.9905 145.8213     5    114450  216794 216794
## 3       3           Cleveland Bay       3007 CLEVAWSSL1      3007 CLEVAWSSL1 Water Temperature            1          2004-05-13        2008-05-03 -19.1557 146.8813     7     11951   53231  53231
## 4       3           Cleveland Bay       3069 CLEVAWSFL1      3069 CLEVAWSFL1 Water Temperature            1          2005-09-15        2005-12-22 -19.1557 146.8813     1         0    4656   4656
## 5       4             Davies Reef       2629     DAVFL1      2629     DAVFL1 Water Temperature            1          1997-08-26        2019-06-10 -18.8065 147.6688     1    437544  566585 566585
## 6       4             Davies Reef       2630     DAVSL1      2630     DAVSL1 Water Temperature            1          1996-05-02        2017-05-07 -18.8060 147.6686     8    369317  495663 495608
```

Setting the argument `api_key = NULL` means that `dataaimsr` will
automatically search for the user's API key stored in `.Renviron`.
The `summary` argument here is key. It should only be flagged when the
user wants an overview of the available data. Again, this currently
implemented for the Sea Water Temperature Loggers dataset. One can
visualise `summary-by-series` or `summary-by-deployment`. The output of
`aims_data` is a `data.frame` of class `aimsdf`.

Notice that `sdata` contains a lot of information, most of which is
related to site / series / parameter ID. Each row corresponds to a
unique series, and a certain site may contain multiple series; in such
cases, series generally differ from one another by depth. The columns 
`time_coverage_start` and `time_coverage_end` are probably one of the most
valuable pieces of information. They provide the user with the window of data
collection for a particular series, which is probably crucial to decide
whether that particular series is of relevance to the specific question in
hand.

Also note that there are three columns containing the total number of 
observations in a series: `uncal_obs`, `cal_obs` and `qc_obs`, which 
respectively stand for uncalibrated, calibrated, and quality-controlled 
observations. Calibrated and quality-controlled are generally the same.
Instruments are routinely calibrated (mostly once a year) in a temperature-controlled water bath and corrections applied to the data. After
calibration, all data records are quality controlled based on the following
tests: 1) clip to in-water only data, using deployment's metadata, 2)
impossible value check: data outside a fixed temperature range (14˚C – 40˚C)
is flagged as bad data, 3) spike test: individual extreme values are flagged
as probably bad according to the algorithm presented in @morelo2014methods and
4) Excessive gradient test: pairs of data that present a sudden change in the
slope are flagged as probably bad [@toma2016acta]. If any data record fails at
least one of the tests, a QC flag equal to 2 is returned, otherwise, the QC
flag is set to 1.

One can visualise this data, for instance, by plotting them
on a map of Australia, while colouring based on the total amount of calibrated
observations (Fig. \@ref(fig:summary)).

`aimsdf` objects can be plotted using the `plot` function. For summary data
such as `sdata`, plot will always generate a map with the points around
Australia and associated regions, coloured by the number of calibrated
observations:



(ref:fig-summary) Distribution of all temperature logger series around Australian waters.

\begin{figure}
\includegraphics[width=1\linewidth]{summary} \caption{(ref:fig-summary)}(\#fig:summary)
\end{figure}

In the case of the Weather Station dataset, the user can call a
the `aims_filter_values` function which allows one to query what
sites, series and parameters are available for both datasets:


```r
aims_filter_values("weather", filter_name = "series") %>%
  head()
```

```
##   series_id                                                                 series
## 1    104918        Myrmidon Reef Weather Station Wind Speed (scalar avg b 10 min) 
## 2    100686                            Saibai Island Weather Station Hail Duration
## 3       266 Orpheus Island Relay Pole 3 Wind Direction (Vector Average 30 Minutes)
## 4      2639 Hardy Reef Weather Station Wind Direction (Vector Standard 10 Minutes)
## 5     10243                           Raine Island Weather Station Air Temperature
## 6       258             Orpheus Island Relay Pole 3 Wind Speed (Scalar avg 10 min)
```

The downside is that one cannot know what time window is available
for each one of those, nor how they are nested (i.e. series /
parameter / site). In a way though the series name generally
gives that information anyway (see code output above). If knowing the 
available observation window is absolutely crucial, then as mentioned 
above the user should refer to the [online metadata][3].

## Download slices of datasets

We recommend slicing the datasets because AIMS monitoring datasets are of very 
high temporal resolution and if one tries to download an entire series
it might take hours if not days. To slice the datasets properly, the user
needs to apply filters to their query.

### Data filters

Filters are the last important information the user needs to know to 
master the navigation and download of AIMS monitoring datasets. Each 
dataset can filtered by attributes which can be exposed with the function
`aims_expose_attributes`:


```r
aims_expose_attributes("weather")
```

```
## $summary
## [1] NA
## 
## $filters
##  [1] "site"      "subsite"   "series"    "series_id" "parameter" "size"      "min_lat"   "max_lat"   "min_lon"   "max_lon"   "from_date" "thru_date" "version"   "cursor"
```

```r
aims_expose_attributes("temp_loggers")
```

```
## $summary
## [1] "summary-by-series"     "summary-by-deployment"
## 
## $filters
##  [1] "site"      "subsite"   "series"    "series_id" "parameter" "size"      "min_lat"   "max_lat"   "min_lon"   "max_lon"   "from_date" "thru_date" "version"   "cursor"
```

The help file (see `?aims_expose_attributes`) contains the details about what
each filter targets. So, having an understanding of the summaries and what
filters are available provide the user with a great head start.

Downloading the data is achieved using the same `aims_data` function, 
however now the `summary` argument is omitted, and instead 
implement filters. For example, to download all the data collected at the
[Yongala wreck][6] for a specific time window:

[6]: https://en.wikipedia.org/wiki/SS_Yongala


```r
wdata_a <- aims_data("weather", api_key = NULL,
                     filters = list(site = "Yongala",
                                    from_date = "2018-01-01",
                                    thru_date = "2018-01-02"))
```

The returned `aimsdf` object in this case has attributes which give us
summary crucial information:

- `metadata` a doi link containing the metadata record for the data series

- `citation` the citation information for the particular dataset

- `parameters` an output `data.frame`

These can be directly extracted using the convenience functions
`aims_metadata`, `aims_citation` and `aims_parameters`, e.g.:


```r
aims_metadata(wdata_a)
```

```
## [1] "Metadata record https://doi.org/10.25845/5c09bf93f315d"
```

This example data contains multiple parameters available for this site at the
specified time, and the actual measurements are either raw or
quality-controlled. For monitoring data (i.e. when `summary = NA` in a
`aims_data` call), we can either visualise the data as a time series broken
down by parameter, or a map showing the sites with some summary info. If the
parameters are not specified, then `dataaimsr` will plot a maximum of 4
parameters chosen at random for a time series plot. Alternatively the user can
specify which parameters are to be plotted (Fig. \@ref(fig:wind)).



(ref:fig-wind) Yongala wreck profiles for water pressure and chlorophyll-a between the first and second of January 2018.

\begin{figure}
\includegraphics[width=1\linewidth]{wind} \caption{(ref:fig-wind)}(\#fig:wind)
\end{figure}

The filters `from_date` and `thru_date` can be further refined by including a
time window to download the data:


```r
wdata_b <- aims_data("weather", api_key = NULL,
                     filters = list(series_id = 64,
                                    from_date = "1991-10-18T06:00:00",
                                    thru_date = "1991-10-18T12:00:00"))
range(wdata_b$time)
```

```
## [1] "1991-10-18 06:00:00 UTC" "1991-10-18 12:00:00 UTC"
```

### Methods

Objects of class `aimsdf` have associated `plot`, `print` and `summary`
methods.

### Data citation

Whenever using `dataaimsr`, we ask the user to not only cite this paper, but
also any data used in an eventual publication. Citation data can be extracted
from a dataset using the function `aims_citation`:


```r
aims_citation(wdata_b)
```

```
## [1] "Australian Institute of Marine Science (AIMS). 2009, Australian Institute of Marine Science Automatic Weather Stations, https://doi.org/10.25845/5c09bf93f315d, accessed 18 March 2021.  Time period: 1991-10-18T06:00:00 to 1991-10-18T12:00:00.  Series: Davies Reef Weather Station Air Temperature"
```

## Sister web tool

The Time Series Explorer (https://apps.aims.gov.au/ts-explorer/) is an
interactive web-based application that visualises large time series datasets.
The application utilises the AIMS Data Platform API to dynamically query data
according to user selection and visualise the data as line graphs. Series are
able to be compared visually. For large series, data are aggregated to daily
averages and displayed as minimum, maximum and mean. When the user 'zooms in'
sufficiently, the data will be displayed as non-aggregate values
(Fig. \@ref(fig:tssa)). This technique is being used to ensure the application
performs well with large time series.

(ref:fig-tssa) Interactive discovery and visualisation of data series.

\begin{figure}
\includegraphics[width=1\linewidth]{tssa} \caption{(ref:fig-tssa)}(\#fig:tssa)
\end{figure}

The user can then download the displayed data as CSV or obtain a R code
snippet that shows how to obtain the data using the dataaimsr package
(Fig. \@ref(fig:tssb)). In this way, a user can easily explore and discover
datasets and then quickly and easily have this data in their R environment for
additional analysis.

(ref:fig-tssb) Download/Export displayed data via R snippet.

\begin{figure}
\includegraphics[width=1\linewidth]{tssb} \caption{(ref:fig-tssb)}(\#fig:tssb)
\end{figure}

# Future directions

The API is still a work in progress. We are working on ways to better
facilitate data visualisation and retrieval, and also we are trying to
standardise the outputs from the different datasets as much as possible. In the
future, we envision that `dataaimsr` will also provide access to other
monitoring datasets collected by AIMS.

# References
