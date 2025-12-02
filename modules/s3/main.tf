# 1. S3 Bucket Resource
# Stores the static files. 'force_destroy' is variable-driven for safety.
resource "aws_s3_bucket" "website_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = var.tags
}

# 2. Public Access Block
# SECURITY: Enforces "Secure by Default". 
# Blocks all direct public access to S3. Access is only allowed via CloudFront.
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# 3. S3 Object (File Upload)
# Uploads the website content. Uses filemd5 to detect changes and avoid unnecessary uploads.
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = var.index_document       # Dynamic key (e.g. "index.html")
  source       = var.source_file_path     # Dynamic source path
  content_type = var.content_type         # Dynamic MIME type
  
  # Triggers update only if the file content changes on disk
  etag         = filemd5(var.source_file_path)
  
  tags         = var.tags
}

# 4. IAM Policy Document (Logic)
# Generates the JSON policy dynamically. 
# Decouples the policy logic from the resource attachment.
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

    # CONDITION: Only allow access from our specific CloudFront Distribution (OAC)
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_arn]
    }
  }
}

# 5. Attach Policy
# Applies the generated JSON policy to the bucket.
resource "aws_s3_bucket_policy" "attach_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.allow_cloudfront_oac.json
}