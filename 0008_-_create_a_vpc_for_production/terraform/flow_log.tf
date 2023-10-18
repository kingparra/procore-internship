# WARN: Traffic is not being recorded in the log group, and I'm not sure why.

# https://docs.aws.amazon.com/vpc/latest/tgw/flow-logs-cwl.html

# Seems like I can either log to a bucket of log group, but not both.
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-flowlog.html <-- See LogDestination{,Type}
resource "aws_flow_log" "flow" {
  log_destination = aws_cloudwatch_log_group.lg.arn
  iam_role_arn = aws_iam_role.cwl_role.arn
  traffic_type = "ALL"
  vpc_id = module.vpc.vpc_id
  max_aggregation_interval = 60 # 1 minute 
  tags = {
    "Name" = "${var.vpc_name_prefix}_flow_log"
  }
}

resource "aws_iam_role" "cwl_role" {
  name               = "VpcFlowLogRoleForCloudWatch-${var.vpc_name_prefix}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role = aws_iam_role.cwl_role.name
  policy_arn = aws_iam_policy.cwl_policy.arn
}

resource "aws_iam_policy" "cwl_policy" {
  policy = data.aws_iam_policy_document.cwl_policy_document.json
  name = "write_to_cloudwatch_log_group"
}

data "aws_iam_policy_document" "cwl_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      # Cannot create log stream with only the permissions below.
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DeleteLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      # added by me
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_cloudwatch_log_group" "lg" {
  name = "${var.vpc_name_prefix}_log_group"
  retention_in_days = 30  
}


# Get the account number
data "aws_caller_identity" "current" {}

locals {
  account_number = data.aws_caller_identity.current.account_id
  flow_log_bucket_name = "flow-logs-${local.account_number}"
}

resource "aws_s3_bucket" "flow_bucket" {
  bucket = local.flow_log_bucket_name
}

# Create another flow log that logs to S3
resource "aws_flow_log" "flowS3" {
  log_destination = aws_s3_bucket.flow_bucket.arn
  log_destination_type = "s3"
  traffic_type = "ALL"
  vpc_id = module.vpc.vpc_id
  max_aggregation_interval = 60 # 1 minute 
  destination_options {
    file_format = "plain-text"
  }
  tags = {
    "Name" = "${var.vpc_name_prefix}_flow_log_s3"
  }
}
