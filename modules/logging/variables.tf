variable "bucket_name" {
  description = "Name of the logging bucket"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even when not empty"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# Lifecycle Configuration
# ------------------------------------------------------------------------------
variable "log_retention_days" {
  description = "Number of days to retain logs before expiration"
  type        = number
  default     = 30
}

variable "transition_to_ia_days" {
  description = "Days before transitioning logs to Infrequent Access storage (0 to disable)"
  type        = number
  default     = 0
}

# ------------------------------------------------------------------------------
# Encryption Configuration
# ------------------------------------------------------------------------------
variable "sse_algorithm" {
  description = "Server-side encryption algorithm: AES256 or aws:kms"
  type        = string
  default     = "AES256"
}

# ------------------------------------------------------------------------------
# Versioning
# ------------------------------------------------------------------------------
variable "versioning_enabled" {
  description = "Enable versioning for the logging bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to logging resources"
  type        = map(string)
  default     = {}
}