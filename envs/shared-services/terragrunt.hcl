locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

remote_state {
  backend = "s3"
  generate = {
    path = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "homepage-shared-services-terraform-state-new"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    dynamodb_table = "shared-services-terraform-lock"
  }
}

generate "provider" {
  path = "generated-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

provider "aws" {
  region  = "eu-central-1"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::${local.common.inputs.shared_services_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::${local.common.inputs.shared_services_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias = "eu-west-1"
  region = "eu-west-1"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::${local.common.inputs.shared_services_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region  = "eu-central-1"
  alias = "homepage-development"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::${local.common.inputs.development_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region  = "eu-central-1"
  alias = "homepage-production"
  profile = "homepage-master"
  assume_role {
    role_arn  = "arn:aws:iam::${local.common.inputs.production_account_id}:role/OrganizationAccountAccessRole"
  }
}

EOF
}

terraform {

  extra_arguments "common_vars" {
    commands = [
      "plan",
      "apply",
      "destroy",
      "refresh",
      "import"]


    env_vars = {
      TF_VAR_organization = local.common.inputs.organization
      TF_VAR_aws_region = local.common.inputs.aws_region
      TF_VAR_domain = local.common.inputs.domain

      TF_VAR_shared_services_account_id = local.common.inputs.shared_services_account_id
      TF_VAR_shared_services_account_email = local.common.inputs.shared_services_account_email

      TF_VAR_development_account_id = local.common.inputs.development_account_id
      TF_VAR_development_account_email = local.common.inputs.development_account_email

      TF_VAR_production_account_id = local.common.inputs.production_account_id
      TF_VAR_production_account_email = local.common.inputs.production_account_email
    }
  }

}
