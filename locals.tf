locals {
  # Consistent naming convention across all resources
  full_project_name = "${var.project_name}-${var.environment}"

  # Additional tags beyond default_tags (for module-specific tagging)
  # Default tags (Project, Environment, ManagedBy, Owner) are set in providers.tf
  common_tags = {}
}