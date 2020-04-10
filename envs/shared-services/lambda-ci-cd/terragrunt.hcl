include {
  path = find_in_parent_folders()
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs_allowed_terraform_commands = [
    "validate",
    "plan",
    "destroy"]

  mock_outputs = {
    key_id = "fake__key_id"
    key_alias_arn = "fake__key_alias_arn"
    key_id_eu_west_1 = "fake__key_id_eu_west_1"
    key_alias_arn_eu_west_1 = "fake__key_alias_arn_eu_west_1"
  }
}


inputs = {
  kms__key_id = dependency.kms.outputs.key_id
  kms__key_alias_arn = dependency.kms.outputs.key_alias_arn
  kms__key_id_eu_west_1 = dependency.kms.outputs.key_id_eu_west_1
  kms__key_alias_arn_eu_west_1 = dependency.kms.outputs.key_alias_arn_eu_west_1
}