terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
  required_version = "1.9.0"
  backend "s3" {
    bucket = "" # Provided in CD
    key    = ""
    region = ""
  }
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.organisation
  app_auth {} # When using `GITHUB_APP_XXX` environment variables
}
