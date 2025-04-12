locals {
  aws_apprunner_connection_name = "github-${var.organisation}"
}

resource "aws_apprunner_connection" "github" {
  connection_name = local.aws_apprunner_connection_name
  provider_type   = "GITHUB"

  tags = {
    Name = local.aws_apprunner_connection_name
  }
}