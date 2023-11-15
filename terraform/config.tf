terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    encrypt = true
    bucket  = "terraform-project-9093"
    key     = "terraform-project-9093.tfstate"
    region  = "us-west-1"

    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = "us-east-1"
}
