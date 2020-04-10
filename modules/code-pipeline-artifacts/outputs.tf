output "arn" {
  value = aws_s3_bucket.code-pipeline-artifacts.arn
}

output "bucket" {
  value = aws_s3_bucket.code-pipeline-artifacts.bucket
}

output "id" {
  value = aws_s3_bucket.code-pipeline-artifacts.id
}