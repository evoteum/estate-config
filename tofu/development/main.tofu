terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.45.0"
    }
  }
  required_version = "1.9.0"
  backend "s3" {
    bucket = "tofu-state-*****" # Provided in CD
    key    = ""
    region = ""
  }
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.org_name
  app_auth {} # When using `GITHUB_APP_XXX` environment variables
}
