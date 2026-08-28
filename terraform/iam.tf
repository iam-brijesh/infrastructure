data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "github_actions" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:iam-brijesh/sample-war-java-21-maven:*",
              "repo:iam-brijesh/sample-war2-java-21-maven:*",
              "repo:iam-brijesh/sample-war3-java-21-maven:*",
              "repo:iam-brijesh/infrastructure:*"
            ]
          }
        }
      }
    ]
  })

  tags = {
    Project     = "hello-world"
    Environment = "practice"
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
