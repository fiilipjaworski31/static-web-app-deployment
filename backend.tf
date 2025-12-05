terraform {
  backend "s3" {
    bucket       = "tf-state-filip-j-2025-2611"
    key          = "static-web/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}