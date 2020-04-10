provider "aws" {
  alias = "us-east-1"
}

provider "aws" {
  alias = "shared-services"
}


data "aws_route53_zone" "main" {
  provider = aws.shared-services
  count = length(var.zones)
  name = var.zones[count.index]
}

resource "aws_acm_certificate" "certificate" {
  provider = aws.us-east-1
  domain_name = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_acm_certificate_validation" "validation" {
  provider = aws.us-east-1
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = aws_route53_record.validation_record[*].fqdn
}

resource "aws_route53_record" "validation_record" {
  provider = aws.shared-services
  count = length(var.zones)
  name = lookup(aws_acm_certificate.certificate.domain_validation_options[count.index], "resource_record_name")
  type = lookup(aws_acm_certificate.certificate.domain_validation_options[count.index], "resource_record_type")
  zone_id = element(data.aws_route53_zone.main.*.zone_id, count.index)
  records = [
    lookup(aws_acm_certificate.certificate.domain_validation_options[count.index], "resource_record_value")]
  ttl = 60
}
