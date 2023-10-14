# Create the trail. This keeps track of API events.
resource "aws_cloudtrail" "trail" {
  name = var.trial_name
  # mandatory - an s3 bucket to log to
  s3_bucket_name = aws_s3_bucket.logs.id
  # A CloudWatch log group to log to.
  # aws_cloudwatch_log_group.group.arn "arn:aws:logs:us-east-1:496206821618:log-group:YT-IAM-Trail-Logs2"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.group.arn}:*"
  # A role that allows the CloudTrail service to log to the CloudWatch log group.
  cloud_watch_logs_role_arn = aws_iam_role.log_group_role.arn
  enable_log_file_validation = true
}


# Create an s3 bucket to act as a destination for the trail.
resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
  force_destroy = true
}

# Create a policy that allows the trail to write to the bucket.
module "bucket_policy_document" {
  source = "./modules/bucket_policy_document"
  trail_arn = aws_cloudtrail.trail.arn
  bucket_arn = aws_s3_bucket.logs.arn
}

# Attach the policy to the bucket.
resource "aws_s3_bucket_policy" "attachment" {
  bucket = aws_s3_bucket.logs.id
  policy = module.bucket_policy_document.policy_document_json
}

# Create a CloudWatch log group to send the trail output to.
resource "aws_cloudwatch_log_group" "group" {
  name = var.log_group_name
  retention_in_days = var.log_group_retention_days
}

# Filter for the log group events
resource "aws_cloudwatch_log_metric_filter" "filter" {
  name = "iam_events_filter"
  pattern = "{$.eventSource = \"iam.amazonaws.com\"}"
  log_group_name = aws_cloudwatch_log_group.group.id
  metric_transformation {
    name = var.metric_name
    namespace = var.metric_namespace_name
    value = "1"
    unit = "Count"
  }
}

# Create a role to talk to the log group.
resource "aws_iam_role" "log_group_role" {
  # Role that will be assumed by cloudtrail to log to the cloudwatch log group.
  name = local.log_group_role_name
  assume_role_policy = data.aws_iam_policy_document.log_group_role_assume_policy.json
  inline_policy {
    name = "allow_writes_to_log_group_policy"
    policy = data.aws_iam_policy_document.cwl_policy.json
  }
}

# Create an sts:assumeRole policy document for the role.
data "aws_iam_policy_document" "log_group_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

# Create a policy that will allow the role to talk to the log group.
data "aws_iam_policy_document" "cwl_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
      ]
    resources = [
      "${aws_cloudwatch_log_group.group.arn}:*",
    ]
  }
}

# Create an sns topic, "Procore-plus-IAM-changes-kingparra-POC"
resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
}

# Subscribe "chris@kingparra.work" and "procoreplus@gmail.com" to the sns topic.
resource "aws_sns_topic_subscription" "subs" {
  for_each = toset(var.emails)
  topic_arn = aws_sns_topic.topic.arn
  protocol = "email"
  endpoint = each.key
}

# Create an alarm
resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name = var.alarm_name
  namespace = var.metric_namespace_name
  # if the iam event count is > 1
  metric_name = "${var.metric_namespace_name}/${var.metric_name}"
  comparison_operator = "GreaterThanThreshold"
  # with five minutes
  evaluation_periods = 5
  period = 60
  # for the sum of all event counts
  statistic = "Sum"
  treat_missing_data = "ignore"
  alarm_actions = [aws_sns_topic.topic.arn]
}