variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "cloudfront_arn" {
  description = "ARN of the CloudFront distribution"
  type        = string
}

variable "tags" {
  description = "Tag map"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Force destroy bucket"
  type        = bool
  default     = false
}

# --- Content ---
variable "index_document" { type = string }
variable "content_type" { type = string }
variable "source_file_path" { type = string }

# --- Public Access (defaults added!) ---
variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}