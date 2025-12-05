variable "name_prefix" {
  description = "Prefix for WAF resource names"
  type        = string
}

variable "rate_limit" {
  description = "Maximum requests per 5-minute window per IP address"
  type        = number
  default     = 500
}

variable "rate_limit_action" {
  description = "Action to take when rate limit is exceeded: block or count"
  type        = string
  default     = "block"

  validation {
    condition     = contains(["block", "count"], var.rate_limit_action)
    error_message = "rate_limit_action must be either 'block' or 'count'."
  }
}

variable "default_action" {
  description = "Default action for requests that don't match any rules: allow or block"
  type        = string
  default     = "allow"

  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "default_action must be either 'allow' or 'block'."
  }
}

variable "cloudwatch_metrics_enabled" {
  description = "Enable CloudWatch metrics for WAF"
  type        = bool
  default     = true
}

variable "sampled_requests_enabled" {
  description = "Enable sampling of requests for WAF"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to WAF resources"
  type        = map(string)
  default     = {}
}