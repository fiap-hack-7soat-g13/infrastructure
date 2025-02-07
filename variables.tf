variable "region" {
  default = "us-east-1"
}
variable "db_username" {
  default = "root"
}
variable "db_password" {
  sensitive = true
}
variable "mq_username" {
  default = "root"
}
variable "mq_password" {
  sensitive = true
}
variable "domain" {
  default = "challenge.dev.br"
}
