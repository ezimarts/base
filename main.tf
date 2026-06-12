# #API Gateway
# resource "aws_api_gateway_rest_api" "api_gateway" {
#   name        = "ezmart-api-gateway"
#   description = "API Gateway for ezmart application"
# }

# resource "aws_apigatewayv2_api" "http_api" {
#   name          = "ezmart-http-api"
#   protocol_type = "HTTP"
# }

# # CDN
# resource "aws_cloudfront_origin_access_control" "oac" {
#   name                              = "ezmart-oac"
#   description                       = "OAC for EZMart S3 bucket"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }

# resource "aws_cloudfront_distribution" "cdn" {

#   origin {
#     domain_name              = aws_s3_bucket.web.bucket_regional_domain_name
#     origin_id                = "s3Origin"
#     origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
#   }

#   enabled             = true
#   default_root_object = "index.html"

#   default_cache_behavior {
#     allowed_methods = ["GET", "HEAD"]

#     cached_methods = ["GET", "HEAD"]

#     target_origin_id = "s3Origin"

#     viewer_protocol_policy = "redirect-to-https"

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }
# }

