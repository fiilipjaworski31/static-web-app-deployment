output "website_url" {
  description = "The publicly accessible URL of the static website"
  value       = "https://${module.cloudfront.distribution_domain_name}"
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket created"
  value       = module.s3_website.bucket_name
}