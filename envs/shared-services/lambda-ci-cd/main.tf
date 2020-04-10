variable "organization" {}
variable "shared_services_account_id" {}
variable "development_account_id" {}
variable "development_account_email" {}
variable "production_account_id" {}
variable "production_account_email" {}
variable "aws_region" {}

variable "kms__key_id" {}
variable "kms__key_alias_arn" {}
variable "kms__key_id_eu_west_1" {}
variable "kms__key_alias_arn_eu_west_1" {}


module "code-build-artifacts" {
  source = "../../../modules/code-build-artifacts"
  organization = var.organization
  name = "lambda"
}

module "code-build-artifacts-eu-west-1" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../../modules/code-build-artifacts"
  organization = var.organization
  name = "lambda-eu-west-1"
}


module "code-pipeline-artifacts" {
  source = "../../../modules/code-pipeline-artifacts"
  organization = var.organization
  name = "lambda"
}


module "code-pipeline-artifacts-eu-west-1" {
  providers = {
    aws = aws.eu-west-1
  }
  source = "../../../modules/code-pipeline-artifacts"
  organization = var.organization
  name = "lambda-eu-west-1"
}

module "ci-cd-roles" {
  providers = {
    aws.eu-west-1 = aws.eu-west-1
  }
  source = "../../../modules/ci-cd-roles"
  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  code_build_artifacts_arn_eu_west_1 = module.code-build-artifacts-eu-west-1.arn
  code_pipeline_artifacts_arn_eu_west_1 = module.code-pipeline-artifacts-eu-west-1.arn

  kms__key_id = var.kms__key_id
  kms__key_id_eu_west_1 = var.kms__key_id_eu_west_1

  name = "lambda"
}


module "cloudformation-deploy-role-for-development" {
  providers = {
    aws = aws.homepage-development
    aws.shared-services = aws
    aws.shared-services-eu-west-1 = aws.eu-west-1
  }
  source = "../../../modules/cloudformation-deploy-role"
  shared_services_account_id = var.shared_services_account_id
  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  code_build_artifacts_arn_eu_west_1 = module.code-build-artifacts-eu-west-1.arn
  code_pipeline_artifacts_arn_eu_west_1 = module.code-pipeline-artifacts-eu-west-1.arn

  kms__key_id = var.kms__key_id
  kms__key_id_eu_west_1 = var.kms__key_id_eu_west_1
}

module "cloudformation-deploy-role-for-production" {
  providers = {
    aws = aws.homepage-production
    aws.shared-services = aws
    aws.shared-services-eu-west-1 = aws.eu-west-1
  }
  source = "../../../modules/cloudformation-deploy-role"
  shared_services_account_id = var.shared_services_account_id
  code_build_artifacts_arn = module.code-build-artifacts.arn
  code_pipeline_artifacts_arn = module.code-pipeline-artifacts.arn
  code_build_artifacts_arn_eu_west_1 = module.code-build-artifacts-eu-west-1.arn
  code_pipeline_artifacts_arn_eu_west_1 = module.code-pipeline-artifacts-eu-west-1.arn

  kms__key_id = var.kms__key_id
  kms__key_id_eu_west_1 = var.kms__key_id_eu_west_1
}


module "artifacts-bucket-policy" {
  providers = {
    aws = aws
    aws.eu-west-1 = aws.eu-west-1
  }
  source = "../../../modules/artifacts-bucket-policy"
  code_build_artifacts_bucket = module.code-build-artifacts.bucket
  code_build_artifacts_id = module.code-build-artifacts.id

  code_build_artifacts_bucket_eu_west_1 = module.code-build-artifacts-eu-west-1.bucket
  code_build_artifacts_id_eu_west_1 = module.code-build-artifacts-eu-west-1.id

  code_build_role_arn = module.ci-cd-roles.code_build_role_arn

  code_pipeline_artifacts_bucket = module.code-pipeline-artifacts.bucket
  code_pipeline_artifacts_id = module.code-pipeline-artifacts.id

  code_pipeline_artifacts_bucket_eu_west_1 = module.code-pipeline-artifacts-eu-west-1.bucket
  code_pipeline_artifacts_id_eu_west_1 = module.code-pipeline-artifacts-eu-west-1.id

  code_pipeline_role_arn = module.ci-cd-roles.code_pipeline_role_arn
  development_account_id = var.development_account_id
  production_account_id = var.production_account_id

}