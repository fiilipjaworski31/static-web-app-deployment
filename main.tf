# ------------------------------------------------------------------------------
# WAF MODULE
# Creates rate-limiting protection for the CloudFront distribution.
# ------------------------------------------------------------------------------
module "waf" {
  source = "./modules/waf"

  name_prefix = local.full_project_name
  rate_limit  = var.waf_rate_limit

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# LOGGING MODULE
# Creates S3 bucket for CloudFront access logs with lifecycle policies.
# ------------------------------------------------------------------------------
module "logging" {
  source = "./modules/logging"

  bucket_name        = "${local.full_project_name}-logs"
  force_destroy      = var.environment == "prod" ? false : true
  log_retention_days = var.logging_retention_days
  versioning_enabled = var.environment == "prod" ? true : false

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# S3 MODULE
# Creates the storage layer for static website files and error pages.
# ------------------------------------------------------------------------------
module "s3_website" {
  source = "./modules/s3"

  bucket_name    = "${local.full_project_name}-assets"
  cloudfront_arn = module.cloudfront.distribution_arn
  force_destroy  = var.environment == "prod" ? false : true

  # Main website content
  index_document   = var.website_index_document
  content_type     = var.website_content_type
  source_file_path = var.website_source_path

  # Error pages
  error_pages = {
    "404.html" = "${var.error_pages_dir}/404.html"
    "500.html" = "${var.error_pages_dir}/500.html"
  }

  # Security settings
  versioning_enabled = var.environment == "prod" ? true : false

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# CLOUDFRONT MODULE
# Creates the CDN layer for global distribution, caching, and security.
# ------------------------------------------------------------------------------
module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_domain_name  = module.s3_website.bucket_regional_domain_name
  project_name        = local.full_project_name
  default_root_object = var.website_index_document
  price_class         = var.environment == "prod" ? "PriceClass_All" : "PriceClass_100"

  # WAF integration
  web_acl_arn = module.waf.web_acl_arn

  # Logging configuration
  logging_enabled = true
  logging_bucket  = module.logging.bucket_domain_name
  logging_prefix  = var.logging_prefix

  # Custom error pages
  custom_error_responses = [
    {
      error_code            = 403
      response_code         = 404
      response_page_path    = "/error-pages/404.html"
      error_caching_min_ttl = var.error_4xx_cache_ttl
    },
    {
      error_code            = 404
      response_code         = 404
      response_page_path    = "/error-pages/404.html"
      error_caching_min_ttl = var.error_4xx_cache_ttl
    },
    {
      error_code            = 500
      response_code         = 500
      response_page_path    = "/error-pages/500.html"
      error_caching_min_ttl = var.error_5xx_cache_ttl
    },
    {
      error_code            = 502
      response_code         = 502
      response_page_path    = "/error-pages/500.html"
      error_caching_min_ttl = var.error_5xx_cache_ttl
    },
    {
      error_code            = 503
      response_code         = 503
      response_page_path    = "/error-pages/500.html"
      error_caching_min_ttl = var.error_5xx_cache_ttl
    },
    {
      error_code            = 504
      response_code         = 504
      response_page_path    = "/error-pages/500.html"
      error_caching_min_ttl = var.error_5xx_cache_ttl
    }
  ]

  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# MONITORING MODULE
# Creates CloudWatch dashboard and alarms for observability.
# ------------------------------------------------------------------------------
module "monitoring" {
  source = "./modules/monitoring"

  name_prefix                = local.full_project_name
  cloudfront_distribution_id = module.cloudfront.distribution_id
  waf_web_acl_name           = module.waf.web_acl_name

  # Alarm configuration
  alarms_enabled      = var.monitoring_alarms_enabled
  alarm_5xx_threshold = var.alarm_5xx_threshold
  alarm_4xx_threshold = var.alarm_4xx_threshold

  tags = local.common_tags
}