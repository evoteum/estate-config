locals {
  quay_domain = "quay.io"
  org_variables = {
    FAIL_FAST   = true
  }
}


module "github_variable" {
  source   = "github.com/evoteum/tofu-modules//github/variable"
  for_each = local.org_variables

  sensitive = false
  scope     = "organisation"
  name      = each.key
  value     = each.value
}
