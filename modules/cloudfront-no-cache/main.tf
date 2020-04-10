locals {
  s3_origin_id = "S3-${var.bucket_regional_domain_name}"
}

resource "aws_cloudfront_distribution" "no-cache" {
  origin {
    domain_name = var.website_endpoint
    origin_id = local.s3_origin_id
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = [
        "TLSv1.1"]
    }
  }

  origin {
    domain_name = trimsuffix(trimprefix(var.api_gateway_deployment_invoke_url, "https://"), "/prod")
    origin_id = trimsuffix(trimprefix(var.api_gateway_deployment_invoke_url, "https://"), "/prod")
    origin_path = "/prod"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1.1"]
    }
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"]
    cached_methods = [
      "GET",
      "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
    viewer_protocol_policy = "redirect-to-https"
    compress = true

  }


  ordered_cache_behavior {
    path_pattern = "/api/*"

    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"]
    cached_methods = [
      "GET",
      "HEAD"]

    target_origin_id = trimsuffix(trimprefix(var.api_gateway_deployment_invoke_url, "https://"), "/prod")

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = var.acm_certification_arn
    ssl_support_method = "sni-only"
  }
}