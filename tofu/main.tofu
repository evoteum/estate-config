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
    bucket = "tofu-state-*****"  # Provided in CD
    key    = "${var.repo_name}/tofu.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.org_name
  token = var.github_token
}
