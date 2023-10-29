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