data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "bucket_policy" {
  # This policy allows the cloudtrail service
  # to run s3:GetBucketAcl and s3:PutObject but
  # only if the source ARN is from the specified trail.
  statement {
    sid = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]
    resources = [var.bucket_arn]
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [var.trail_arn]
    }
  }

  statement {
    sid = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = ["${var.bucket_arn}/*"]

    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [var.trail_arn]
    }
  }
}
