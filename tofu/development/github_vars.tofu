
resource "github_actions_organization_variable" "quay_url" {
  value         = "https://${github_actions_organization_variable.quay_login_url.value}"
  variable_name = "QUAY_URL"
  visibility    = "all"
}

resource "github_actions_organization_variable" "quay_login_url" {
  value         = "quay.io"
  variable_name = "QUAY_LOGIN_URL"
  visibility    = "all"
}
