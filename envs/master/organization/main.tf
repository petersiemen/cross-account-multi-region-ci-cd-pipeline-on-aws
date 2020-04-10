# terragrunt import aws_organizations_organization.org xxxxx
resource "aws_organizations_organization" "org" {
  feature_set = "ALL"

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY"
  ]
  aws_service_access_principals = [
    "tagpolicies.tag.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "config.amazonaws.com",
    "fms.amazonaws.com",
    "sso.amazonaws.com",
  ]
}

#terragrunt import aws_organizations_account.shared-services xxxxx
resource "aws_organizations_account" "shared-services" {
  name = "shared-services"
  email = var.shared_services_account_email
}

#terragrunt import aws_organizations_account.development xxxxx
resource "aws_organizations_account" "development" {
  name = "development"
  email = var.development_account_email
}

#terragrunt import aws_organizations_account.production xxxxx
resource "aws_organizations_account" "production" {
  name = "production"
  email = var.production_account_email
}
