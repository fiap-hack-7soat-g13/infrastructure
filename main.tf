terraform {
  backend "s3" {
    bucket = "terraform-state-c0496bfa"
    key    = "infrastructure"
    region = "us-east-1"
  }
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
    rabbitmq = {
      source = "cyrilgdn/rabbitmq"
    }
  }
}
provider "aws" {
  region = var.region
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}
