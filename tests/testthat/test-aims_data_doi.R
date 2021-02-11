library(dataaimsr)

test_that("Correct structure", {
  expect_identical(aims_data_doi("weather"), "10.25845/5c09bf93f315d")
  expect_identical(aims_data_doi("temp_loggers"), "10.25845/5b4eb0f9bb848")
  expect_error(aims_data_doi(wrong_doi))
  expect_error(aims_data_doi(FALSE))
  expect_error(aims_data_doi(NA))
  expect_error(aims_data_doi(NULL))
})
