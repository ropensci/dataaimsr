.onLoad  <-  function(libname, pkgname) {
  op  <-  options()
  aims_op  <-  list(
    dataaimsr.base_end_point = "https://api.aims.gov.au/data/v1.0",
    dataaimsr.date_format = "%Y-%m-%dT%H:%M:%OS",
    dataaimsr.weather = "10.25845/5c09bf93f315d",
    dataaimsr.temp_loggers = "10.25845/5b4eb0f9bb848"
  )
  toset <- !(names(aims_op) %in% names(op))
  if (any(toset)) {
    options(aims_op[toset])
  }
  invisible()
}
