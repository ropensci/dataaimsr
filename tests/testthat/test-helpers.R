library(dataaimsr)

test_that("API key finder", {
  expect_error(find_api_key())
  expect_is(find_api_key(my_api_key), "character")
  Sys.setenv(AIMS_DATAPLATFORM_API_KEY = "empty")
  expect_is(find_api_key(NULL), "character")
  expect_identical(find_api_key(NULL), "empty")
})
