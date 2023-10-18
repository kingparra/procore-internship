locals {
  
  trail_arn = "arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.trail_name}"

  log_stream_path = "${var.bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"

  # log_stream_path = "arn:aws:s3:::pp-iam-trail-logs-bucket-evergreen-perigrinate3/AWSLogs/496206821618/*"
}
