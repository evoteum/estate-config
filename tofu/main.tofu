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
    key    = "${var.repo_name}/tofu.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}

provider "github" {
  owner = var.org_name
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_installation_id
    pem_file        = var.github_app_private_key
  }
}
