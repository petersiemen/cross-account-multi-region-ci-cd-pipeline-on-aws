locals {
  bucket_name = "${var.organization}-${var.name}-code-pipeline"
}

resource "aws_s3_bucket" "code-pipeline-artifacts" {
  bucket = local.bucket_name
  acl = "private"
  force_destroy = true
}
