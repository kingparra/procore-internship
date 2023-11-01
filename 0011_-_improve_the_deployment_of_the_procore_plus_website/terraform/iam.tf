resource "aws_iam_instance_profile" "deploy" {
  name = "deploy-procore-website"
  role = aws_iam_role.deploy.name
}

resource "aws_iam_role" "deploy" {
  name = "deploy-procore-website"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.deploy.name
  policy_arn = data.aws_iam_policy.codecommit.arn
}

data "aws_iam_policy" "codecommit" {
  arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

# Add permissions to instance profile for CodeDeploy agent
data "aws_iam_policy_document" "get_agent_and_payload" {
  statement {
    sid = "GetCodeDeoplyAgentAndPayload"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
    ]
    resources = [
      "arn:aws:s3:::procoreplusproductswebsitechanges/*",
      "arn:aws:s3:::aws-codedeploy-us-east-1/*",
    ]
  }
}

resource "aws_iam_policy" "get_agent_and_payload" {
  name = "codedeploy-ec2-permissions-deploy-procore-website"
  policy = data.aws_iam_policy_document.get_agent_and_payload.json
  tags = {
    "TicketName2" = var.ticket_name_2
  }
}

resource "aws_iam_role_policy_attachment" "get_agent_and_payload" {
  role = aws_iam_role.deploy.name
  policy_arn = aws_iam_policy.get_agent_and_payload.arn
}

# Add service linked role for CodeDeploy
resource "aws_iam_role" "codedeploy" {
  name = "AWSCodeDeployRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    "TicketName2" = var.ticket_name_2
  }
}

data "aws_iam_policy" "codedeploy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role = aws_iam_role.codedeploy.name
  policy_arn = data.aws_iam_policy.codedeploy.arn
}