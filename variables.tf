variable "aws_region" {
  description = "AWS Region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Base name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "The environment must be one of: dev, stage, prod."
  }
}