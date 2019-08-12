
AIMS DataPlatform R Client
==========================

__AIMS DataPlatform R Client__ will provide easy access to datasets for R applications to the __AIMS DataPlatform API__.  The __AIMS DataPlatform API__ is a *REST API* providing *JSON* formatted data.  The _AIMS DataPlatform API__ should be queried using the [DOI](https://doi.org) of the desired data set.  At this time available datasets are:

Data Set     | DOI
------------ | ----------------------
Weather Data | 10.25845/5c09bf93f315d

Available query parameters for *Weather* data set are:

Query Parameter | Parameter Name | Parameter Values
--------------- | -------------- | ----------------
Site name       | site-name      | [List of Sites](sites)
Parameter       | parameter      | [List of Parameters](parameters)
Series          | series         | [List of Series ID and Names](series)
Size            | size           | Integer values

Examples of R filters:

```

library(aimsdataplatform)
getData('10.25845/5c09bf93f315d', filters=list('site-name'='Davies Reef', 'parameter'='Wind Direction (Scalar Average 10 Minutes)', 'size'=10))

getData('10.25845/5c09bf93f315d', filters=list('site-name'='Square Rocks', 'series'=104939, 'size'=10))

```
