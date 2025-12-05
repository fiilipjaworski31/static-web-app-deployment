variable "bucket_domain_name" {
  description = "Regional domain name of the S3 bucket origin"
  type        = string
}

variable "project_name" {
  description = "Project name used for Origin ID generation"
  type        = string
}

variable "default_root_object" {
  description = "The object to return when the root URL is requested"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront Price Class (PriceClass_All, PriceClass_200, PriceClass_100)"
  type        = string
  default     = "PriceClass_100"
}

variable "web_acl_arn" {
  description = "ARN of WAFv2 Web ACL to associate with the distribution"
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# Cache Behavior Settings
# ------------------------------------------------------------------------------
variable "allowed_methods" {
  description = "HTTP methods CloudFront processes and forwards"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "HTTP methods for which CloudFront caches responses"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  description = "Protocol policy: allow-all, https-only, redirect-to-https"
  type        = string
  default     = "redirect-to-https"
}

variable "min_ttl" {
  description = "Minimum time (seconds) objects stay in cache"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default time (seconds) objects stay in cache"
  type        = number
  default     = 3600
}

variable "max_ttl" {
  description = "Maximum time (seconds) objects stay in cache"
  type        = number
  default     = 86400
}

variable "compress" {
  description = "Enable automatic compression of content"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# Distribution Settings
# ------------------------------------------------------------------------------
variable "enabled" {
  description = "Whether the distribution is enabled"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Enable IPv6 for the distribution"
  type        = bool
  default     = true
}

variable "http_version" {
  description = "Maximum HTTP version: http1.1, http2, http2and3, http3"
  type        = string
  default     = "http2and3"
}

variable "geo_restriction_type" {
  description = "Geo restriction type: none, whitelist, blacklist"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "List of country codes for geo restriction"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to CloudFront resources"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Custom Error Responses
# ------------------------------------------------------------------------------
variable "custom_error_responses" {
  description = "List of custom error response configurations"
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = []
}


# ------------------------------------------------------------------------------
# Logging Configuration
# ------------------------------------------------------------------------------
variable "logging_enabled" {
  description = "Enable access logging for the distribution"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "S3 bucket domain name for storing access logs"
  type        = string
  default     = ""
}

variable "logging_prefix" {
  description = "Prefix for log file names"
  type        = string
  default     = "cloudfront/"
}

variable "logging_include_cookies" {
  description = "Include cookies in access logs"
  type        = bool
  default     = false
}