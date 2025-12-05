variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "cloudfront_arn" {
  description = "ARN of the CloudFront distribution for bucket policy"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even when not empty (use with caution)"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# Public Access Block Settings
# All default to true for security - override only if necessary
# ------------------------------------------------------------------------------
variable "block_public_acls" {
  description = "Block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies"
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# Content Configuration
# ------------------------------------------------------------------------------
variable "index_document" {
  description = "Name of the index document (e.g., index.html)"
  type        = string
}

variable "content_type" {
  description = "MIME type of the content"
  type        = string
}

variable "source_file_path" {
  description = "Local path to the source file to upload"
  type        = string
}

# ------------------------------------------------------------------------------
# Versioning & Encryption
# ------------------------------------------------------------------------------
variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm: AES256 or aws:kms"
  type        = string
  default     = "AES256"
}

variable "tags" {
  description = "Tags to apply to S3 resources"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Error Pages Configuration
# ------------------------------------------------------------------------------
variable "error_pages" {
  description = "Map of error pages to upload. Key is filename, value is local path"
  type        = map(string)
  default     = {}
}

variable "error_pages_content_type" {
  description = "MIME type for error pages"
  type        = string
  default     = "text/html"
}