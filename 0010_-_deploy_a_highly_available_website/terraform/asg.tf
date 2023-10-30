resource "aws_autoscaling_group" "asg" {
  name = "procore-website-asg"
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = data.aws_subnets.dev_vpc_public_subnets.ids
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3
  # warmup time of 2560 seconds
  default_instance_warmup = 250
  # attach the alb
  target_group_arns = [module.alb.default_target_group_arn]
  health_check_type = "ELB"
  # This corresponds to checking "enable group metrics collection" in the web ui.
  metrics_granularity = "1Minute"
  enabled_metrics = [
      "GroupPendingInstances"
    , "GroupDesiredCapacity"
    , "GroupInServiceCapacity"
    , "GroupInServiceInstances"
    , "GroupMaxSize"
    , "WarmPoolPendingCapacity"
    , "WarmPoolTerminatingCapacity"
    , "GroupTerminatingCapacity"
    , "WarmPoolTotalCapacity"
    , "GroupPendingCapacity"
    , "GroupTerminatingInstances"
    , "WarmPoolMinSize"
    , "GroupAndWarmPoolDesiredCapacity"
    , "GroupTotalInstances"
    , "WarmPoolDesiredCapacity"
    , "WarmPoolWarmedCapacity"
    , "GroupAndWarmPoolTotalCapacity"
    , "GroupStandbyCapacity"
    , "GroupTotalCapacity"
    , "GroupMinSize"
    , "GroupStandbyInstances"
  ]
}

# dynamically trigger ASG when avergage cpu % > 70
resource "aws_cloudwatch_metric_alarm" "gte70alarm" {
  alarm_name          = "procore-website-CPUOver80PercentAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  evaluation_periods  = "2"
  statistic           = "Average"
  threshold           = "70"
  alarm_actions       = [aws_autoscaling_policy.sp1.arn]
  dimensions          = { AutoScalingGroupName = aws_autoscaling_group.asg.name }
  tags                = { Name = "procore-website-CPUOver80" }
}

resource "aws_cloudwatch_metric_alarm" "lte20alarm" {
  alarm_name          = "procore-website-CPUUnder20PercentAlarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  evaluation_periods  = "2"
  statistic           = "Average"
  threshold           = "20"
  alarm_actions       = [aws_autoscaling_policy.sp2.arn]
  dimensions          = { AutoScalingGroupName = aws_autoscaling_group.asg.name }
  tags                = { Name = "procore-website-CPUUnder20" }
}

resource "aws_autoscaling_policy" "sp1" {
  name                   = "procore-website-scale-out"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "sp2" {
  name                   = "procore-website-scale-in"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
