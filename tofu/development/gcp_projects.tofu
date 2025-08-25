locals {
  project_iam_pairs = {
    for pair in flatten([
      for pkey, p in local.gcp_projects : [
        for b in coalesce(p.iam, []) : {
          key         = "${pkey}|${b.role}|${b.member}"
          project_key = pkey
          role        = b.role
          member      = b.member
        }
      ]
    ]) : pair.key => pair
  }
  gcp_projects = {
    platform_infrastructure = {
      project_id = "platform-infrastructure"
      name       = "Platform Infrastructure"
      folder_key = "platform"
      env        = "platform"
      location   = "europe-west2"

      labels = {
        area            = "platform"
        env             = "platform"
        owner           = "devex"
        cost_centre     = "eng"
        confidentiality = "internal"
      }

      apis = [
        "artifactregistry.googleapis.com",
        "cloudbuild.googleapis.com",
        "iamcredentials.googleapis.com",
        "run.googleapis.com",
      ]

      iam = []
    }

    development = {
      project_id = "environment-development"
      name       = "Development Environment"
      folder_key = "environments"
      env        = "development"
      location   = "europe-west2"

      labels = {
        area            = "app"
        env             = "dev"
        owner           = "team-app"
        cost_centre     = "eng"
        confidentiality = "internal"
      }

      apis = [
        "run.googleapis.com",
        "sqladmin.googleapis.com",
        "secretmanager.googleapis.com",
        "logging.googleapis.com",
        "monitoring.googleapis.com",
      ]

      iam = []
    }

    production = {
      project_id = "environment-production"
      name       = "Production Environment"
      folder_key = "environments"
      env        = "production"
      location   = var.gcp_region

      labels = {
        area            = "application"
        env             = "production"
        owner           = "team-app"
        cost_centre     = "engineering"
        confidentiality = "restricted"
      }

      apis = [
        "run.googleapis.com",
        "sqladmin.googleapis.com",
        "secretmanager.googleapis.com",
        "logging.googleapis.com",
        "monitoring.googleapis.com",
        "cloudtrace.googleapis.com",
      ]

      iam = []
    }
  }
}

resource "google_project" "projects" {
  for_each = local.gcp_projects

  project_id      = each.value.project_id
  name            = each.value.name
  folder_id       = google_folder.folders[each.value.folder_key].name # "folders/123..."
  billing_account = local.organisation_variables.gcp_billing_account
  labels          = each.value.labels
  lifecycle { prevent_destroy = true }
}

locals {
  project_api_pairs = {
    for pair in flatten([
      for pkey, p in local.gcp_projects : [
        for api in coalesce(p.apis, []) : {
          key         = "${pkey}:${api}"
          project_key = pkey
          api         = api
        }
      ]
    ]) : pair.key => pair
  }
}

resource "google_project_service" "services" {
  for_each = local.project_api_pairs

  project                    = google_project.projects[each.value.project_key].project_id
  service                    = each.value.api
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_project_iam_member" "iam" {
  for_each = local.project_iam_pairs

  project = google_project.projects[each.value.project_key].project_id
  role    = each.value.role
  member  = each.value.member
}

output "project_ids" {
  value = { for k, p in google_project.projects : k => p.project_id }
}

output "project_numbers" {
  value = { for k, p in google_project.projects : k => p.number }
}

output "project_folder_ids" {
  value = { for k, v in local.gcp_projects : k => google_folder.folders[v.folder_key].name }
}
