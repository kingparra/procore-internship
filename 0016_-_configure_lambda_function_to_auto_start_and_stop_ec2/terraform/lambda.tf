module "auto_on" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.5.0"
  function_name = "auto_on"
  description = "Turn on EC2 instances with AutoOn=True"
  handler = "auto_on.lambda_handler"
  runtime = "python3.10"
  source_path = "${path.module}/../lambda/auto_on/"
}

module "auto_off" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.5.0"
  function_name = "auto_off"
  description = "Turn off EC2 instances with AutoOff=True"
  handler = "auto_off.lambda_handler"
  runtime = "python3.10"
  source_path = "${path.module}/../lambda/auto_off/"
}
