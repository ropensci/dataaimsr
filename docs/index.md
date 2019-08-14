
AIMS DataPlatform R Client
==========================

__AIMS DataPlatform R Client__ will provide easy access to data sets for R applications to the __AIMS DataPlatform API__.

Installation
------------

Details on installation of __AIMS DataPlatform R Client__ are [here](install).

Usage
-----

The __AIMS DataPlatform API__ is a *REST API* providing *JSON* formatted data.  The __AIMS DataPlatform API__ should be queried using the Digital Object Identifier ([DOI](https://doi.org)) of the desired data set.  At this time available data sets are:

Data Set                 | DOI                    | Documentation                                   | Resolve DOI
-------------------------|------------------------|-------------------------------------------------|-------------------------------------------------------------------------
AIMS Weather             | 10.25845/5c09bf93f315d | [AIMS Weather](weather)                         | [AIMS Weather](https://doi.org/10.25845/5c09bf93f315d){:target="_blank"}
AIMS Temperature Loggers | 10.25845/5b4eb0f9bb848 | [AIMS Temperature Loggers](temperature-loggers) | [AIMS Temperature Loggers](https://doi.org/10.25845/5b4eb0f9bb848){:target="_blank"}

Examples usage of data request using query filter parameters with R client:

```

library(aimsdataplatform)
getData('10.25845/5c09bf93f315d', filters=list('site-name'='Davies Reef', 'parameter'='Wind Direction (Scalar Average 10 Minutes)', 'size'=10))

getData('10.25845/5c09bf93f315d', filters=list('site-name'='Square Rocks', 'series'=104939, 'size'=10))

getAllData('10.25845/5c09bf93f315d', filters=list('site-name'='Davies Reef', 'size'=10000)

```
