variable "aws_region" {}
variable "development_account_id" {}

module "lambda-ses-api-gateway" {
  source = "../../../modules/api-gateway"
  aws_region = var.aws_region
  aws_account_id = var.development_account_id

  name = "contact"
  lambda_function_name = "lambda-ses"
}

