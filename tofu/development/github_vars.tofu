
resource "github_actions_organization_variable" "quay_url" {
  value         = "https://quay.io"
  variable_name = "QUAY_URL"
  visibility    = "all"
}
