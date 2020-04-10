locals {
  bucket_name = "${var.organization}-${var.name}-code-build"
}

resource "aws_s3_bucket" "code-build-artifacts" {
  bucket = local.bucket_name
  acl = "private"
  force_destroy = true
}
