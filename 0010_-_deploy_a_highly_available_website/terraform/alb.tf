module "alb" {
  # Create an alb, target group, listener, sg, s3 bucket, s3 bucket policy...
  source = "cloudposse/alb/aws"

  name    = "procore-website-alb"
  version = "1.10.0"

  vpc_id             = data.aws_vpc.dev_vpc.id
  security_group_ids = [aws_security_group.web.id]
  subnet_ids         = data.aws_subnets.dev_vpc_public_subnets.ids
  internal           = false
  http_enabled       = true
  ip_address_type    = "ipv4"

  access_logs_enabled = true

  target_group_name        = "procore-website-alb-tg"
  target_group_port        = 80
  target_group_protocol    = "HTTP"
  target_group_target_type = "instance"
}