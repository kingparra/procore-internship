terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.20.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create the account
resource "aws_iam_user" "rclemente" {
  name = "rclemente"
}

# Create a power_users group
resource "aws_iam_group" "power_users" {
  name = "power_users"
}

# Attach the account to the the power_users group
resource "aws_iam_group_membership" "power_users_membership" {
  name = "tf-testing-group-membership"
  users = [
    aws_iam_user.rclemente.name,
  ]
  group = aws_iam_group.power_users.name
}

# Look up the PowerUserAccess AWS managed policy
data "aws_iam_policy" "power_user_access" {
    arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# Attach that policy to the power_users group
resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.power_users.name
  policy_arn = data.aws_iam_policy.power_user_access.arn
}

# Set up web console access for rclemente
resource "aws_iam_user_login_profile" "rclemente" {
  user = aws_iam_user.rclemente.name
}

output "rclemente_password" {
  sensitive = true
  value = aws_iam_user_login_profile.rclemente.password
}