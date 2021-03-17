library(dataaimsr)

test_that("Correct structure", {
  expect_is(expose_attributes("weather"), "list")
  expect_is(expose_attributes("temp_loggers"), "list")
  expect_error(expose_attributes("string"))
  expect_error(expose_attributes(10))
  expect_error(expose_attributes(FALSE))
  expect_error(expose_attributes(NA))
  expect_error(expose_attributes(NULL))
})
