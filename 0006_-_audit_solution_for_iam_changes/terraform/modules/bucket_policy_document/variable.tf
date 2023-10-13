variable "trail_arn" {
  description = "ARN of the CloudTrail trail that will be allowed to perform s3:PutObject and s3:GetBucketAcl on the bucket."
}

variable "bucket_arn" {
  description = "ARN of the bucket that will be logged to by the CloudTrail trail."
}