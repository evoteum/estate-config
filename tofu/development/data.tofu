locals {
  tofu_is_junit_compatible          = jsondecode(data.http.tofu_issue_2501.response_body)["state"] == "closed" ? true : false
  terraform_docs_is_tofu_compatible = true
}

data "http" "tofu_issue_2501" {
  url = "https://api.github.com/repos/opentofu/opentofu/issues/2501"
}
