terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.20"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create the trail, name it "YT-IAM-Trail".

# Create an s3 bucket to act as a destination for that trail. Suggested name "pp-iam-trail-Logs-bucket-evergreen-perigrinate".

# Create a kms key for that bucket.

# Create a role to talk to the log group.

# Create an sts:assumeRole policy document for the role.

# Create the cloudwatc log group, name it "PP-IAM-Trail-Logs".

# Send the output of the trail to the log group.

# Create an sns topic, "Procore-plus-IAM-changes-kingparra-POC"

# Subscribe "chris@kingparra.work" to the sns topic.

# Create a metric alarm with pattern { ($.eventSource = "iam.amazonaws.com") }.
# Send alarm events to the topic.

# Send the output of the trail to both the bucket (mandatory) and the log group (optional).