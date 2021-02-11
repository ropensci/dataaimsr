<!-- README.md is generated from README.Rmd. Please edit that file -->

dataaimsr <img src="man/figures/logo.png" width = 180 alt="dataaimsr Logo" align="right" />
===========================================================================================

<!-- badges: start -->

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

`dataaimsr` is the **AIMS Data Platform R package**, and will provide
you with easy access to data sets from the [AIMS Data Platform
API](https://open-AIMS.github.io/data-platform).

Usage of AIMS Data Platform API Key
-----------------------------------

**AIMS Data Platform** requires an API Key for requests, [get a key
here.](https://open-AIMS.github.io/data-platform/key-request)

The API Key can be passed to the package functions as an additional
`api_key = "XXXX"` argument, however it is preferred that API Keys are
not stored permanently in your machine.

If the environment variable `AIMS_DATAPLATFORM_API_KEY` is stored in the
user’s `.Renviron` file then that will be loaded and used automatically.
In that case the users `.Renviron` file might look like:

    AIMS_DATAPLATFORM_API_KEY=XXXXXXXXXXXXX

The `.Renviron` file is usually stored in each users home directory.

Possible .Renviron file locations
---------------------------------

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
alternative method of installation is to use the R `devtools` package.

R `devtools` can be installed using the following command:

    install.packages("devtools")

After `devtools` has been installed `dataaimsr` can be installed
directly from GitHub using the following command:

    devtools::install_github("https://github.com/open-AIMS/dataaimsr")

This command will also install 2 dependencies `httr` and `jsonlite`.

Available Data Sets
-------------------

The **AIMS Data Platform API** is a *REST API* providing *JSON*
formatted data. Documentation about available data sets can be found on
the [AIMS Data Platform API](https://open-AIMS.github.io/data-platform).

Further Information
-------------------

Further information about `dataaimsr` and the **AIMS Data Platform API**
can be seen on the [project
page](https://open-AIMS.github.io/dataaimsr).

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
