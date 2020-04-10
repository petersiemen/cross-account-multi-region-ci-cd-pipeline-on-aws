resource "aws_iam_role" "codepipeline-role" {
  name = "${var.name}-code-pipeline-role"

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
  role = aws_iam_role.codepipeline-role.id
  name = "${var.name}-code-pipeline-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": ["kms:*"],
      "Resource": "*"
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Condition": {
        "StringEqualsIfExists": {
          "iam:PassedToService": [
            "cloudformation.amazonaws.com"
          ]
        }
      }
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.code_pipeline_artifacts_arn}",
        "${var.code_pipeline_artifacts_arn}/*",
        "${var.code_pipeline_artifacts_arn_eu_west_1}",
        "${var.code_pipeline_artifacts_arn_eu_west_1}/*"
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
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sts:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

