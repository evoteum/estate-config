variables {
  org_name      = "test-org"
  oidc_audience = "sts.amazonaws.com"
}

run "github_actions_federation_setup" {
  command = plan

  # 1. Verify the OIDC provider points to GitHub's token endpoint
  assert {
    condition     = aws_iam_openid_connect_provider.githuboidc.url == "https://token.actions.githubusercontent.com"
    error_message = "OIDC provider must use GitHub's official token endpoint"
  }

  # 2. Verify we're using the standard AWS STS audience
  assert {
    condition     = contains(aws_iam_openid_connect_provider.githuboidc.client_id_list, var.oidc_audience)
    error_message = "OIDC provider must use sts.amazonaws.com as client ID"
  }

  # 3. Verify thumbprint is from a trusted source
  assert {
    condition     = contains(aws_iam_openid_connect_provider.githuboidc.thumbprint_list, "6938fd4d98bab03faadb97b34396831e3780aea1")
    error_message = "OIDC provider must use GitHub's official certificate thumbprint"
  }

  # 4. Verify we only have one client ID and thumbprint
  assert {
    condition     = length(aws_iam_openid_connect_provider.githuboidc.client_id_list) == 1
    error_message = "OIDC provider should only have one client ID"
  }

  assert {
    condition     = length(aws_iam_openid_connect_provider.githuboidc.thumbprint_list) == 1
    error_message = "OIDC provider should only have one thumbprint"
  }
}
