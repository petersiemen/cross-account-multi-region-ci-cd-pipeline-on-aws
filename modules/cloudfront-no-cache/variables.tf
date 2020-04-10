variable "name" {}
variable "bucket_regional_domain_name" {}
variable "website_endpoint" {}
variable "api_gateway_deployment_invoke_url" {}

variable "aliases" {
  type = list(string)
}
variable "acm_certification_arn" {}