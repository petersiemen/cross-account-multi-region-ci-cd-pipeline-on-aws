output "key_id" {
  value = aws_kms_key.artifacts-key.key_id
}

output "key_alias_arn" {
  value = aws_kms_alias.alias.arn
}

output "key_id_eu_west_1" {
  value = aws_kms_key.artifacts-key-eu-west-1.key_id
}

output "key_alias_arn_eu_west_1" {
  value = aws_kms_alias.alias-eu-west-1.arn
}