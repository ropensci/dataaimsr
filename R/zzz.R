.onLoad  <-  function(libname, pkgname) {
  op  <-  options()
  aims_op  <-  list(
    dataaimsr.base_end_point = "https://api.aims.gov.au/data/v1.0",
    dataaimsr.weather = "10.25845/5c09bf93f315d",
    dataaimsr.temp_loggers = "10.25845/5b4eb0f9bb848",
    dataaimsr.date_format = c("10.25845/5c09bf93f315d" = "%Y-%m-%dT%H:%M:%OS",
                              "10.25845/5b4eb0f9bb848" = "%Y-%m-%d %H:%M:%OS")
  )
  toset <- !(names(aims_op) %in% names(op))
  if (any(toset)) {
    options(aims_op[toset])
  }
  invisible()
}
