During this ticket I encountered a few problems. 

First, I wasn't sure how to filter the events. The events are filtered by though the log group settings, using the aws_cloudwatch_log_metric_filter resource.

Second, I wasn't sure what I should do with the events in the metric filter. At first I thought I should extract some fields and send it with the alarms email. It turns out that I should be counting the number of events: the alarm will trigger whenever it increments. Then the admin will get an email and they can look at the log stream to review.

Third, I found out that there is a race condition for sns topics. If you delete a topic and create a new one with the same name, then the subscription information that is retrieved will be from the old topic. So I have to create a new topic name every run.

Finally, I ran into an issue where the trail resource could not be created, because the way I computer the bucket policy depends on the bucket and trail resources to get the arns. There was a cycle. Terraform would sometimes create the bucket, but not the bucket policy. It would not create the trail. I would get an error like this:
╷
│ Error: creating CloudTrail: InsufficientS3BucketPolicyException: Incorrect S3 bucket policy is detected for bucket: pp-iam-trail-logs-bucket-evergreen-perigrinate3
│ 
│   with module.cloudtrail.aws_cloudtrail.default[0],
│   on .terraform/modules/cloudtrail/main.tf line 1, in resource "aws_cloudtrail" "default":
│    1: resource "aws_cloudtrail" "default" {
│

https://docs.aws.amazon.com/awscloudtrail/latest/userguide/monitor-cloudtrail-log-files-with-cloudwatch-logs.html.

https://registry.terraform.io/modules/cloudposse/cloudtrail/aws/latest

https://github.com/rhythmictech/terraform-aws-cloudtrail-logging

I haven't gotten the Terraform code to work yet, but it doesn't make sense to spend more time one this. I have a time limit. Instead I set it up manually and recorded a video of the process.