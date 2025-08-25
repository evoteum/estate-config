locals {
  gcp_org_parent = "organizations/${local.organisation_variables.gcp_organisation_id}"

  gcp_folders = {
    platform = {
      display_name = "platform"
      parent       = local.gcp_org_parent
    }
    environments = {
      display_name = "environments"
      parent       = local.gcp_org_parent
    }
    sandboxes = {
      display_name = "sandboxes"
      parent       = local.gcp_org_parent
    }
  }

}

resource "google_folder" "folders" {
  for_each     = local.gcp_folders
  display_name = each.value.display_name
  parent       = each.value.parent

  lifecycle {
    prevent_destroy = true
  }
}
