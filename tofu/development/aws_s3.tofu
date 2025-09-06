locals {
  state_bucket_suffix = random_string.state_bucket_suffix.result
  state_bucket_name   = "tofu-state-${local.state_bucket_suffix}"
  organisation_environments = {
    for pair in setproduct(
      local.github_organisations,
      local.organisation_variables.permitted_environments
    ) :
    "${pair[0]}-${pair[1]}" => {
      github_organisation = pair[0]
      environment         = pair[1]
    }
  }

}

resource "random_string" "state_bucket_suffix" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "tofu_state" {
  bucket = local.state_bucket_name
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tofu_state" {
  bucket = aws_s3_bucket.tofu_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tofu_state" {
  bucket = aws_s3_bucket.tofu_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tofu_state" {
  bucket = aws_s3_bucket.tofu_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "state_buckets" {
  for_each     = local.organisation_environments
  source       = "github.com/evoteum/tofu-modules//aws/bucket"
  organisation = each.value.github_organisation
  project      = var.repository_name
  environment  = each.value.environment
  purpose      = "tfstate"
}
