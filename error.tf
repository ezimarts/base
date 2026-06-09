custom_error_response {
  error_code            = 403
  response_code         = 404
  response_page_path    = "/error.html"
  error_caching_min_ttl = 60
}

custom_error_response {
  error_code            = 404
  response_code         = 404
  response_page_path    = "/error.html"
  error_caching_min_ttl = 60
}