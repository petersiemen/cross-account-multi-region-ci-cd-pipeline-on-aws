module "lambda-mail-forwarder-code-commit" {
  source = "../../../modules/code-commit"
  name = local.lambda_mail_forwarder
}

module "lambda-mail-forwarder-code-build" {
  source = "../../../modules/code-build-lambda"

  code_build_role_arn = module.ci-cd-roles.code_build_role_arn
  code_build_artifacts_bucket = module.code-build-artifacts-eu-west-1.bucket
  code_commit_clone_url_http = module.lambda-ses-code-commit.clone_url_http

  name = local.lambda_mail_forwarder
}

module "lambda-mail-forwarder-code-pipeline-develop-to-development" {
  source = "../../../modules/code-pipeline-lambda-cross-region"
  code_pipeline_role_arn = module.ci-cd-roles.code_pipeline_role_arn
  kms_key_alias_arn = var.kms__key_alias_arn
  kms_key_alias_arn_eu_west_1 = var.kms__key_alias_arn_eu_west_1

  code_commit_repository_name = module.lambda-mail-forwarder-code-commit.repository_name
  code_commit_repository_branch_name = "develop"

  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
  code_pipeline_artifacts_bucket_eu_west_1 = module.code-pipeline-artifacts-eu-west-1.bucket

  code_build_project_name = module.lambda-mail-forwarder-code-build.project_name

  cloudformation_deploy_role_arn = module.cloudformation-deploy-role-for-development.arn

  deploy_stage_parameter_overrides = jsonencode({
    EMAIL: var.development_account_email
    BUCKET: "mail.preview.petersiemen.net"
  })

  name = "${local.lambda_mail_forwarder}-develop-to-development"
}


module "lambda-mail-forwarder-code-pipeline-develop-to-production" {
  source = "../../../modules/code-pipeline-lambda-cross-region"
  code_pipeline_role_arn = module.ci-cd-roles.code_pipeline_role_arn
  kms_key_alias_arn = var.kms__key_alias_arn
  kms_key_alias_arn_eu_west_1 = var.kms__key_alias_arn_eu_west_1

  code_commit_repository_name = module.lambda-mail-forwarder-code-commit.repository_name
  code_commit_repository_branch_name = "master"

  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
  code_pipeline_artifacts_bucket_eu_west_1 = module.code-pipeline-artifacts-eu-west-1.bucket

  code_build_project_name = module.lambda-mail-forwarder-code-build.project_name

  cloudformation_deploy_role_arn = module.cloudformation-deploy-role-for-production.arn

  deploy_stage_parameter_overrides = jsonencode({
    EMAIL: var.production_account_email
    BUCKET: "mail.petersiemen.net"
  })

  name = "${local.lambda_mail_forwarder}-master-to-production"
}
