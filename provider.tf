terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.12.0"
    }

  }
}

provider "aws" {
  region = var.aws_region #using variable
}

# backend "s3" {
  
# }