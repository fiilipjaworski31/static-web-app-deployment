# ------------------------------------------------------------------------------
# S3 MODULE CALL
# Creates the storage layer and handles file upload.
# ------------------------------------------------------------------------------
module "s3_website" {
  source = "./modules/s3"

  # Infrastructure params
  bucket_name    = "${local.full_project_name}-assets"
  cloudfront_arn = module.cloudfront.distribution_arn
  
  # Safety switch. 
  # Prod buckets are protected (false), Dev buckets can be nuked (true).
  force_destroy  = var.environment == "prod" ? false : true

  # Content params (Injected from variables)
  index_document   = var.website_index_document
  content_type     = var.website_content_type
  source_file_path = var.website_source_path
  
  tags = local.common_tags
}

# ------------------------------------------------------------------------------
# CLOUDFRONT MODULE CALL
# Creates the CDN layer for global distribution and security (OAC).
# ------------------------------------------------------------------------------
module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_domain_name  = module.s3_website.bucket_regional_domain_name
  project_name        = local.full_project_name
  
  # Ensure CloudFront looks for the same file as S3 
  default_root_object = var.website_index_document
  
  # Cost Optimization.
  # Use PriceClass_100 (Cheaper) for Dev, PriceClass_All (Global) for Prod.
  price_class         = var.environment == "prod" ? "PriceClass_All" : "PriceClass_100"

  tags = local.common_tags
}