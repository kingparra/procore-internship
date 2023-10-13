variable "bucket_name" {
  default = "pp-iam-trail-logs-bucket-evergreen-perigrinate"
}

variable "trial_name" {
  default = "YT-IAM-Trail"
}

variable "log_group_name" {
  default = "YT-IAM-Trail-Logs"
}

variable "metric_filter_name" {
  default = "iam_events_filter"
}

variable "sns_topic_name" {
  default = "Procore-plus-IAM-changes-kingparra-POC"
}

variable "company_email" {
  default = "procoreplus@gmail.com"
}

variable "personal_email" {
  
}

variable "metric_filter_pattern" {
  # This is part of the log group, not the alarm.
  default = "{($.eventSource = \"iam.amazonaws.com\")}"
}

