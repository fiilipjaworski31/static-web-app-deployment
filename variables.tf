# --- Infrastructure Configuration ---

variable "aws_region" {
  description = "AWS Region where resources will be deployed (e.g., us-east-1)"
  type        = string
}

variable "project_name" {
  description = "Base name of the project used for naming resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
}

# --- Content Configuration ---
# These variables allow to change the website file without touching the code.

variable "website_index_document" {
  description = "Filename of the entry point document (e.g. index.html)"
  type        = string
}

variable "website_content_type" {
  description = "MIME type of the content (e.g. text/html)"
  type        = string
}

variable "website_source_path" {
  description = "Local filesystem path to the source file to upload"
  type        = string
}

# ------------------------------------------------------------------------------
# WAF Configuration
# ------------------------------------------------------------------------------
variable "waf_rate_limit" {
  description = "Maximum requests per 5-minute window per IP (500 = ~100/min)"
  type        = number
  default     = 500
}

# ------------------------------------------------------------------------------
# Error Pages Configuration
# ------------------------------------------------------------------------------
variable "error_pages_dir" {
  description = "Directory containing custom error page HTML files"
  type        = string
  default     = "./error-pages"
}

variable "error_4xx_cache_ttl" {
  description = "Cache TTL in seconds for 4xx error responses"
  type        = number
  default     = 60
}

variable "error_5xx_cache_ttl" {
  description = "Cache TTL in seconds for 5xx error responses"
  type        = number
  default     = 30
}

# ------------------------------------------------------------------------------
# Logging Configuration
# ------------------------------------------------------------------------------
variable "logging_retention_days" {
  description = "Number of days to retain CloudFront access logs"
  type        = number
  default     = 30
}

variable "logging_prefix" {
  description = "Prefix for CloudFront log files in S3"
  type        = string
  default     = "cloudfront/"
}


# ------------------------------------------------------------------------------
# Monitoring Configuration
# ------------------------------------------------------------------------------
variable "monitoring_alarms_enabled" {
  description = "Enable CloudWatch alarms for monitoring"
  type        = bool
  default     = true
}

variable "alarm_5xx_threshold" {
  description = "Threshold percentage for 5xx error rate alarm"
  type        = number
  default     = 5
}

variable "alarm_4xx_threshold" {
  description = "Threshold percentage for 4xx error rate alarm"
  type        = number
  default     = 10
}