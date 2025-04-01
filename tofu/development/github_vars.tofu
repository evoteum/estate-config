locals {
  quay_domain = "quay.io"
  org_variables = {
    APP_NAME    = "app"
    BUILD_FLAGS = "NONE"
    FAIL_FAST   = true
    LANGUAGE_VERSION = "Set this in estate-repos/repos.yml"
    QUAY_DOMAIN = local.quay_domain
    QUAY_URL    = "https://${local.quay_domain}"
    TARGET_ARCH = "amd64"
    TARGET_OS   = "linux"
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
