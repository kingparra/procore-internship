# This _monster_ is possible to configure.
# Get the output of a manually created pipeline and compare.
# $ aws codepipeline get-pipeline --name procore-website
# Then try to create it and follow the errors.
# Reference for pipeline structure can be found in the output of:
# $ aws codepipeline create-pipeline help
# Also see:
# https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html
resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.AWSCodePipelineServiceRole.arn
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        RepositoryName  = aws_codecommit_repository.procore_website.arn
        BranchName       = "master"
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["SourceArtifact"]
      version         = "1"
      configuration = {
        ApplicationName = aws_codedeploy_app.website.name
        DeploymentGroupName = var.deployment_group_name
      }
    }
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "codepipeline-${var.pipeline_name}"
}