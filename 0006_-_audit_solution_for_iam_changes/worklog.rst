Oct 11th 2023
-------------
* 17:59 PM EST - Create backend, project dir, readme. Carefully read through the tickets subtasks.
* 18:00 PM EST - Looking up how to ensure that CloudTrail is enabled. I guess if you can't create a trail, it's off. Looking up how to create a trail using Terraform.
* 18:15 PM EST - Coding the trail and supporting resources from example here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail
* 18:23 PM EST - Clocking out and dinner, will continue tomorrow.

Oct 12th 2023
-------------
* 15:19 PM EST - Created a diagram, added it to the readme.
* 15:20 PM EST - Found a module to create the trail, bucket, kms key, role, and log group. Tested resource creation. Still need a sns topic, alarm, and email subscription.
* 15:21 PM EST - Doing the whole thing manually one time. This is taking a long time.
* 17:00 PM EST - I'm not sure where to add the pattern to the metric alarm. I'm stuck.

Oct 13th 2023
-------------
* 13:17 PM EST - The pattern goes in the "metric filter" section of the log group. It isn't part of the alarm itself. You want the resource aws_cloudwatch_log_metric_filter.