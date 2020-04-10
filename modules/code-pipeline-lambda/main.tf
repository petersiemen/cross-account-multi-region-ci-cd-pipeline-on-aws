resource "aws_codepipeline" "codepipeline" {
  name = local.code_pipeline_name
  role_arn = var.code_pipeline_role_arn

  artifact_store {
    location = var.code_pipeline_artifacts_bucket
    type = "S3"

    encryption_key {
      id = var.kms_key_alias_arn
      type = "KMS"
    }
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
      }

    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "CloudFormation"
      input_artifacts = [
        "build_output"]
      version = "1"

      role_arn = var.cloudformation_deploy_role_arn
      configuration = {
        ActionMode = "REPLACE_ON_FAILURE"
        Capabilities = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        OutputFileName = "CreateStackOutput.json"
        StackName = local.code_pipeline_name
        TemplatePath = "build_output::packaged-template.yaml"
        RoleArn = var.cloudformation_deploy_role_arn

        ParameterOverrides = var.deploy_stage_parameter_overrides
      }
    }
  }


}
