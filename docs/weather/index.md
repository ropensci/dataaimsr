AIMS Weather Data Set
=====================

Available query parameters for *AIMS Weather* data set are:

Query Parameter | Parameter Name | Parameter Values
--------------- | -------------- | ----------------
Site name       | site-name      | [List of Sites](sites)
Parameter       | parameter      | [List of Parameters](parameters)
Series          | series         | [List of Series ID and Names](series)
Size            | size           | Integer values
From Date       | from-date      | String in form "YYYY-MM-DD hh:mm:ss"
Through Date    | thru-date      | String in form "YYYY-MM-DD hh:mm:ss"
Min Longitude   | min-longitude  | Longitude Decimal value
Max Longitude   | max-longitude  | Longitude Decimal value
Min Latitude    | min-latitude   | Latitude Decimal value
Max Latitude    | max-latitude   | Latitude Decimal value

Examples usage of data request using query filter parameters with R client:

```

library(aimsdataplatform)
getData('10.25845/5c09bf93f315d', filters=list('site-name'='Davies Reef', 'parameter'='Wind Direction (Scalar Average 10 Minutes)', 'size'=10))

getData('10.25845/5c09bf93f315d', filters=list('site-name'='Square Rocks', 'series'=104939, 'size'=10))

getAllData('10.25845/5c09bf93f315d', filters=list('site-name'='Davies Reef', 'size'=10000)

```
