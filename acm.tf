provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.us_east_1
  domain_name       = "ezimarts.com"
  subject_alternative_names = [
    "www.ezimarts.com"
  ]

  validation_method = "DNS"
}