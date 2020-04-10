resource "aws_codebuild_project" "codebuild" {
  name = local.code_build_name
  service_role = var.code_build_role_arn

  artifacts {
    type = "S3"
    location = var.code_build_artifacts_bucket
    namespace_type = "BUILD_ID"
    name = var.name
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:3.0"
    type = "LINUX_CONTAINER"

    environment_variable {
      name = "BUCKET"
      value = var.code_build_artifacts_bucket
    }
  }

  source {
    type = "CODECOMMIT"
    location = var.code_commit_clone_url_http
    git_clone_depth = 1
  }

}
