# ------------------------------------------------------------------------------
# CloudFront Logging Bucket
# Stores access logs from CloudFront distribution.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "logging" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Bucket Ownership Controls
# Required for CloudFront to write logs using ACLs.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_ownership_controls" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ------------------------------------------------------------------------------
# Bucket ACL
# Grants CloudFront permission to write logs.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_acl" "logging" {
  bucket = aws_s3_bucket.logging.id
  acl    = "log-delivery-write"

  depends_on = [aws_s3_bucket_ownership_controls.logging]
}

# ------------------------------------------------------------------------------
# Versioning Configuration
# Enables object versioning for audit trail.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_versioning" "logging" {
  bucket = aws_s3_bucket.logging.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# ------------------------------------------------------------------------------
# Server-Side Encryption
# Encrypts logs at rest.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

# ------------------------------------------------------------------------------
# Public Access Block
# SECURITY: Ensures logs are never publicly accessible.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ------------------------------------------------------------------------------
# Lifecycle Rules
# Automatically expires old logs to control storage costs.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    filter {
      prefix = ""
    }

    # Optional: Transition to cheaper storage class
    dynamic "transition" {
      for_each = var.transition_to_ia_days > 0 ? [1] : []

      content {
        days          = var.transition_to_ia_days
        storage_class = "STANDARD_IA"
      }
    }

    expiration {
      days = var.log_retention_days
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}