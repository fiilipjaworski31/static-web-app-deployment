# ------------------------------------------------------------------------------
# AWS WAFv2 Web ACL for CloudFront
# Provides rate-based protection against DDoS and brute-force attacks.
# IMPORTANT: CloudFront WAF must be created in us-east-1 region.
# ------------------------------------------------------------------------------

resource "aws_wafv2_web_acl" "cloudfront_waf" {
  name        = "${var.name_prefix}-web-acl"
  description = "WAF Web ACL with rate limiting for CloudFront distribution"
  scope       = "CLOUDFRONT"

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  rule {
    name     = "${var.name_prefix}-rate-limit-rule"
    priority = 1

    action {
      dynamic "block" {
        for_each = var.rate_limit_action == "block" ? [1] : []
        content {}
      }
      dynamic "count" {
        for_each = var.rate_limit_action == "count" ? [1] : []
        content {}
      }
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
      metric_name                = "${var.name_prefix}-rate-limit-metric"
      sampled_requests_enabled   = var.sampled_requests_enabled
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = "${var.name_prefix}-web-acl-metric"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  tags = var.tags
}