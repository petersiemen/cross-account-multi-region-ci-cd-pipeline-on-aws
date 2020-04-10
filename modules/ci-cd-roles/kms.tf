
provider "aws" {
  alias = "eu-west-1"
}


resource "aws_kms_grant" "grant-for-codebuild-role" {
  name = "grant-for-deploy"
  key_id = var.kms__key_id
  grantee_principal = aws_iam_role.codebuild-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}

resource "aws_kms_grant" "grant-for-codebuild-role-eu-west-1" {
  provider = aws.eu-west-1

  name = "grant-for-deploy"
  key_id = var.kms__key_id_eu_west_1
  grantee_principal = aws_iam_role.codebuild-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}


resource "aws_kms_grant" "grant-for-codepipeline-role" {

  name = "grant-for-deploy"
  key_id = var.kms__key_id
  grantee_principal = aws_iam_role.codepipeline-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}

resource "aws_kms_grant" "grant-for-codepipeline-role-eu-west-1" {
  provider = aws.eu-west-1

  name = "grant-for-deploy"
  key_id = var.kms__key_id_eu_west_1
  grantee_principal = aws_iam_role.codepipeline-role.arn
  operations = [
    "Encrypt",
    "Decrypt",
    "GenerateDataKey"]
}
