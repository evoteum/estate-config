module "github_variable" {
  source   = "github.com/evoteum/tofu-modules//github/variable"
  sensitive = true
  scope     = "organisation"
  name      = "aws_apprunner_connection_arn"
  value     = aws_apprunner_connection.github.arn
}
