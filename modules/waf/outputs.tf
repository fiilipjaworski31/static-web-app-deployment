output "web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL for CloudFront association"
  value       = aws_wafv2_web_acl.cloudfront_waf.arn
}

output "web_acl_id" {
  description = "ID of the WAFv2 Web ACL"
  value       = aws_wafv2_web_acl.cloudfront_waf.id
}

output "web_acl_name" {
  description = "Name of the WAFv2 Web ACL"
  value       = aws_wafv2_web_acl.cloudfront_waf.name
}