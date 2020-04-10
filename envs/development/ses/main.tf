variable "development_account_id" {}
variable "development_account_email" {}
variable "domain" {}


module "ses" {
  providers = {
    aws = aws.eu-west-1
    aws.shared-services = aws.shared-services
  }

  source = "../../../modules/ses"
  email_address = var.development_account_email
  domain = var.domain
  domain_identity = "preview.${var.domain}"
  bucket_name = "mail.preview.${var.domain}"
  aws_region = "eu-west-1"
  aws_account_id = var.development_account_id
  lambda_function_name = "lambda-mail-forwarder"
}

