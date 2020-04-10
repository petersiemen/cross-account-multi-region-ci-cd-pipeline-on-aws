resource "aws_codecommit_repository" "repository" {
  repository_name = var.name
}
