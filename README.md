
AIMS DataPlatform R Client
==========================

This R package intends to provide easy access to scientific data provided in the AIMS DataPlatform.

The DataPlatform R Client library can be used like this:

```
> library(aimsdataplatform)
> dataFrame <- getData('10.25845/5c09bf93f315d', filters=list("site-name"="Davies Reef"))

```
Or to get all data associated with a request into memory:

```
> dataFrame <- getAllData('10.25845/5c09bf93f315d', filters=list("site-name"="Davies Reef", "size"=10000))
> summary(dataFrame$results)

```

This library depends on `httr` and `jsonlite` and can be installed using R `devtools` like this:

```
> install.packages("devtools")
> devtools::install_git("https://github.com/AIMS/data-platform-r")

```

This library is provided for use under the Creative Commons by Attribution license [here](https://creativecommons.org/licenses/by/3.0/au/legalcode) by the AIMS Datacentre for the [Austrailian Institute of Marine Science](https://www.aim.gov.au)

