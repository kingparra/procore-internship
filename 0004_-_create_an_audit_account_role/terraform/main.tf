terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.20.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Look up the PowerUserAccess AWS managed policy
data "aws_iam_policy" "security_audit" {
    arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# Create a role that grants access from users in account 832997848483
resource "aws_iam_role" "procore_aduitors_crossaccount" {
  name = "procore-auditors-crossaccount"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowStsFromExternalAccount"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "832997848483"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "power_users" {
  role = aws_iam_role.procore_aduitors_crossaccount.name
  policy_arn = data.aws_iam_policy.security_audit.arn
}