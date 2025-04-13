locals {
  website                      = "${var.organisation}.com"
  account_token_manager_expiry = "25h"
  quay_domain                  = "quay.io"
  organisation_variables = {
    APP_NAME         = "app"
    AWS_REGION       = var.aws_region
    BUILD_FLAGS      = "NONE"
    FAIL_FAST        = true
    LANGUAGE_VERSION = "NONE"
    PERMITTED_ENVIRONMENTS = jsonencode([
      "development",
      "staging",
      "production",
    ])
    QUAY_DOMAIN                       = local.quay_domain
    QUAY_URL                          = "https://${local.quay_domain}"
    TARGET_ARCH                       = "amd64"
    TARGET_OS                         = "linux"
    TERRAFORM_DOCS_IS_TOFU_COMPATIBLE = local.terraform_docs_is_tofu_compatible
  }
  environment = basename(abspath(path.module))
}
