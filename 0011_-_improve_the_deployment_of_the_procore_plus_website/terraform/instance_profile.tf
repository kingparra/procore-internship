resource "aws_iam_instance_profile" "deploy" {
  name = "deploy-procore-website"
  role = aws_iam_role.deploy.name
  tags = {
    "TicketName2" = var.ticket_name_2
  }
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
data "aws_iam_policy_document" "get_agent" {
  statement {
    sid    = "GetCodeDeoplyAgentAndBundle"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
    ]
    resources = [
      "arn:aws:s3:::aws-codedeploy-us-east-1/*",
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "get_agent" {
  name   = "codedeploy-ec2-permissions-deploy-procore-website"
  policy = data.aws_iam_policy_document.get_agent.json
  tags = {
    "TicketName2" = var.ticket_name_2
  }
}

resource "aws_iam_role_policy_attachment" "get_agent" {
  role       = aws_iam_role.deploy.name
  policy_arn = aws_iam_policy.get_agent.arn
}
