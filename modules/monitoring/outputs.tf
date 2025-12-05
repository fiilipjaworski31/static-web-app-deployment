output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "dashboard_arn" {
  description = "ARN of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_arn
}

output "alarm_5xx_arn" {
  description = "ARN of the 5xx error rate alarm"
  value       = var.alarms_enabled ? aws_cloudwatch_metric_alarm.error_5xx[0].arn : null
}

output "alarm_4xx_arn" {
  description = "ARN of the 4xx error rate alarm"
  value       = var.alarms_enabled ? aws_cloudwatch_metric_alarm.error_4xx[0].arn : null
}

output "alarm_waf_arn" {
  description = "ARN of the WAF blocked requests alarm"
  value       = var.alarms_enabled ? aws_cloudwatch_metric_alarm.waf_blocked[0].arn : null
}