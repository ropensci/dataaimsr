library(dataaimsr)

test_that("Correct structure", {
  expect_is(expose_attributes(weather_doi), "list")
  expect_is(expose_attributes(ssts_doi), "list")
  expect_error(expose_attributes(wrong_doi))
  expect_error(expose_attributes(10))
  expect_error(expose_attributes(FALSE))
  expect_error(expose_attributes(NA))
  expect_error(expose_attributes(NULL))
})
