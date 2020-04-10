output "code_build_role_arn" {
  value = aws_iam_role.codebuild-role.arn
}

output "code_pipeline_role_arn" {
  value = aws_iam_role.codepipeline-role.arn
}