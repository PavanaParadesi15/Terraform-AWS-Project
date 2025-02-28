// This is the AWS provider block 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.85.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
