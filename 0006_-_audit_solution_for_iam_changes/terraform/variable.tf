variable "bucket_name" {
  default = "pp-iam-trail-logs-bucket-evergreen-perigrinate2"
}

variable "trial_name" {
  default = "YT-IAM-Trail2"
}

variable "log_group_name" {
  default = "YT-IAM-Trail-Logs2"
}

variable "log_group_retention_days" {
  default = 30
}

locals { 
  log_group_role_name = "RoleForCloudtailToLogTo_${var.log_group_name}2"
}

variable "sns_topic_name" {
  default = "Procore-plus-IAM-changes-kingparra-POC2"
}

variable "metric_namespace_name" {
  default = "iam_events2"
}

variable "metric_name" {
  default = "iam_event_count2"
}

variable "alarm_name" {
  default = "iam_event_count_alarm2"
}

variable "emails" {
  default = ["procoreplus@gmail.com", "chris@kingparra.work"]
  type = list
}
