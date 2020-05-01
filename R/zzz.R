.onLoad  <-  function(libname, pkgname) {
  op  <-  options()
  aims_op  <-  list(
    aimsdataplatform.base_end_point = "https://api.aims.gov.au/data/v1.0",
    aimsdataplatform.date_format = "%Y-%m-%dT%H:%M:%OS",
    aimsdataplatform.weather = "10.25845/5c09bf93f315d",
    aimsdataplatform.temp_loggers = "10.25845/5b4eb0f9bb848"
  )
  toset <- !(names(aims_op) %in% names(op))
  if (any(toset)) {
    options(aims_op[toset])
  }
  invisible()
}
