<!-- README.md is generated from README.Rmd. Please edit that file -->

dataaimsr <img src="man/figures/logo.png" width = 180 alt="dataaimsr Logo" align="right" />
===========================================================================================

<!-- badges: start -->

[![](https://badges.ropensci.org/428_status.svg)](https://github.com/ropensci/software-review/issues/428)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![R build
status](https://github.com/open-AIMS/dataaimsr/workflows/R-CMD-check/badge.svg)](https://github.com/open-AIMS/dataaimsr/actions)
[![Codecov test
coverage](https://codecov.io/gh/open-AIMS/dataaimsr/branch/master/graph/badge.svg)](https://codecov.io/gh/open-AIMS/dataaimsr?branch=master)
![pkgdown](https://github.com/open-AIMS/dataaimsr/workflows/pkgdown/badge.svg)
[![license](https://img.shields.io/badge/license-MIT%20+%20file%20LICENSE-lightgrey.svg)](https://choosealicense.com/)
[![packageversion](https://img.shields.io/badge/Package%20version-1.0.2-orange.svg)](commits/master)
[![Ask Us Anything
!](https://img.shields.io/badge/Ask%20us-anything-1abc9c.svg)](https://github.com/open-AIMS/dataaimsr/issues/new)
![Open Source
Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)
<!-- badges: end -->

Overview
--------

The Australian Institute of Marine Science (AIMS) has a long tradition
in measuring and monitoring a series of environmental parameters along
the tropical coast of Australia. These parameters include long-term
record of sea surface temperature, wind characteristics, atmospheric
temperature, pressure, chlorophyll-a data, among many others. The AIMS
Data Centre team has recently developed the [AIMS Data Platform
API](https://open-aims.github.io/data-platform/) which is a *REST API*
providing JSON-formatted data to users. `dataaimsr` is an **R package**
written to allow users to communicate with the AIMS Data Platform API
using an API key and a few convenience functions to interrogate and
understand the datasets that are available to download.

Currently, there are two AIMS long-term monitoring datasets available to
be downloaded through `dataaimsr`:

### Northern Australia Automated Marine Weather And Oceanographic Stations

Automatic weather stations have been deployed by AIMS since 1980. Most
of the stations are along the Great Barrier Reef (GBR) including the
Torres Strait in North-Eastern Australia but there is also a station in
Darwin and one at Ningaloo Reef in Western Australia. Many of the
stations are located on the reef itself either on poles located in the
reef lagoon or on tourist pontoons or other structures. A list of the
weather stations which have been deployed by AIMS and the period of time
for which data may be available can be found on the
[metadata](https://apps.aims.gov.au/metadata/view/0887cb5b-b443-4e08-a169-038208109466)
webpage. **NB:** Records may not be continuous for the time spans given.

### AIMS Sea Water Temperature Observing System (AIMS Temperature Logger Program)

The data provided here are from a number of sea water temperature
monitoring programs conducted in tropical and subtropical coral reefs
environments around Australia. Data are available from approximately 80
GBR sites, 16 Coral Sea sites, 7 sites in North West Western Australia
(WA), 8 Queensland regional ports, 13 sites in the Solitary Islands, 4
sites in Papua New Guinea and 10 sites in the Cocos (Keeling) Islands.
Data are obtained from in-situ data loggers deployed on the reef.
Temperature instruments sample water temperatures every 5-10 minutes
(typically) and are exchanged and downloaded approximately every 12
months. Temperature loggers on the reef-flat are generally placed just
below Lowest Astronomical Tide level. Reef-slope (or where specified as
Upper reef-slope) generally refers to depths 5–9 m while Deep reef-slope
refers to depths of ~20 m. For more information on the dataset and its
usage, please visit the
[metadata](https://apps.aims.gov.au/metadata/view/4a12a8c0-c573-11dc-b99b-00008a07204e)
webpage.

Requesting an AIMS Data Platform API Key
----------------------------------------

**AIMS Data Platform** requires an API Key for data requests, [get a key
here](https://open-AIMS.github.io/data-platform/key-request).

The API Key can be passed to the package functions as an additional
`api_key = "XXXX"` argument. alternatively, the environment variable
`AIMS_DATAPLATFORM_API_KEY` can be stored in the user’s `.Renviron` file
for automatic loading at the start of an R session. In that case the
users can modify their `.Renviron` file by adding the following line:

    AIMS_DATAPLATFORM_API_KEY=XXXXXXXXXXXXX

The `.Renviron` file is usually stored in each users home directory:

<table>
<colgroup>
<col style="width: 35%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr class="header">
<th>System</th>
<th>.Renviron file locations</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>MS Windows</td>
<td><code>C:\Users\‹username›\.Renviron</code> or <code>C:\Users\‹username›\Documents\.Renviron</code></td>
</tr>
<tr class="even">
<td>Linux / MacOs</td>
<td><code>/home/‹username›/.Renviron</code></td>
</tr>
</tbody>
</table>

Installation
------------

At this stage `dataaimsr` is not hosted on CRAN R package network. An
alternative method of installation is to use the R `remotes` package.

R `remotes` can be installed using the following command:

    install.packages("remotes")

After `remotes` has been installed `dataaimsr` can be installed directly
from GitHub using the following command:

    remotes::install_github("https://github.com/open-AIMS/dataaimsr")

This command will also install the three package dependencies: `httr`,
`jsonlite` and `parsedate`.

Usage
-----

Examples about how to navigate `dataaimsr` and interrogate the datasets
can be found on our [online
vignettes](https://open-AIMS.github.io/dataaimsr/articles).

License
-------

`dataaimsr` is provided by the [Australian Institute of Marine
Science](https://www.aims.gov.au) under the MIT License
([MIT](http://opensource.org/licenses/MIT)).

AIMS R package logos
--------------------

Our R package logos use a watercolour map of Australia, obtained with
the [ggmap](https://CRAN.R-project.org/package=ggmap) R package, which
downloads original map tiles provided by [Stamen
Design](http://stamen.com), under [CC BY
3.0](http://creativecommons.org/licenses/by/3.0), with data from
[OpenStreetMap](http://openstreetmap.org), under [CC BY
SA](http://creativecommons.org/licenses/by-sa/3.0).
