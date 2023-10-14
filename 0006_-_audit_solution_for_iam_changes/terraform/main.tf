# Create the trail. This keeps track of API events.
resource "aws_cloudtrail" "trail" {
  name = var.trial_name
  # mandatory - an s3 bucket to log to
  s3_bucket_name = aws_s3_bucket.logs.id
  # A CloudWatch log group to log to.
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.group.arn
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
}

# Filter for the log group events
resource "aws_cloudwatch_log_metric_filter" "filter" {
  name = "iam_events_filter"
  pattern = var.metric_filter_pattern
  log_group_name = aws_cloudwatch_log_group.group.id
  metric_transformation {
    name = "iam_event_count"
    namespace = "iam_events"
    value = "1"
    unit = "Count"
  }
}

# Create a role to talk to the log group.
resource "aws_iam_role" "log_group_role" {
  # Role that will be assumed by cloudtrail to log to the cloudwatch log group.
  name = "RoleForCloudtailToLogTo_${var.log_group_name}"
  # Create an sts:assumeRole policy document for the role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid = "TalkToLogGroup"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action = "sts:AssumeRole"
      Effect = "Allow"
    }]
  })
  # Attach policy that allows logging.
  inline_policy {
    name = "allow_writes_to_log_group_policy"
    # Create a policy that will allow the role to talk to the log group.
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [aws_cloudwatch_log_group.group.arn]
      }]
    })
  }
}

# Create an sns topic, "Procore-plus-IAM-changes-kingparra-POC"

# Subscribe "chris@kingparra.work" to the sns topic.

# Create a metric alarm with pattern { ($.eventSource = "iam.amazonaws.com") }.
# Send alarm events to the topic.

# Send the output of the trail to both the bucket (mandatory) and the log group (optional).