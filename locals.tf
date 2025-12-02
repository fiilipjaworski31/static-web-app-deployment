locals {
  # Ensures consistent naming convention across all resources
  full_project_name = "${var.project_name}-${var.environment}"

  # Tags are passed to all modules to ensure cost allocation and tracking
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "DevOps Team"
  }
}