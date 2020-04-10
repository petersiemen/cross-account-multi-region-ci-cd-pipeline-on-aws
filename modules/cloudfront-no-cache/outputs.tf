output "domain_name" {
  value = aws_cloudfront_distribution.no-cache.domain_name
}
output "hosted_zone_id" {
  value = aws_cloudfront_distribution.no-cache.hosted_zone_id
}