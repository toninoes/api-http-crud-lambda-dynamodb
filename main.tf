terraform {
  required_version = ">= 0.15.0"

  backend "s3" {
    bucket = "pruebas-tf-state"
    key    = "api-http-crud-lambda-dynamodb/terraform.tfstate"
    region = "eu-west-1"

    profile = "toni-pruebas"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
    }
  }
}

locals {
  name   = "api-http-crud-lambda-dynamodb"
  region = "eu-west-1"
  tags = {
    project     = var.project
    environment = var.environment
  }
}

provider "aws" {
  region  = local.region
  profile = var.profile
}