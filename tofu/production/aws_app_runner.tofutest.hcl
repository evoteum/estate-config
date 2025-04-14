run "connection_is_created_with_expected_name" {
  command = plan

  assert {
    condition     = aws_apprunner_connection.github.connection_name == "github-${var.organisation}"
    error_message = "Expected connection_name to be github-${var.organisation}"
  }
}

run "connection_is_created_with_expected_provider" {
  command = plan

  assert {
    condition     = aws_apprunner_connection.github.provider_type == "GITHUB"
    error_message = "Expected provider_type to be 'GITHUB'"
  }
}
