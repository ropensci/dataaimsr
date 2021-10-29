# dataaimsr 1.1.0

* Added the capacity to download daily aggregated Sea Water Temperature Loggers dataset

# dataaimsr 1.0.3

* Added `aims_*` prefix to all exported functions

* `aims_data`, `aims_filter_values` and `aims_expose_attributes` now take a
string target rather than a string DOI as input argument

* `aims_data` and `aims_filter_values` fail gracefully now if the input
filter parameters are incorrect or there is no internet connection

* `aims_data_doi` is now the non-exported `data_doi`

* Important changes pertaining to `aims_data`:
 - Always returns a data.frame
 - Contains it's own class called `aimsdf` which contains print, summary and plot methods
 - Contains three additional exposed helper functions which allow the user to
 extract metadata/citation/parameter attributes.
 - Example set has been reduced to a minimal amount

* plot method for class `aimsdf` displays either a map or a time series

* improved test coverage

# dataaimsr 1.0.2

* Implemented `summary` datasets for the Temperature Loggers dataset via
`aims_data`

* Implemented `expose_attributes()` to show which filters are accepted
by the different datasets

* restrict `filter_values` to expel info on sites, series and parameters 
only

* Using `parsedate` to standardise date strings and account for time zone

* Created new vignette explaining basic usage of package
