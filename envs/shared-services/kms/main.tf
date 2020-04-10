resource "aws_kms_key" "artifacts-key" {}
resource "aws_kms_alias" "alias" {
  name = "alias/artifacts"
  target_key_id = aws_kms_key.artifacts-key.key_id
}

resource "aws_kms_key" "artifacts-key-eu-west-1" {
  provider = aws.eu-west-1
}
resource "aws_kms_alias" "alias-eu-west-1" {
  provider = aws.eu-west-1
  name = "alias/artifacts-eu-west-1"
  target_key_id = aws_kms_key.artifacts-key-eu-west-1.key_id
}




