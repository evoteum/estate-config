variables {
  org_name    = "test-org"
  org_slogan  = "Test Slogan"
  aws_region  = "eu-west-2"
}

mock_provider "github" {}

mock_resource "github_organization_settings" {
  expect_value = {
    name                                                         = "test-org"
    description                                                  = "Test Slogan"
    billing_email                                                = "billing@test-org.com"
    web_commit_signoff_required                                  = true
    dependabot_alerts_enabled_for_new_repositories               = true
    dependabot_security_updates_enabled_for_new_repositories     = true
    dependency_graph_enabled_for_new_repositories                = true
    secret_scanning_enabled_for_new_repositories                 = true
    secret_scanning_push_protection_enabled_for_new_repositories = true
  }
}

run "verify_organization_settings" {
  command = plan

  assert {
    condition     = github_organization_settings.main.name == var.org_name
    error_message = "Organization name should match var.org_name"
  }

  assert {
    condition     = github_organization_settings.main.description == var.org_slogan
    error_message = "Organization description should match var.org_slogan"
  }

  assert {
    condition     = github_organization_settings.main.web_commit_signoff_required == true
    error_message = "Web commit signoff should be required"
  }
}

run "verify_organization_secrets" {
  command = plan

  assert {
    condition     = github_actions_organization_secret.tofu_state_bucket_name.visibility == "all"
    error_message = "State bucket secret should be visible to all repositories"
  }

  assert {
    condition     = github_actions_organization_secret.aws_role_to_assume.visibility == "all"
    error_message = "AWS role secret should be visible to all repositories"
  }
}

run "verify_organization_variables" {
  command = plan

  assert {
    condition     = github_actions_organization_variable.aws_region.value == var.aws_region
    error_message = "AWS region variable should match var.aws_region"
  }

  assert {
    condition     = github_actions_organization_variable.aws_region.visibility == "all"
    error_message = "AWS region variable should be visible to all repositories"
  }
}
