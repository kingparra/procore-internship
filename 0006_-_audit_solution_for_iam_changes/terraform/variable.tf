variable "bucket_name" {
  default = "pp-iam-trail-logs-bucket-evergreen-perigrinate3"
}

variable "trial_name" {
  default = "YT-IAM-Trail3"
}

variable "log_group_name" {
  default = "YT-IAM-Trail-Logs3"
}

variable "log_group_retention_days" {
  default = 30
}

variable "sns_topic_name" {
  default = "Procore-plus-IAM-changes-kingparra-POC3"
}

variable "metric_namespace_name" {
  default = "iam_events3"
}

variable "metric_name" {
  default = "iam_event_count3"
}

variable "alarm_name" {
  default = "iam_event_count_alarm3"
}

variable "emails" {
  default = ["procoreplus@gmail.com", "chris@kingparra.work"]
  type = list
}
