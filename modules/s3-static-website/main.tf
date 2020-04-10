locals {
  subdomain_bucket_name = "www.${var.bucket_name}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl = "public-read"

  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        },
        {
            "Sid": "ReadWriteFromSharedServices",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${var.shared_services_account_id}:root"
            },
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
POLICY
}


resource "aws_s3_bucket" "redirect-bucket" {
  bucket = local.subdomain_bucket_name
  acl = "public-read"

  force_destroy = true

  website {

    redirect_all_requests_to = var.bucket_name

  }
}
