resource "aws_codedeploy_app" "website" {
  compute_platform = "Server"
  name = var.application_name
}

data "aws_lb_target_group" "target_group_name" {
  arn = module.alb.default_target_group_arn
}

resource "aws_codedeploy_deployment_group" "group" {
  app_name = aws_codedeploy_app.website.name
  deployment_group_name = var.deployment_group_name
  service_role_arn = aws_iam_role.codedeploy.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  load_balancer_info {
    target_group_info {
      name = data.aws_lb_target_group.target_group_name.name
    }
  }
}