provider "aws" {
  alias = "eu-west-1"
}
resource "aws_s3_bucket_policy" "code-pipeline-artifacts-bucket-policy" {
  bucket = var.code_pipeline_artifacts_id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": [
              "arn:aws:iam::${var.production_account_id}:root",
              "arn:aws:iam::${var.development_account_id}:root",
              "${var.code_pipeline_role_arn}"
            ]
        },
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::${var.code_pipeline_artifacts_bucket}",
            "arn:aws:s3:::${var.code_pipeline_artifacts_bucket}/*"
        ]
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_policy" "code-build-artifacts-bucket-policy" {
  bucket = var.code_build_artifacts_id


  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": [
               "arn:aws:iam::${var.production_account_id}:root",
              "arn:aws:iam::${var.development_account_id}:root",
              "${var.code_pipeline_role_arn}"
              ]
        },
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::${var.code_build_artifacts_bucket}",
            "arn:aws:s3:::${var.code_build_artifacts_bucket}/*"
        ]
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_policy" "code-pipeline-artifacts-bucket-policy-eu-west-1" {
  bucket = var.code_pipeline_artifacts_id_eu_west_1
  provider = aws.eu-west-1

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": [
              "arn:aws:iam::${var.production_account_id}:root",
              "arn:aws:iam::${var.development_account_id}:root",
              "${var.code_pipeline_role_arn}"
            ]
        },
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::${var.code_pipeline_artifacts_bucket_eu_west_1}",
            "arn:aws:s3:::${var.code_pipeline_artifacts_bucket_eu_west_1}/*"
        ]
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_policy" "code-build-artifacts-bucket-policy-eu-west-1" {
  bucket = var.code_build_artifacts_id_eu_west_1
  provider = aws.eu-west-1

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": [
               "arn:aws:iam::${var.production_account_id}:root",
              "arn:aws:iam::${var.development_account_id}:root",
              "${var.code_pipeline_role_arn}"
              ]
        },
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::${var.code_build_artifacts_bucket_eu_west_1}",
            "arn:aws:s3:::${var.code_build_artifacts_bucket_eu_west_1}/*"
        ]
    }
  ]
}
POLICY
}



