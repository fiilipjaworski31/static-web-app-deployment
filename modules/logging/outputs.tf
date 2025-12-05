output "bucket_name" {
  description = "Name of the logging bucket"
  value       = aws_s3_bucket.logging.id
}

output "bucket_arn" {
  description = "ARN of the logging bucket"
  value       = aws_s3_bucket.logging.arn
}

output "bucket_domain_name" {
  description = "Domain name of the logging bucket"
  value       = aws_s3_bucket.logging.bucket_domain_name
}