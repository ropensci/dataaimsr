httptest::set_requester(function(request) {
  httptest::gsub_request(
    request, "https://api.aims.gov.au/data-v2.0/10.25845/", "a/", fixed = TRUE
  )
})
