output "website_url" {
  description = "The publicly accessible URL of the static website"
  value       = "https://${module.cloudfront.distribution_domain_name}"
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for website content"
  value       = module.s3_website.bucket_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "logging_bucket_name" {
  description = "Name of the S3 bucket for CloudFront logs"
  value       = module.logging.bucket_name
}

output "cloudwatch_dashboard_name" {
  description = "Name of the CloudWatch monitoring dashboard"
  value       = module.monitoring.dashboard_name
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = module.waf.web_acl_arn
}