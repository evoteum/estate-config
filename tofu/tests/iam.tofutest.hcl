variables {
  org_name = "test-org"
}

mock_provider "aws" {}

run "verify_github_role_policy" {
  command = plan

  assert {
    condition     = aws_iam_policy.github_role_policy.name == "github_role_policy"
    error_message = "IAM policy name should be github_role_policy"
  }
}

run "verify_github_role" {
  command = plan

  assert {
    condition     = aws_iam_role.github_role.name == "GithubActionsRole"
    error_message = "IAM role name should be GithubActionsRole"
  }
}

run "verify_github_policy_document" {
  command = plan

  assert {
    condition     = contains(data.aws_iam_policy_document.github_policy.statement[0].actions, "iam:GetPolicyVersion")
    error_message = "Policy should include iam:GetPolicyVersion permission"
  }

  assert {
    condition     = contains(data.aws_iam_policy_document.github_policy.statement[0].actions, "s3:GetObject")
    error_message = "Policy should include s3:GetObject permission"
  }

  assert {
    condition     = data.aws_iam_policy_document.github_policy.statement[0].effect == "Allow"
    error_message = "Policy effect should be Allow"
  }

  assert {
    condition     = contains(data.aws_iam_policy_document.github_policy.statement[0].resources, "*")
    error_message = "Policy should apply to all resources"
  }
}

run "verify_github_allow_policy" {
  command = plan

  assert {
    condition     = data.aws_iam_policy_document.github_allow.statement[0].effect == "Allow"
    error_message = "AssumeRole policy effect should be Allow"
  }

  assert {
    condition     = contains(data.aws_iam_policy_document.github_allow.statement[0].actions, "sts:AssumeRoleWithWebIdentity")
    error_message = "AssumeRole policy should allow sts:AssumeRoleWithWebIdentity"
  }

  assert {
    condition     = data.aws_iam_policy_document.github_allow.statement[0].principals[0].type == "Federated"
    error_message = "AssumeRole policy should use Federated principal"
  }

  assert {
    condition     = data.aws_iam_policy_document.github_allow.statement[0].condition[0].test == "StringLike"
    error_message = "AssumeRole policy should use StringLike condition"
  }

  assert {
    condition     = contains(data.aws_iam_policy_document.github_allow.statement[0].condition[0].values, "repo:${var.org_name}/*")
    error_message = "AssumeRole policy should allow all repos in the organization"
  }
}

run "verify_role_policy_attachment" {
  command = plan

  assert {
    condition     = aws_iam_role_policy_attachment.attach_github_role.role == aws_iam_role.github_role.name
    error_message = "Policy should be attached to the GitHub role"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.attach_github_role.policy_arn == aws_iam_policy.github_role_policy.arn
    error_message = "Correct policy should be attached to the role"
  }
}
