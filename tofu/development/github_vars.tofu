resource "github_actions_organization_variable" "tofu_is_junit_compatible" {
  value         = local.tofu_is_junit_compatible
  variable_name = "TOFU_IS_JUNIT_COMPATIBLE"
  visibility    = "all"
}

resource "github_actions_organization_variable" "terraform_docs_is_tofu_compatible" {
  value         = local.terraform_docs_is_tofu_compatible
  variable_name = "TERRAFORM_DOCS_IS_TOFU_COMPATIBLE"
  visibility    = "all"
}

resource "github_actions_organization_variable" "aws_region" {
  value         = var.aws_region
  variable_name = "AWS_REGION"
  visibility    = "all"
}

resource "github_actions_organization_variable" "quay_url" {
  value         = "https://quay.io"
  variable_name = "QUAY_URL"
  visibility    = "all"
}
