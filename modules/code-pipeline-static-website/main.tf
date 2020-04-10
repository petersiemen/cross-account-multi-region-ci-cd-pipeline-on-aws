resource "aws_codepipeline" "codepipeline" {
  name = local.code_pipeline_name
  role_arn = aws_iam_role.codepipeline-role.arn

  artifact_store {
    location = var.code_pipeline_artifacts_bucket
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeCommit"
      version = "1"
      output_artifacts = [
        "source_output"]

      configuration = {
        RepositoryName = var.code_commit_repository_name
        BranchName = var.code_commit_repository_branch_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "source_output"]
      output_artifacts = [
        "build_output"]

      version = "1"

      configuration = {
        ProjectName = var.code_build_project_name
//        EnvironmentVariables = jsonencode([
//          {
//            name = "API_PATH"
//            value = "/api/contact"
//            type = "PLAINTEXT"
//          }
//        ])

      }
    }
  }

  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      name = "Deploy"
      owner = "AWS"
      provider = "S3"
      version = "1"
      input_artifacts = [
        "build_output"]

      configuration = {
        BucketName = var.s3_static_website_bucket_name
        Extract = true
        CannedACL = "public-read"
      }
    }
  }

}
