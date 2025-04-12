test "connection is created with expected name and provider" {
  command = plan

  assert {
    condition = aws_apprunner_connection.test.connection_name == "github-" + var.organisation
    message   = "Expected connection_name to be github-" + var.organisation
  }

  assert {
    condition = aws_apprunner_connection.test.provider_type == "GITHUB"
    message   = "Expected provider_type to be 'GITHUB'"
  }
}

test "connection status is AVAILABLE" {
  command = apply

  assert {
    condition = data.aws_apprunner_connection.test_status.status == "AVAILABLE"
    message   = "App Runner connection is not in AVAILABLE state. Please complete the GitHub handshake."
  }
}

