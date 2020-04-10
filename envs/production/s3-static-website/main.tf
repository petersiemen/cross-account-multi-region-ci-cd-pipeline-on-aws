variable "shared_services_account_id" {}
variable "domain" {}

module "s3-static-website" {
  source = "../../../modules/s3-static-website"
  bucket_name = var.domain
  shared_services_account_id = var.shared_services_account_id
}