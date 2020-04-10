variable "shared_services_account_id" {}
variable "domain" {}

variable "certificates__acm_certification_arn" {}
variable "s3_static_website__bucket_name" {}
variable "s3_static_website__website_endpoint" {}
variable "s3_static_website__bucket_regional_domain_name" {}

variable "api_gateway__deployment_invoke_url" {}

module "cloudfront-no-cache" {
  source = "../../../modules/cloudfront-no-cache"
  acm_certification_arn = var.certificates__acm_certification_arn
  aliases = [
    "www.${var.s3_static_website__bucket_name}",
    var.s3_static_website__bucket_name
  ]
  website_endpoint = var.s3_static_website__website_endpoint
  bucket_regional_domain_name = var.s3_static_website__bucket_regional_domain_name

  api_gateway_deployment_invoke_url = var.api_gateway__deployment_invoke_url

  name = var.s3_static_website__bucket_name
}


data "aws_route53_zone" "main" {
  provider = aws.shared-services
  name = var.domain
}

resource "aws_route53_record" "www" {
  provider = aws.shared-services
  zone_id = data.aws_route53_zone.main.zone_id
  name = "www"
  type = "A"

  alias {
    name = module.cloudfront-no-cache.domain_name
    zone_id = module.cloudfront-no-cache.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex" {
  provider = aws.shared-services
  zone_id = data.aws_route53_zone.main.zone_id
  name = ""
  type = "A"

  alias {
    name = module.cloudfront-no-cache.domain_name
    zone_id = module.cloudfront-no-cache.hosted_zone_id
    evaluate_target_health = false
  }
}
