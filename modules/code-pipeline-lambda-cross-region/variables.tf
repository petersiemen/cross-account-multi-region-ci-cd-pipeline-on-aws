variable "name" {}
variable "code_pipeline_role_arn" {}

variable "kms_key_alias_arn" {}
variable "kms_key_alias_arn_eu_west_1" {}

variable "code_commit_repository_name" {}
variable "code_commit_repository_branch_name" {}

variable "code_pipeline_artifacts_bucket" {}
variable "code_pipeline_artifacts_bucket_eu_west_1" {}

variable "code_build_project_name" {}

variable "cloudformation_deploy_role_arn" {}

variable "deploy_stage_parameter_overrides" {}