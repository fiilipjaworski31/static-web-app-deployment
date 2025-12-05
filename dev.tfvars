project_name = "static-web"
environment  = "dev"
aws_region   = "us-east-1"

# Content Configuration for Development
website_index_document = "index.html"
website_content_type   = "text/html"
website_source_path    = "./index.html"

# WAF Configuration
waf_rate_limit = 500

# Error Pages
error_pages_dir     = "./error-pages"
error_4xx_cache_ttl = 60
error_5xx_cache_ttl = 30

# Logging Configuration
logging_retention_days = 30
logging_prefix         = "cloudfront/"

# Monitoring Configuration
monitoring_alarms_enabled = true
alarm_5xx_threshold       = 5
alarm_4xx_threshold       = 10