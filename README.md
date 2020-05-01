<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="inst/figures/logo.png" width = 200 alt="dataaimsr Logo"/>

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

If the environment variable `AIMS_DATA_PLATFORM_API_KEY` is stored in
the user’s `.Renviron` file then that will be loaded and used
automatically. In that case the users `.Renviron` file might look like:

    AIMS_DATAPLATFORM_API_KEY=XXXXXXXXXXXXX

The `.Renviron` file is usually stored in each users home directory.

### Possible .Renviron file locations

| System     | .Renviron file locations                                                     |
|------------|------------------------------------------------------------------------------|
| MS Windows | `C:\Users\<username>\.Renviron` or `C:\Users\<username>\Documents\.Renviron` |
| Linux      | `/home/<username>/.Renviron`                                                 |

Installation
------------

At this stage **AIMS Data Platform R Client** is not hosted on CRAN R
package network. An alternative method of installation is to use the R
`devtools` package.

R `devtools` can be installed using the following command:

    install.packages("devtools")

After `devtools` has been installed the **AIMS Data Platform R Client**
can be installed directly from GitHub using the following command:

    devtools::install_git("https://github.com/AIMS/data-platform-r")

This command will also install 2 dependencies `httr` and `jsonlite`.

Available Data Sets
-------------------

The **AIMS Data Platform API** is a *REST API* providing *JSON*
formatted data. Documentation about available data sets can be found on
the [AIMS Data Platfom API](https://aims.github.io/data-platform).

Detailed Example
----------------

[A more detailed example of the R package usage on the weather dataset
page.](10.25845/5c09bf93f315d/example-1.nb.html) This is an
[RStudio](https://www.rstudio.com/) Notebook and can be used
interactively from [RStudio](https://www.rstudio.com/). **Note that you
need to have an AIMS Data Platform API Key available to run this
detailed example.**

Further information about the **AIMS DataPlatform R Client** and **AIMS
DataPlatform API** can be seen on the [project
page](https://aims.github.io/data-platform-r).

This library is provided for use under the Creative Commons by
Attribution license ([CC BY
3.0](https://creativecommons.org/licenses/by/3.0/au/legalcode)) by the
AIMS Datacentre for the [Austrailian Institute of Marine
Science](https://www.aims.gov.au)
