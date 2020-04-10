variable "production_account_email" {}
variable "production_account_id" {}
variable "domain" {}


module "ses" {
  providers = {
    aws = aws.eu-west-1
    aws.shared-services = aws.shared-services
  }

  source = "../../../modules/ses"
  email_address = var.production_account_email
  domain = var.domain
  domain_identity = "${var.domain}"
  bucket_name = "mail.${var.domain}"
  aws_region = "eu-west-1"
  aws_account_id = var.production_account_id
  lambda_function_name = "lambda-mail-forwarder"
}

