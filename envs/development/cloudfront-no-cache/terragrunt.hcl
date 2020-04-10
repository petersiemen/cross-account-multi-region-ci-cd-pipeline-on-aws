include {
  path = find_in_parent_folders()
}


dependency "certificates" {
  config_path = "../certificates"
  mock_outputs_allowed_terraform_commands = [
    "validate",
    "plan",
    "destroy"]

  mock_outputs = {
    acm_certification_arn = "fake___acm_certification_arn"
  }
}


dependency "s3-static-website" {
  config_path = "../s3-static-website"
  mock_outputs_allowed_terraform_commands = [
    "validate",
    "plan",
    "destroy"]

  mock_outputs = {
    bucket_name = "fake___bucket_name"
    website_endpoint = "fake__website_endpoint"
  }
}

dependency "api-gateway" {
  config_path = "../api-gateway"
  mock_outputs_allowed_terraform_commands = [
    "validate",
    "plan",
    "destroy"]

  mock_outputs = {
    deployment_invoke_url = "fake___deployment_invoke_url"
  }
}

inputs = {
  certificates__acm_certification_arn = dependency.certificates.outputs.acm_certification_arn

  s3_static_website__bucket_name = dependency.s3-static-website.outputs.bucket_name
  s3_static_website__website_endpoint = dependency.s3-static-website.outputs.website_endpoint
  s3_static_website__bucket_regional_domain_name = dependency.s3-static-website.outputs.bucket_regional_domain_name

  api_gateway__deployment_invoke_url = dependency.api-gateway.outputs.deployment_invoke_url
}
