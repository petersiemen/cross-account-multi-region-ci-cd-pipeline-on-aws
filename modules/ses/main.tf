provider "aws" {
  alias = "shared-services"
}

data "aws_route53_zone" "main" {
  provider = aws.shared-services
  name = var.domain
}

resource "aws_ses_email_identity" "email" {
  email = var.email_address
}

resource "aws_ses_domain_identity" "domain-identity" {
  domain = var.domain_identity
}

resource "aws_route53_record" "amazonses_verification_record" {
  provider = aws.shared-services
  zone_id = data.aws_route53_zone.main.zone_id
  name = "_amazonses.${var.domain_identity}"
  type = "TXT"
  ttl = "60"
  records = [
    aws_ses_domain_identity.domain-identity.verification_token]
}

resource "aws_route53_record" "alternate_verification_record" {
  provider = aws.shared-services
  zone_id = data.aws_route53_zone.main.zone_id
  name = var.domain_identity
  type = "TXT"
  ttl = "60"
  records = [
    "amazonses:${aws_ses_domain_identity.domain-identity.verification_token}"]
}

resource "aws_route53_record" "mx" {
  provider = aws.shared-services
  zone_id = data.aws_route53_zone.main.zone_id
  name = var.domain_identity
  type = "MX"
  ttl = "60"
  records = [
    "10 inbound-smtp.${var.aws_region}.amazonaws.com"]
}


resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl = "private"

  force_destroy = true

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSESPuts",
            "Effect": "Allow",
            "Principal": {
                "Service": "ses.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
EOF
}


resource "aws_ses_receipt_rule_set" "main" {
  rule_set_name = "primary-rules"
}

# Add a header to the email and store it in S3
resource "aws_ses_receipt_rule" "store" {
  depends_on = [
    aws_lambda_permission.allow_ses]
  name = "store"
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name

  recipients = [
    "mail@${var.domain_identity}"]
  enabled = true
  scan_enabled = true


  s3_action {
    bucket_name = aws_s3_bucket.bucket.bucket
    position = 1
  }

  lambda_action {
    function_arn = "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.lambda_function_name}"
    position = 0
  }
}

resource "aws_ses_active_receipt_rule_set" "main" {
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
}

# Allow SES to start this lambda
resource "aws_lambda_permission" "allow_ses" {
  statement_id = "AllowExecutionFromSES"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal = "ses.amazonaws.com"
}