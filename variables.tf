# --- Infrastructure Configuration ---

variable "aws_region" {
  description = "AWS Region where resources will be deployed (e.g., us-east-1)"
  type        = string
}

variable "project_name" {
  description = "Base name of the project used for naming resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
}

# --- Content Configuration ---
# These variables allow to change the website file without touching the code.

variable "website_index_document" {
  description = "Filename of the entry point document (e.g. index.html)"
  type        = string
}

variable "website_content_type" {
  description = "MIME type of the content (e.g. text/html)"
  type        = string
}

variable "website_source_path" {
  description = "Local filesystem path to the source file to upload"
  type        = string
}