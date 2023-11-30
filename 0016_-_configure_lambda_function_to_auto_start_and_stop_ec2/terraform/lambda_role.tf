resource "aws_iam_policy" "lambda_start_stop_ec2" {
  name   = "lambda_start_stop_ec2"
  path = "/"
  policy = file("${path.module}/../lambda/policy.json")
}

resource "aws_iam_role_policy_attachment" "att" {
  for_each = toset([module.auto_on.lambda_role_name, module.auto_off.lambda_role_name])
  role = each.value
  policy_arn = aws_iam_policy.lambda_start_stop_ec2.arn
}
