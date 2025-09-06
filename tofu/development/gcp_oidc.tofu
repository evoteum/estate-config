locals {
  gcp_deployer_roles = [
    "roles/artifactregistry.writer",
    "roles/compute.admin",
    "roles/container.admin",

  ]
}

resource "google_service_account" "gh_deployer" {
  account_id   = "gh-deployer"
  display_name = "GitHub deployer (all repos in ${var.organisation})"
  project      = google_project.projects["platform"].project_id
}

module "gh_oidc" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = "5.0.0"

  project_id = google_project.projects["platform"].project_id

  pool_id           = "github-oidc"
  pool_display_name = "GitHub OIDC"
  pool_description  = "WIF pool for GitHub Actions"

  provider_id           = "github"
  provider_display_name = "GitHub"
  provider_description  = "GitHub OIDC provider"
  issuer_uri            = "https://token.actions.githubusercontent.com"

  # Important: allow only tokens from our org
  attribute_condition = "assertion.repository_owner == \"${var.organisation}\""

  allowed_audiences = [
    "https://github.com/${var.organisation}"
  ]

  sa_mapping = {
    deployer = {
      sa_name   = google_service_account.gh_deployer.name
      attribute = "*" # deliberate: all identities admitted by attribute_condition
    }
  }
}

resource "google_project_iam_member" "gh_deployer_roles" {
  for_each = toset(local.gcp_deployer_roles)
  project  = google_project.projects["platform"].project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.gh_deployer.email}"
}
