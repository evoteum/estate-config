run "connection is created with expected name and provider" {
  command = plan

  assert {
    condition = aws_apprunner_connection.github.connection_name == "github-" + var.organisation
    message   = "Expected connection_name to be github-" + var.organisation
  }

  assert {
    condition = aws_apprunner_connection.github.provider_type == "GITHUB"
    message   = "Expected provider_type to be 'GITHUB'"
  }
}
