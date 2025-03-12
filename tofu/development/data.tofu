locals {
  tofu_is_junit_compatible          = jsondecode(data.http.tofu_issue_2501.response_body)["state"] == "closed" ? true : false
  terraform_docs_is_tofu_compatible = jsondecode(data.http.terraform_docs_pr_833.response_body)["merged"] == "true" ? true : false
}

data "http" "tofu_issue_2501" {
  url = "https://api.github.com/repos/opentofu/opentofu/issues/2501"
}

data "http" "terraform_docs_pr_833" {
  url = "https://api.github.com/repos/terraform-docs/terraform-docs/pulls/833"
}