---
title: 'dataaimsr: A Client for the Australian Institute of Marine Science Data Platform API which provides easy access to AIMS Data Platform'
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
  - name: Jeffrey L. Sheehan
    affiliation: "3"
  - name: Duncan Fermor
    affiliation: "3"
  - name: Murray Logan
    affiliation: "3"
  - name: Mark Rehbein
    affiliation: "3"
affiliations:
 - name: Australian Institute of Marine Science, Crawley, WA 6009, Australia
   index: 1
 - names: The Indian Ocean Marine Research Centre, The University of Western Australia, Crawley, WA 6009, Australia
   index: 2
 - name: Australian Institute of Marine Science, Townsville, Qld 4810, Australia
   index: 3

citation_author: Barneche et al.
date: "2021-02-11"
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
that are available to download.

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
[AIMS Data Platform API Key][4]---we recommend it storing it in `.Renviron`.

[4]: https://open-aims.github.io/data-platform/key-request

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
mapping all available sites. First we need to store the DOI for the
target dataset---this is done via the function `aims_data_doi`. We
can then download the summary information for the Sea Water Temperature 
Loggers dataset using the main function called `aims_data`:


```r
library(dataaimsr)
# see ?aims_data_doi for argument names
ssts_doi <- aims_data_doi("temp_loggers")
sdata <- aims_data(ssts_doi, api_key = NULL,
                   summary = "summary-by-series")
head(sdata)
```

```
##   site_id                    site subsite_id    subsite series_id     series         parameter parameter_id time_coverage_start time_coverage_end      lat      lon depth uncal_obs cal_obs qc_obs
## 1       1 Agincourt Reef Number 3       2687     AG3FL1      2687     AG3FL1 Water Temperature            1          1996-03-30        2008-12-11 -15.9903 145.8212   0.2     23130  110480 110480
## 2       1 Agincourt Reef Number 3      14276  AG3SL1old     14276  AG3SL1old Water Temperature            1          1996-03-30        2010-02-02 -15.9905 145.8213   5.0     81042  183386 183386
## 3       1 Agincourt Reef Number 3      14276  AG3SL1old     14276  AG3SL1old Water Temperature            1          2010-11-30        2011-07-21 -15.9905 145.8213   5.5     33408   33408  33408
## 4       3           Cleveland Bay       3007 CLEVAWSSL1      3007 CLEVAWSSL1 Water Temperature            1          2004-05-13        2008-05-03 -19.1557 146.8813   7.0     11951   53231  53231
## 5       3           Cleveland Bay       3069 CLEVAWSFL1      3069 CLEVAWSFL1 Water Temperature            1          2005-09-15        2005-12-22 -19.1557 146.8813   1.0         0    4656   4656
## 6       4             Davies Reef       2629     DAVFL1      2629     DAVFL1 Water Temperature            1          1997-08-26        2009-12-08 -18.8065 147.6688   1.0     72073  201114 201114
```

Setting the argument `api_key = NULL` means that `dataaimsr` will
automatically search for the user's API key stored in `.Renviron`.
The `summary` argument here is key. It should only be flagged when the
user wants an overview of the available data. Again, this currently
implemented for the Sea Water Temperature Loggers dataset. One can
visualise `summary-by-series` or `summary-by-deployment`. The output of
`aims_data` when summary is `NA` (the default) is a `data.frame`.

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
observations. **Mark, we need a few sentences explaining the quality control**
**procdure**. One can visualise this data, for instance, by plotting them
on a map of Australia, while colouring based on the total amount of calibrated
observations (Fig. \@ref(fig:summary)).



(ref:fig-summary) Distribution of all temperature logger series around Australian waters.

\begin{figure}
\includegraphics[width=1\linewidth]{summary} \caption{(ref:fig-summary)}(\#fig:summary)
\end{figure}

In the case of the Weather Station dataset, the user can call a
the `filter_values` function which allows one to query what
sites, series and parameters are available for both datasets:


```r
weather_doi <- aims_data_doi("weather")
filter_values(weather_doi, filter_name = "series") %>%
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
dataset can filtered by attributes which can be exposed with the function `expose_attributes`:


```r
expose_attributes(weather_doi)
```

```
## $summary
## [1] NA
## 
## $filters
##  [1] "site"      "subsite"   "series"    "series_id" "parameter" "size"      "min_lat"   "max_lat"   "min_lon"   "max_lon"   "from_date" "thru_date" "version"   "cursor"
```

```r
expose_attributes(ssts_doi)
```

```
## $summary
## [1] "summary-by-series"     "summary-by-deployment"
## 
## $filters
##  [1] "site"      "subsite"   "series"    "series_id" "parameter" "size"      "min_lat"   "max_lat"   "min_lon"   "max_lon"   "from_date" "thru_date" "version"   "cursor"
```

The help file (see `?expose_attributes`) contains the details about what
each filter targets. So, having an understanding of the summaries and what
filters are available provide the user with a great head start.

Downloading the data is achieved using the same `aims_data` function, 
however now the `summary` argument is omitted, and instead 
implement filters. For example, to download all the data collected at the
[Yongala wreck][6] for a specific time window:

[6]: https://en.wikipedia.org/wiki/SS_Yongala


```r
wdata_a <- aims_data(weather_doi, api_key = NULL,
                     filters = list(site = "Yongala",
                                    from_date = "2018-01-01",
                                    thru_date = "2018-01-02"))
```

The output of `aims_data` when summary is omitted (the default) is a list
containing three elements:

- `metadata` a doi link containing the metadata record for the data series

- `citation` the citation information for the particular dataset

- `data` an output `data.frame`


```r
wdata_a$metadata
```

```
## [1] "Metadata record https://doi.org/10.25845/5c09bf93f315d"
```


```r
wdata_a$citation
```

```
## [1] "Australian Institute of Marine Science (AIMS). 2009, Australian Institute of Marine Science Automatic Weather Stations, https://doi.org/10.25845/5c09bf93f315d, accessed 11 February 2021.  Time period: 2018-01-01 to 2018-01-02.  Site: Yongala."
```


```r
head(wdata_a$data)
```

```
##   deployment_id    site          subsite depth       lat      lon                      parameter serial_num    data_id                time cal_val  qc_val series_id                                          series
## 1        472564 Yongala Yongala NRS Buoy    NA -19.30372 147.6205 Wind Speed (Scalar avg 10 min)   E0810017 1002524661 2018-01-01 00:00:00 21.8412 21.8412      4103 Yongala NRS Buoy Wind Speed (Scalar avg 10 min)
## 2        472564 Yongala Yongala NRS Buoy    NA -19.30372 147.6205 Wind Speed (Scalar avg 10 min)   E0810017 1002525035 2018-01-01 00:10:00 22.4100 22.4100      4103 Yongala NRS Buoy Wind Speed (Scalar avg 10 min)
## 3        472564 Yongala Yongala NRS Buoy    NA -19.30372 147.6205 Wind Speed (Scalar avg 10 min)   E0810017 1002525436 2018-01-01 00:20:00 22.4496 22.4496      4103 Yongala NRS Buoy Wind Speed (Scalar avg 10 min)
## 4        472564 Yongala Yongala NRS Buoy    NA -19.30372 147.6205 Wind Speed (Scalar avg 10 min)   E0810017 1002525892 2018-01-01 00:30:00 23.1876 23.1876      4103 Yongala NRS Buoy Wind Speed (Scalar avg 10 min)
## 5        472564 Yongala Yongala NRS Buoy    NA -19.30372 147.6205 Wind Speed (Scalar avg 10 min)   E0810017 1002526278 2018-01-01 00:40:00 22.1364 22.1364      4103 Yongala NRS Buoy Wind Speed (Scalar avg 10 min)
## 6        472564 Yongala Yongala NRS Buoy    NA -19.30372 147.6205 Wind Speed (Scalar avg 10 min)   E0810017 1002526524 2018-01-01 00:50:00 22.0104 22.0104      4103 Yongala NRS Buoy Wind Speed (Scalar avg 10 min)
```

Note that there are numerous parameters available for this site at the
specified time:


```r
unique(wdata_a$data$parameter)
```

```
##  [1] "Wind Speed (Scalar avg 10 min)"              "Wind Direction (Scalar Average 10 Minutes)"  "Wind Direction (Scalar Standard 10 Minutes)" "Wind Speed (scalar avg b 10 min) "          
##  [5] "Wind Speed (vector avg 10 min)"              "Wind Direction (Vector Average 10 Minutes)"  "Wind Direction (Vector Standard 10 Minutes)" "Maximum Wind Speed 10 Minutes"              
##  [9] "Minimum Wind Speed 10 Minutes"               "Air Temperature"                             "Humidity"                                    "Air Pressure"                               
## [13] "Rain Duration"                               "Rain Intensity"                              "Wind Speed (Scalar avg 30 min)"              "Wind Direction (Scalar Average 30 Minutes)" 
## [17] "Wind Direction (Scalar Standard 30 Minutes)" "Wind Speed (scalar avg b 30 min)"            "Wind Speed (vector avg 30 min)"              "Wind Direction (Vector Average 30 Minutes)" 
## [21] "Wind Direction (Vector Standard 30 Minutes)" "Maximum Wind Speed 30 Minutes"               "Minimum Wind Speed 30 Minutes"               "Rain Accumulation"                          
## [25] "Water Temperature"                           "Water Pressure"                              "Salinity"                                    "Chlorophyll"                                
## [29] "Turbidity"                                   "Depth"                                       "Dissolved Oxygen (mole)"
```

And the actual measurements are either raw or quality-controlled (Fig. \@ref(fig:wind)).



(ref:fig-wind) Yongala wreck wind speed profiles between the first and second of January 2018.

\begin{figure}
\includegraphics[width=1\linewidth]{wind} \caption{(ref:fig-wind)}(\#fig:wind)
\end{figure}

The filters `from_date` and `thru_date` can be further refined by including a
time window to download the data:


```r
wdata_b <- aims_data(weather_doi,
                     api_key = NULL,
                     filters = list(series_id = 64,
                                    from_date = "1991-10-18T06:00:00",
                                    thru_date = "1991-10-18T12:00:00"))$data
range(wdata_b$time)
```

```
## [1] "1991-10-18 06:00:00 UTC" "1991-10-18 12:00:00 UTC"
```

# Future directions
  
# Acknowledgements

The development of `dataimsr` was supported by ... Names to be added to the list.

# References
