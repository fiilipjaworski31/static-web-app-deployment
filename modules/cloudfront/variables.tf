variable "bucket_domain_name" {
  description = "Regional domain name of the S3 bucket origin"
  type        = string
}

variable "project_name" {
  description = "Project name used for Origin ID generation"
  type        = string
}

variable "default_root_object" {
  description = "The object to return when the root URL is requested"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront Price Class (PriceClass_All, PriceClass_200, PriceClass_100)"
  type        = string
  default     = "PriceClass_100" # Default to cheapest option
}

variable "tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default     = {}
}