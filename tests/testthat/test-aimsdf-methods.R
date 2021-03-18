library(dataaimsr)

# regular monitoring data
check_wa <- aims_data("weather", filters = w_filters, api_key = my_api_key)
check_sa <- aims_data("temp_loggers", filters = s_filters,
                      api_key = my_api_key)
# summary data
sdf_s <- aims_data("temp_loggers", api_key = my_api_key,
                   summary = "summary-by-series")
sdf_d <- aims_data("temp_loggers", api_key = my_api_key,
                   summary = "summary-by-deployment")

test_that("Correct structure", {
  expect_output(expect_is(summary(check_wa), "list"))
  expect_output(expect_is(summary(check_sa), "list"))
  expect_output(expect_is(summary(sdf_s), "list"))
  expect_output(expect_is(summary(sdf_d), "list"))
})

test_that("Correct structure", {
  expect_output(print(check_wa))
  expect_output(print(check_sa))
  expect_output(print(sdf_s))
  expect_output(print(sdf_d))
  expect_s3_class(head(check_wa), "aimsdf")
  expect_is(head(check_wa), "data.frame")
  expect_s3_class(head(check_sa), "aimsdf")
  expect_is(head(check_sa), "data.frame")
  expect_s3_class(head(sdf_s), "aimsdf")
  expect_is(head(sdf_s), "data.frame")
  expect_s3_class(head(sdf_d), "aimsdf")
  expect_is(head(sdf_d), "data.frame")
  expect_s3_class(tail(check_wa), "aimsdf")
  expect_is(tail(check_wa), "data.frame")
  expect_s3_class(tail(check_sa), "aimsdf")
  expect_is(tail(check_sa), "data.frame")
  expect_s3_class(tail(sdf_s), "aimsdf")
  expect_is(tail(sdf_s), "data.frame")
  expect_s3_class(tail(sdf_d), "aimsdf")
  expect_is(tail(sdf_d), "data.frame")
})

a_ <- plot(check_wa, ptype = "map")
b_ <- plot(check_wa, ptype = "time_series")
c_ <- plot(sdf_s, ptype = "map")
d_ <- plot(sdf_d, ptype = "time_series")

test_that("Correct structure", {
  expect_error(plot(check_wa))
  expect_error(plot(check_sa))
  expect_error(plot(sdf_s))
  expect_error(plot(sdf_d))
  expect_visible(plot(check_wa, ptype = "map"))
  expect_message(expect_visible(plot(check_wa, ptype = "time_series")))
  expect_visible(plot(check_wa, ptype = "time_series",
                      pars = "Air Temperature"))
  expect_visible(plot(check_sa, ptype = "map"))
  expect_message(expect_visible(plot(check_sa, ptype = "time_series")))
  expect_visible(plot(check_sa, ptype = "time_series",
                      pars = "Air Temperature"))
  expect_visible(plot(sdf_s, ptype = "map"))
  expect_visible(plot(sdf_d, ptype = "map"))
  expect_message(expect_visible(plot(sdf_s, ptype = "time_series")))
  expect_message(expect_visible(plot(sdf_d, ptype = "time_series")))
  expect_is(a_, "ggplot")
  expect_is(b_, "ggplot")
  expect_is(c_, "ggplot")
  expect_is(d_, "ggplot")
})
