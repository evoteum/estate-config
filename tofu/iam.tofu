resource "aws_iam_policy" "github_role_policy" {
  name   = "github_role_policy"
  policy = data.aws_iam_policy_document.github_policy.json
}

data "aws_iam_policy_document" "github_policy" {
  statement {
    actions = [
      "ec2:Describe*",
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "s3:DeleteObject",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketPolicy",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetObject",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:PutObject",
      "sts:GetCallerIdentity",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketLogging",
      "s3:GetLifecycleConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:GetEncryptionConfiguration",
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "github_role" {
  name               = "GithubActionsRole"
  assume_role_policy = data.aws_iam_policy_document.github_allow.json
}

data "aws_iam_policy_document" "github_allow" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.githuboidc.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.org_name}/*"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_github_role" {
  role       = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.github_role_policy.arn
}
