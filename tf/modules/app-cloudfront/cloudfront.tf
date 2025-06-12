locals {
  origin_domain_name = replace(replace(aws_lambda_function_url.this.function_url, "https://", ""), "/", "")
}

data "aws_cloudfront_cache_policy" "default" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = var.name
  description                       = "Allow access to Lambda Function URL"
  origin_access_control_origin_type = "lambda"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  provider = aws.use1

  origin {
    origin_id                = var.name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    domain_name              = local.origin_domain_name

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 5  # default
      origin_read_timeout      = 30 # default
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  # price_class     = "PriceClass_200" ## One of "PriceClass_All", "PriceClass_200", "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.name
    cache_policy_id  = data.aws_cloudfront_cache_policy.default.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 86400
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Name = var.name
  }

  viewer_certificate {
    cloudfront_default_certificate = true

    ## https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html
    # minimum_protocol_version       = "TTLSv1.2_2021"
  }

}
