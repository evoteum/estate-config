resource "cloudflare_api_token" "account_token_manager" {
  name = "cloudflare-account-token-${timestamp()}"

  policy {
    permission_groups = ["Account.API Tokens"]
    resources = {
      "com.cloudflare.api.account.${var.cloudflare_account_id}" = "*"
    }
  }

  expires_on = timeadd(timestamp(), "25h")
  lifecycle {
    create_before_destroy = true
  }
}

module "github_secret" {
  source    = "github.com/evoteum/tofu-modules//github/variable"
  sensitive = true
  scope     = "organisation"
  name      = "CLOUDFLARE_TOKEN_MANAGER"
  value     = cloudflare_api_token.account_token_manager.value
}
