resource "aws_iam_role" "codepipeline-role" {
  name = "${local.code_pipeline_name}-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "codepipeline-policy" {
  name = "${local.code_pipeline_name}-policy"
  role = aws_iam_role.codepipeline-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.code_pipeline_artifacts_arn}",
        "${var.code_pipeline_artifacts_arn}/*",
        "${var.s3_static_website_bucket_arn}",
        "${var.s3_static_website_bucket_arn}/*"
      ]
    },
    {
      "Action": [
        "codecommit:CancelUploadArchive",
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:UploadArchive",
        "codecommit:GitPull"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Resource": [
          "*"
      ],
      "Action": [
          "codecommit:GitPull"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
