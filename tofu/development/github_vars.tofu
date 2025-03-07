
resource "github_actions_organization_variable" "quay_url" {
  value         = "https://${github_actions_organization_variable.quay_domain.value}"
  variable_name = "QUAY_URL"
  visibility    = "all"
}

resource "github_actions_organization_variable" "quay_domain" {
  value         = "quay.io"
  variable_name = "QUAY_DOMAIN"
  visibility    = "all"
}

resource "github_actions_organization_variable" "fail_fast" {
  value         = "true"
  variable_name = "FAIL_FAST"
  visibility    = "all"
}

