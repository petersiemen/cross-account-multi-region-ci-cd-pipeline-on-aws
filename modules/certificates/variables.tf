variable "domain_name" {}
variable "zones" {
  type = list(string)
}
variable "subject_alternative_names" {
  type = list(string)
}
