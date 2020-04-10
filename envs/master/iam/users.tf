resource "aws_iam_user" "peter" {
  name = "peter"
  path = "/terraform/"
  force_destroy = true
}