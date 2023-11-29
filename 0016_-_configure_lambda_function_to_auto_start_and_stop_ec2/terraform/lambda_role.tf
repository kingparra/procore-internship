resource "aws_iam_role_policy" "lambda_start_stop_ec2" {
  name   = "lambda_start_stop_ec2"
  role = aws_iam_role.lambda_start_stop_ec2.id
  policy = file("${path.module}/../lambda/policy.json")
}

resource "aws_iam_role" "lambda_start_stop_ec2" {
  name = "lambda_start_stop_ec2"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
