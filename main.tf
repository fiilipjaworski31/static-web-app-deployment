# Local values for naming conventions and logic
locals {
  full_project_name = "${var.project_name}-${var.environment}"
}

# S3 Module Call
module "s3_website" {
  source = "./modules/s3"

  # Dynamic Naming: e.g., "my-project-dev-assets"
  bucket_name    = "${local.full_project_name}-assets"
  cloudfront_arn = module.cloudfront.distribution_arn
  
  # LOGIC: Force destroy is enabled for dev/stage for convenience,
  # but DISABLED for production to prevent data loss.
  force_destroy = var.environment == "prod" ? false : true

  # We can pass extra tags if needed (provider default_tags handles the rest)
  tags = {
    Module = "S3-Website"
  }
}

# CloudFront Module Call
module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_domain_name = module.s3_website.bucket_regional_domain_name
  # The domain name is used to generate the Origin ID
  project_name       = local.full_project_name
  
  # Parameterizing the root object
  default_root_object = "index.html"

  # COST OPTIMIZATION: 
  # Use PriceClass_100 (NA/EU only) for Dev to save money.
  # Use PriceClass_All for Prod for global performance.
  price_class = var.environment == "prod" ? "PriceClass_All" : "PriceClass_100"

  tags = {
    Module = "CloudFront-CDN"
  }
}