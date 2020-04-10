output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "website_endpoint" {
  value = aws_s3_bucket.bucket.website_endpoint
}

output "website" {
  value = aws_s3_bucket.bucket.website
}