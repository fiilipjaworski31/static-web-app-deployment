variable "name_prefix" {
  description = "Prefix for monitoring resource names"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for metrics"
  type        = string
}

variable "waf_web_acl_name" {
  description = "WAF Web ACL name for metrics"
  type        = string
}

# ------------------------------------------------------------------------------
# Region Configuration
# CloudFront metrics are always in us-east-1, WAF metrics depend on scope
# ------------------------------------------------------------------------------
variable "cloudfront_metrics_region" {
  description = "Region for CloudFront metrics (always us-east-1 for global distributions)"
  type        = string
  default     = "us-east-1"
}

variable "waf_metrics_region" {
  description = "Region for WAF metrics (us-east-1 for CloudFront-attached WAF)"
  type        = string
  default     = "us-east-1"
}

# ------------------------------------------------------------------------------
# Dashboard Configuration
# ------------------------------------------------------------------------------
variable "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  type        = string
  default     = ""
}

variable "dashboard_period" {
  description = "Default period in seconds for dashboard widgets"
  type        = number
  default     = 300
}

variable "dashboard_widget_width" {
  description = "Width of dashboard widgets (max 24)"
  type        = number
  default     = 12
}

variable "dashboard_widget_height" {
  description = "Height of dashboard widgets"
  type        = number
  default     = 6
}

# ------------------------------------------------------------------------------
# Alarm Configuration
# ------------------------------------------------------------------------------
variable "alarms_enabled" {
  description = "Enable CloudWatch alarms"
  type        = bool
  default     = true
}

variable "alarm_5xx_threshold" {
  description = "Threshold for 5xx error rate alarm (percentage)"
  type        = number
  default     = 5
}

variable "alarm_4xx_threshold" {
  description = "Threshold for 4xx error rate alarm (percentage)"
  type        = number
  default     = 10
}

variable "alarm_waf_blocked_threshold" {
  description = "Threshold for WAF blocked requests alarm (count per period)"
  type        = number
  default     = 100
}

variable "alarm_evaluation_periods" {
  description = "Number of periods to evaluate for alarm"
  type        = number
  default     = 2
}

variable "alarm_period" {
  description = "Period in seconds for alarm evaluation"
  type        = number
  default     = 300
}

# ------------------------------------------------------------------------------
# SNS Configuration (Optional)
# ------------------------------------------------------------------------------
variable "sns_topic_arn" {
  description = "SNS topic ARN for alarm notifications (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to monitoring resources"
  type        = map(string)
  default     = {}
}