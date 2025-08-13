locals {
  state_bucket_suffix = random_string.state_bucket_suffix.result
  state_bucket_name   = "tofu-state-${local.state_bucket_suffix}"
}

resource "random_string" "state_bucket_suffix" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "tofu_state" {
  bucket = local.state_bucket_name
  lifecycle {
    prevent_destroy = false
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

resource "aws_s3_bucket" "tofu_test" {
  bucket = "evoteum-tofu-test"
}
