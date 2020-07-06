
resource "aws_s3_bucket" "datasets" {
  bucket = "datasets-av2eegh9"
  acl = "private"

  #force_destroy = false
}