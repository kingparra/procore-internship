locals {
  schedules = {
    AutoOn = {
      name = "auto_on_during_weekday"
      schedule_expression = "cron(0 5 ? * Mon-Fri *)"
      fn_arn = module.auto_on.lambda_function_arn
    }
    AutoOff = {
      name = "auto_off_during_weekday"
      schedule_expression = "cron(0 20 ? * Mon-Fri *)"
      fn_arn = module.auto_off.lambda_function_arn
    }
  }
}

## create the schedules
resource "aws_scheduler_schedule" "auto" {
  for_each = local.schedules
  name = each.value["name"]
  group_name = "default"
  flexible_time_window {
    mode = "OFF"
  }
  schedule_expression = each.value.schedule_expression
  target {
    arn = each.value["fn_arn"]
    role_arn = aws_iam_role.eb_auto.arn
  }
}

## create the role that allows the schedule to write events to the lambda function
resource "aws_iam_role" "eb_auto" {
  name = "Amazon_EventBridge_Scheduler_LAMBDA_auto"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "scheduler.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
    EOF
}

resource "aws_iam_role_policy" "eb_auto" {
  name = "Amazon-EventBridge-Scheduler-Execution-Policy-auto"
  role = aws_iam_role.eb_auto.id
  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
              "lambda:InvokeFunction"
          ],
          "Resource": [
              "${local.schedules.AutoOn.fn_arn}:*",
              "${local.schedules.AutoOn.fn_arn}",
              "${local.schedules.AutoOff.fn_arn}:*",
              "${local.schedules.AutoOff.fn_arn}"
          ]
        }
      ]
    }
    EOF
}
