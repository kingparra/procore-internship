data "archive_file" "auto_on" {
  type = "zip"
  source_file = "${path.module}/../lambda/auto_on.py"
  output_path = "${path.module}/../lambda/auto_on_payload.zip"
}

resource "aws_lambda_function" "auto_on" {
  filename = "${path.module}/../lambda/auto_on_payload.zip"
  function_name = "auto_on"
  role = aws_iam_role.lambda_start_stop_ec2.arn
  runtime = "python3.10"
  handler = "auto_on.lambda_handler"
}

data "archive_file" "auto_off" {
  type = "zip"
  source_file = "${path.module}/../lambda/auto_off.py"
  output_path = "${path.module}/../lambda/auto_off_payload.zip"
}

resource "aws_lambda_function" "auto_off" {
  filename = "${path.module}/../lambda/auto_off_payload.zip"
  function_name = "auto_off"
  role = aws_iam_role.lambda_start_stop_ec2.arn
  runtime = "python3.10"
  handler = "auto_off.lambda_handler"
}
