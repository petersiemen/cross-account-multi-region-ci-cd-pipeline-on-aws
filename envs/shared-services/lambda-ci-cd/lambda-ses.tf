module "lambda-ses-code-commit" {
  source = "../../../modules/code-commit"
  name = local.lambda_ses
}

module "lambda-ses-code-build" {
  source = "../../../modules/code-build-lambda"

  code_build_role_arn = module.ci-cd-roles.code_build_role_arn
  code_build_artifacts_bucket = module.code-build-artifacts.bucket
  code_commit_clone_url_http = module.lambda-ses-code-commit.clone_url_http

  name = local.lambda_ses
}

module "lambda-ses-code-pipeline-develop-to-development" {
  source = "../../../modules/code-pipeline-lambda"
  code_pipeline_role_arn = module.ci-cd-roles.code_pipeline_role_arn


  kms_key_alias_arn = var.kms__key_alias_arn

  code_commit_repository_name = module.lambda-ses-code-commit.repository_name
  code_commit_repository_branch_name = "develop"

  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket

  code_build_project_name = module.lambda-ses-code-build.project_name

  cloudformation_deploy_role_arn = module.cloudformation-deploy-role-for-development.arn

  deploy_stage_parameter_overrides = jsonencode({
    EMAIL: var.development_account_email
  })

  name = "${local.lambda_ses}-develop-to-development"

}

module "lambda-ses-code-pipeline-master-to-production" {
  source = "../../../modules/code-pipeline-lambda"
  code_pipeline_role_arn = module.ci-cd-roles.code_pipeline_role_arn

  kms_key_alias_arn = var.kms__key_alias_arn

  code_commit_repository_name = module.lambda-ses-code-commit.repository_name
  code_commit_repository_branch_name = "master"

  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket

  code_build_project_name = module.lambda-ses-code-build.project_name

  cloudformation_deploy_role_arn = module.cloudformation-deploy-role-for-production.arn

  deploy_stage_parameter_overrides = jsonencode({
    EMAIL: var.production_account_email
  })

  name = "${local.lambda_ses}-master-to-production"
}