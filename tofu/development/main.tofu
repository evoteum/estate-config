terraform {
  required_version = "1.9.0"

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
      version = "6.6.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.48.0"
    }

  }
  backend "s3" {
    bucket = "tofu-state-*****" # Provided in CD
    key    = ""
    region = ""
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment   = local.environment
      Project       = var.repository_name
      ManagedBy     = "OpenTofu"
      RepositoryURL = var.repository_url
    }
  }
}

provider "github" {
  owner = var.organisation
  app_auth {} # When using `GITHUB_APP_XXX` environment variables
}

provider "google" {
  project = "arctic-sentry-468900-g0"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}