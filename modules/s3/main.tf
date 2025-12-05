# ------------------------------------------------------------------------------
# S3 Bucket
# Primary storage for static website files.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "website_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Versioning Configuration
# Enables object versioning for rollback capability.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.website_bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# ------------------------------------------------------------------------------
# Server-Side Encryption
# Encrypts objects at rest using specified algorithm.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

# ------------------------------------------------------------------------------
# Public Access Block
# SECURITY: Blocks all public access - content served only via CloudFront.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# ------------------------------------------------------------------------------
# Index Document Upload
# Uploads the main website file with change detection via etag.
# ------------------------------------------------------------------------------
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = var.index_document
  source       = var.source_file_path
  content_type = var.content_type
  etag         = filemd5(var.source_file_path)

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Error Pages Upload
# Uploads custom error pages for CloudFront error responses.
# ------------------------------------------------------------------------------
resource "aws_s3_object" "error_pages" {
  for_each = var.error_pages

  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error-pages/${each.key}"
  source       = each.value
  content_type = var.error_pages_content_type
  etag         = filemd5(each.value)

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Bucket Policy
# Allows CloudFront OAC to read objects from this bucket.
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "allow_cloudfront_oac" {
  statement {
    sid       = "AllowCloudFrontServicePrincipal"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_arn]
    }
  }
}

# Applies the generated JSON policy to the bucket.
resource "aws_s3_bucket_policy" "attach_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.allow_cloudfront_oac.json

  # Ensure public access block is configured before applying policy
  depends_on = [aws_s3_bucket_public_access_block.block_public]
}