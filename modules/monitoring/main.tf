# ------------------------------------------------------------------------------
# Local Variables
# ------------------------------------------------------------------------------
locals {
  dashboard_name = var.dashboard_name != "" ? var.dashboard_name : "${var.name_prefix}-dashboard"

  # Widget positioning helpers
  widget_width  = var.dashboard_widget_width
  widget_height = var.dashboard_widget_height
  row_1_y       = 0
  row_2_y       = var.dashboard_widget_height
  row_3_y       = var.dashboard_widget_height * 2
}

# ------------------------------------------------------------------------------
# CloudWatch Dashboard
# Provides real-time visibility into CloudFront and WAF metrics.
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = local.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      # Row 1: Request Overview
      {
        type   = "metric"
        x      = 0
        y      = local.row_1_y
        width  = local.widget_width
        height = local.widget_height
        properties = {
          title  = "Total Requests"
          region = var.cloudfront_metrics_region
          period = var.dashboard_period
          # AWS constant: "Sum" aggregates total count of requests
          stat = "Sum"
          metrics = [
            # AWS requirement: CloudFront metrics use "Global" as Region dimension
            # This is not configurable - CloudFront is a global service
            ["AWS/CloudFront", "Requests", "DistributionId", var.cloudfront_distribution_id, "Region", "Global"]
          ]
        }
      },
      {
        type   = "metric"
        x      = local.widget_width
        y      = local.row_1_y
        width  = local.widget_width
        height = local.widget_height
        properties = {
          title  = "WAF Blocked Requests"
          region = var.waf_metrics_region
          period = var.dashboard_period
          stat   = "Sum"
          metrics = [
            # AWS requirement: "ALL" aggregates metrics across all WAF rules
            # This is the standard dimension value for total blocked requests
            ["AWS/WAFV2", "BlockedRequests", "WebACL", var.waf_web_acl_name, "Rule", "ALL", "Region", var.waf_metrics_region]
          ]
        }
      },

      # Row 2: Error Rates
      {
        type   = "metric"
        x      = 0
        y      = local.row_2_y
        width  = local.widget_width
        height = local.widget_height
        properties = {
          title  = "4xx Error Rate (%)"
          region = var.cloudfront_metrics_region
          period = var.dashboard_period
          # AWS constant: "Average" calculates mean error rate percentage
          stat = "Average"
          metrics = [
            ["AWS/CloudFront", "4xxErrorRate", "DistributionId", var.cloudfront_distribution_id, "Region", "Global"]
          ]
          yAxis = {
            left = {
              # Fixed scale: Error rates are percentages, always 0-100%
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type   = "metric"
        x      = local.widget_width
        y      = local.row_2_y
        width  = local.widget_width
        height = local.widget_height
        properties = {
          title  = "5xx Error Rate (%)"
          region = var.cloudfront_metrics_region
          period = var.dashboard_period
          stat   = "Average"
          metrics = [
            ["AWS/CloudFront", "5xxErrorRate", "DistributionId", var.cloudfront_distribution_id, "Region", "Global"]
          ]
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },

      # Row 3: Bytes & Cache
      {
        type   = "metric"
        x      = 0
        y      = local.row_3_y
        width  = local.widget_width
        height = local.widget_height
        properties = {
          title  = "Bytes Downloaded"
          region = var.cloudfront_metrics_region
          period = var.dashboard_period
          stat   = "Sum"
          metrics = [
            ["AWS/CloudFront", "BytesDownloaded", "DistributionId", var.cloudfront_distribution_id, "Region", "Global"]
          ]
        }
      },
      {
        type   = "metric"
        x      = local.widget_width
        y      = local.row_3_y
        width  = local.widget_width
        height = local.widget_height
        properties = {
          title  = "Cache Hit Rate (%)"
          region = var.cloudfront_metrics_region
          period = var.dashboard_period
          stat   = "Average"
          metrics = [
            ["AWS/CloudFront", "CacheHitRate", "DistributionId", var.cloudfront_distribution_id, "Region", "Global"]
          ]
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }
    ]
  })
}

# ------------------------------------------------------------------------------
# CloudWatch Alarms
# Proactive alerting for error conditions.
# ------------------------------------------------------------------------------

# 5xx Error Rate Alarm
resource "aws_cloudwatch_metric_alarm" "error_5xx" {
  count = var.alarms_enabled ? 1 : 0

  alarm_name        = "${var.name_prefix}-high-5xx-error-rate"
  alarm_description = "Triggered when 5xx error rate exceeds ${var.alarm_5xx_threshold}%"
  # AWS constant: Alarm triggers when metric is greater than threshold
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  # AWS metric name: Fixed identifier for 5xx error rate in CloudFront namespace
  metric_name = "5xxErrorRate"
  # AWS namespace: Fixed identifier for CloudFront metrics
  namespace = "AWS/CloudFront"
  period    = var.alarm_period
  statistic = "Average"
  threshold = var.alarm_5xx_threshold
  # Best practice: Missing data should not trigger false alarms
  treat_missing_data = "notBreaching"

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
    # AWS requirement: CloudFront metrics require "Global" region dimension
    Region = "Global"
  }

  actions_enabled = var.sns_topic_arn != ""
  alarm_actions   = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []
  ok_actions      = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = var.tags
}

# 4xx Error Rate Alarm
resource "aws_cloudwatch_metric_alarm" "error_4xx" {
  count = var.alarms_enabled ? 1 : 0

  alarm_name          = "${var.name_prefix}-high-4xx-error-rate"
  alarm_description   = "Triggered when 4xx error rate exceeds ${var.alarm_4xx_threshold}%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.alarm_4xx_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
    Region         = "Global"
  }

  actions_enabled = var.sns_topic_arn != ""
  alarm_actions   = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []
  ok_actions      = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = var.tags
}

# WAF Blocked Requests Alarm
resource "aws_cloudwatch_metric_alarm" "waf_blocked" {
  count = var.alarms_enabled ? 1 : 0

  alarm_name          = "${var.name_prefix}-high-waf-blocks"
  alarm_description   = "Triggered when WAF blocks more than ${var.alarm_waf_blocked_threshold} requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  # AWS metric name: Fixed identifier for blocked requests in WAFV2 namespace
  metric_name = "BlockedRequests"
  # AWS namespace: Fixed identifier for WAFv2 metrics
  namespace = "AWS/WAFV2"
  period    = var.alarm_period
  # AWS constant: "Sum" counts total blocked requests in period
  statistic          = "Sum"
  threshold          = var.alarm_waf_blocked_threshold
  treat_missing_data = "notBreaching"

  dimensions = {
    WebACL = var.waf_web_acl_name
    # AWS constant: "ALL" aggregates all rules in the Web ACL
    Rule   = "ALL"
    Region = var.waf_metrics_region
  }

  actions_enabled = var.sns_topic_arn != ""
  alarm_actions   = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []
  ok_actions      = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []

  tags = var.tags
}