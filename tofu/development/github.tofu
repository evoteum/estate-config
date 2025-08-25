locals {
  organisation_variables = {
    app_name            = "app"
    aws_region          = "eu-west-2"
    build_flags         = "NONE"
    fail_fast           = true
    gcp_billing_account = "017009-6CF9CA-2FE9F1"
    gcp_organisation_id = "1005660309245"
    language_version    = "NONE"
    permitted_environments = jsonencode([
      "development",
      "staging",
      "production",
    ])
    quay_domain = local.quay_domain
    quay_url    = "https://${local.quay_domain}"
    target_arch = "amd64"
    target_os   = "linux"
  }
}

resource "github_organization_settings" "main" {
  billing_email                 = "billing@${local.website}"
  company                       = var.organisation
  blog                          = "https://${local.website}"
  email                         = "sup@${local.website}"
  twitter_username              = null
  location                      = "Earth"
  name                          = var.organisation
  description                   = var.org_slogan
  has_organization_projects     = true
  has_repository_projects       = true
  default_repository_permission = "read"

  # Disable manual repository creation.
  # All repositories are provisioned automatically via the estate-repos repository.
  members_can_create_repositories         = false
  members_can_create_public_repositories  = false
  members_can_create_private_repositories = false

  members_can_create_pages                                     = true
  members_can_create_public_pages                              = true
  members_can_create_private_pages                             = false
  members_can_fork_private_repositories                        = false
  web_commit_signoff_required                                  = false
  dependabot_alerts_enabled_for_new_repositories               = true
  dependabot_security_updates_enabled_for_new_repositories     = true
  dependency_graph_enabled_for_new_repositories                = true
  secret_scanning_enabled_for_new_repositories                 = true
  secret_scanning_push_protection_enabled_for_new_repositories = true
}

resource "github_actions_organization_secret" "tofu_state_bucket_name" {
  secret_name     = "TOFU_STATE_BUCKET_NAME"
  visibility      = "all"
  plaintext_value = local.state_bucket_name
}

resource "github_actions_organization_secret" "aws_role_to_assume" {
  secret_name     = "AWS_ROLE_TO_ASSUME"
  visibility      = "all"
  plaintext_value = aws_iam_role.github_role.arn
}

module "github_variable" {
  source   = "github.com/evoteum/tofu-modules//github/variable"
  for_each = local.organisation_variables

  sensitive = false
  scope     = "organisation"
  name      = upper(each.key)
  value     = each.value
}
