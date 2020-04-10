resource "aws_iam_role" "cloudformation-deploy-role" {
  name = "cloudformation-deploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudformation.amazonaws.com"
      },
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.shared_services_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "deploy-policy" {
  name = "cloudformation-deploy-role-policy"
  role = aws_iam_role.cloudformation-deploy-role.id

  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "logs:*"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "s3:GetObject",
          "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Action": [
        "kms:*",
        "apigateway:*",
        "codedeploy:*",
        "lambda:*",
        "cloudformation:*",
        "iam:GetRole",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:PutRolePolicy",
        "iam:AttachRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PassRole",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.code_build_artifacts_arn}",
        "${var.code_build_artifacts_arn}/*",
        "${var.code_pipeline_artifacts_arn}",
        "${var.code_pipeline_artifacts_arn}/*",
        "${var.code_build_artifacts_arn_eu_west_1}",
        "${var.code_build_artifacts_arn_eu_west_1}/*",
        "${var.code_pipeline_artifacts_arn_eu_west_1}",
        "${var.code_pipeline_artifacts_arn_eu_west_1}/*"
      ]
    }
  ]
}
EOF
}
