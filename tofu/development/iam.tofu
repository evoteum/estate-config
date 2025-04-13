resource "aws_iam_policy" "github_role_policy" {
  name   = "github_role_policy"
  policy = data.aws_iam_policy_document.github_policy.json
}

data "aws_iam_policy_document" "github_policy" {
  statement {
    actions = [
      # Principle of least privilege: Only the specific actions required are allowed, so we avoid *.
      "apprunner:CreateConnection",
      "apprunner:CreateService",
      "apprunner:DeleteService",
      "apprunner:DescribeService",
      "apprunner:ListConnections",
      "apprunner:ListServices",
      "apprunner:ListTagsForResource",
      "apprunner:TagResource",
      "apprunner:UpdateService",
      "cloudfront:CreateDistribution",
      "cloudfront:CreateFunction",
      "cloudfront:DeleteDistribution",
      "cloudfront:DeleteFunction",
      "cloudfront:GetDistribution",
      "cloudfront:TagResource",
      "cloudfront:UpdateDistribution",
      "cloudfront:UpdateFunction",
      "dynamodb:CreateTable",
      "dynamodb:DeleteTable",
      "dynamodb:DescribeTable",
      "dynamodb:ListTagsOfResource",
      "dynamodb:TagResource",
      "dynamodb:UpdateTable",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:DeletePolicyVersion",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListPolicyVersions",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:TagOpenIDConnectProvider",
      "iam:TagPolicy",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:DeleteObject",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketLogging",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetObject",
      "s3:GetReplicationConfiguration",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:PutBucketPolicy",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutBucketWebsite",
      "s3:PutEncryptionConfiguration",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectVersionAcl",
      "sts:GetCallerIdentity",
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
      values   = ["repo:${var.organisation}/*"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_github_role" {
  role       = aws_iam_role.github_role.name
  policy_arn = aws_iam_policy.github_role_policy.arn
}
