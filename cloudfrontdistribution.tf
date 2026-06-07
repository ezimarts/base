resource "aws_cloudfront_distribution" "cdn" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id   = "s3-origin"
  }
  
default_cache_behavior {
  target_origin_id       = "s3-origin"
  viewer_protocol_policy = "redirect-to-https"

  allowed_methods = ["GET", "HEAD"]
  cached_methods  = ["GET", "HEAD"]

  cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
}

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}