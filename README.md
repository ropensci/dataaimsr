<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/logo.png" width = 200 alt="dataaimsr Logo"/>

<!-- badges: start -->

[![R build
status](https://github.com/AIMS/data-platform-r/workflows/R-CMD-check/badge.svg)](https://github.com/AIMS/data-platform-r/actions)
<!-- badges: end -->

AIMS Data Platform R Client
===========================

**AIMS Data Platform R Client** will provide easy access to data sets
for R applications to the [AIMS Data Platform
API](https://aims.github.io/data-platform).

Usage of AIMS Data Platform API Key
-----------------------------------

**AIMS Data Platform** requires an API Key for requests, [get a key
here.](https://aims.github.io/data-platform/key-request)

The API Key can be passed to the package functions as an additional
`api_key = 'XXXX'` argument, however it is preferred that API Keys are
not stored in code.

If the environment variable `AIMS_DATAPLATFORM_API_KEY` is stored in the
user’s `.Renviron` file then that will be loaded and used automatically.
In that case the users `.Renviron` file might look like:

    AIMS_DATAPLATFORM_API_KEY=XXXXXXXXXXXXX

The `.Renviron` file is usually stored in each users home directory.

### Possible .Renviron file locations

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
<td><code>C:\Users\&lt;username&gt;\.Renviron</code> or <code>C:\Users\&lt;username&gt;\Documents\.Renviron</code></td>
</tr>
<tr class="even">
<td>Linux / MacOs</td>
<td><code>/home/&lt;username&gt;/.Renviron</code></td>
</tr>
</tbody>
</table>

Installation
------------

At this stage **AIMS Data Platform R Client** is not hosted on CRAN R
package network. An alternative method of installation is to use the R
`devtools` package.

R `devtools` can be installed using the following command:

    install.packages("devtools")

After `devtools` has been installed the **AIMS Data Platform R Client**
can be installed directly from GitHub using the following command:

    devtools::install_github("https://github.com/AIMS/data-platform-r")

This command will also install 2 dependencies `httr` and `jsonlite`.

Available Data Sets
-------------------

The **AIMS Data Platform API** is a *REST API* providing *JSON*
formatted data. Documentation about available data sets can be found on
the [AIMS Data Platfom API](https://aims.github.io/data-platform).

Further Information
-------------------

Further information about the **AIMS DataPlatform R Client** and **AIMS
DataPlatform API** can be seen on the [project
page](https://aims.github.io/data-platform-r).

This library is provided for use under the Creative Commons by
Attribution license ([CC BY
3.0](https://creativecommons.org/licenses/by/3.0/au/legalcode)) by the
AIMS Datacentre for the [Austrailian Institute of Marine
Science](https://www.aims.gov.au)
