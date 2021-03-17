library(dataaimsr)

test_that("Correct structure", {
  expect_is(aims_expose_attributes("weather"), "list")
  expect_is(aims_expose_attributes("temp_loggers"), "list")
  expect_error(aims_expose_attributes("string"))
  expect_error(aims_expose_attributes(10))
  expect_error(aims_expose_attributes(FALSE))
  expect_error(aims_expose_attributes(NA))
  expect_error(aims_expose_attributes(NULL))
})
