output "distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.id
}