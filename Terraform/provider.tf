terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
backend "s3" {
    bucket = "anushka1004"
    key    = "keys/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "anushka"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}