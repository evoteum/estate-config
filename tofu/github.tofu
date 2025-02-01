resource "github_organization_settings" "main" {
  billing_email                                                = "billing@${local.website}"
  company                                                      = var.org_name
  blog                                                         = "https://${local.website}"
  email                                                        = "sup@${local.website}"
  twitter_username                                             = null
  location                                                     = "Earth"
  name                                                         = var.org_name
  description                                                  = var.org_slogan
  has_organization_projects                                    = true
  has_repository_projects                                      = true
  default_repository_permission                                = "read"
  members_can_create_repositories                              = true
  members_can_create_public_repositories                       = true
  members_can_create_private_repositories                      = true
  members_can_create_pages                                     = true
  members_can_create_public_pages                              = true
  members_can_create_private_pages                             = true
  members_can_fork_private_repositories                        = true
  web_commit_signoff_required                                  = true
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

resource "github_actions_organization_variable" "aws_region" {
  value         = var.aws_region
  variable_name = "AWS_REGION"
  visibility    = "all"
}

resource "github_actions_organization_secret" "aws_role_to_assume" {
  secret_name     = "AWS_ROLE_TO_ASSUME"
  visibility      = "all"
  plaintext_value = aws_iam_role.github_role.arn
}
