# ------------------------------------------------------------------------------
# Origin Access Control (OAC)
# Ensures S3 only accepts requests signed by CloudFront.
# This is the modern replacement for OAI (Origin Access Identity).
# ------------------------------------------------------------------------------
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-oac"
  description                       = "OAC for ${var.project_name} S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ------------------------------------------------------------------------------
# CloudFront Distribution
# Global CDN for static content delivery with edge caching.
# ------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  http_version        = var.http_version
  default_root_object = var.default_root_object
  price_class         = var.price_class
  web_acl_id          = var.web_acl_arn

  # Origin configuration pointing to S3 bucket
  origin {
    domain_name              = var.bucket_domain_name
    origin_id                = "S3-${var.project_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # Access logging configuration
  dynamic "logging_config" {
    for_each = var.logging_enabled ? [1] : []

    content {
      bucket          = var.logging_bucket
      prefix          = var.logging_prefix
      include_cookies = var.logging_include_cookies
    }
  }

  # Default cache behavior for all requests
  default_cache_behavior {
    target_origin_id       = "S3-${var.project_name}"
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    viewer_protocol_policy = var.viewer_protocol_policy
    compress               = var.compress

    min_ttl     = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Geo restriction settings
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  # SSL/TLS configuration - using default CloudFront certificate
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Custom error responses for user-friendly error pages
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses

    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  tags = var.tags
}