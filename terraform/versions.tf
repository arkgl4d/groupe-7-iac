terraform {
  
  backend "s3" {
    bucket = "tf-state-group7-ynov"
    key    = "group7/terraform.tfstate"
    region = "eu-west-1"
  }
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
