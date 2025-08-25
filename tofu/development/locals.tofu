locals {
  website                      = "${var.organisation}.com"
  account_token_manager_expiry = "25h"
  quay_domain                  = "quay.io"
  environment                  = basename(abspath(path.module))
  iam_actions_yml              = yamldecode(data.local_file.iam_actions.content)
  iam_actions                  = local.iam_actions_yml.actions
  gcp_zone                     = "${lower(var.gcp_region)}-${lower(var.gcp_zone_suffix)}"
}
