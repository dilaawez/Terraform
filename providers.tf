terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "/mnt/c/Users/Username/.aws/credentials"
  profile                 = "default"
}