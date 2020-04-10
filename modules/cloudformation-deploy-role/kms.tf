provider "aws" {
  alias = "shared-services"
}
provider "aws" {
  alias = "shared-services-eu-west-1"
}


resource "aws_kms_grant" "grant-for-deploy-role" {
  provider = aws.shared-services

  name = "grant-for-deploy"
  key_id = var.kms__key_id
  grantee_principal = aws_iam_role.cloudformation-deploy-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}

resource "aws_kms_grant" "grant-for-deploy-role-eu-west-1" {
  provider = aws.shared-services-eu-west-1

  name = "grant-for-deploy"
  key_id = var.kms__key_id_eu_west_1
  grantee_principal = aws_iam_role.cloudformation-deploy-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}
