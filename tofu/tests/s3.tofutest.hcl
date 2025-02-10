variables {
  org_name = "test-org"
}

mock_provider "aws" {}
mock_provider "random" {}

run "verify_state_bucket_name_generation" {
  command = plan

  assert {
    condition     = can(regex("^tofu-state-[a-z0-9]{16}$", local.state_bucket_name))
    error_message = "State bucket name must follow pattern: tofu-state-<16 lowercase alphanumeric chars>"
  }
}

run "verify_state_bucket_security" {
  command = plan

  # Versioning must be enabled for state protection
  assert {
    condition     = aws_s3_bucket_versioning.tofu_state.versioning_configuration[0].status == "Enabled"
    error_message = "State bucket must have versioning enabled"
  }

  # Encryption must be enabled and use AES256
  assert {
    condition     = aws_s3_bucket_server_side_encryption_configuration.tofu_state.rule[0].apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "State bucket must use AES256 encryption"
  }

  # All public access must be blocked
  assert {
    condition     = aws_s3_bucket_public_access_block.tofu_state.block_public_acls
    error_message = "State bucket must block public ACLs"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.tofu_state.block_public_policy
    error_message = "State bucket must block public bucket policies"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.tofu_state.ignore_public_acls
    error_message = "State bucket must ignore public ACLs"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.tofu_state.restrict_public_buckets
    error_message = "State bucket must restrict public bucket access"
  }
}

run "verify_state_bucket_lifecycle" {
  command = plan

  # State bucket should not be destroyed accidentally
  assert {
    condition     = aws_s3_bucket.tofu_state.lifecycle[0].prevent_destroy == false
    error_message = "State bucket should allow destruction in test environments"
  }
}
