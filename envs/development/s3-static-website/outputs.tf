output "bucket_arn" {
  value = module.s3-static-website.bucket_arn
}

output "bucket_name" {
  value = module.s3-static-website.bucket_name
}

output "bucket_regional_domain_name" {
  value = module.s3-static-website.bucket_regional_domain_name
}

output "website_endpoint" {
  value = module.s3-static-website.website_endpoint
}
