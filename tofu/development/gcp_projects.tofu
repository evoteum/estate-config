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
    platform = {
      folder_key = "platform"
      env        = "platform"
      location   = var.gcp_region

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
      folder_key = "environments"
      env        = "development"
      location   = var.gcp_region

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
  gcp_project_ids = {
    for k, v in local.gcp_projects :
    k => "${k}-${random_id.project_suffix[k].hex}"
  }

}

resource "random_id" "project_suffix" {
  for_each    = local.gcp_projects
  byte_length = 3
}

resource "google_project" "projects" {
  for_each = local.gcp_projects

  name            = each.key
  project_id      = local.gcp_project_ids[each.key]
  folder_id       = google_folder.folders[each.value.folder_key].id
  billing_account = local.organisation_variables.gcp_billing_account
  labels          = each.value.labels
  lifecycle {
    prevent_destroy = true
  }
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
